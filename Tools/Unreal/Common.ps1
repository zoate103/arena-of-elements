#Requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$script:RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path

function Resolve-ArenaProject {
    param([string]$Project)
    if ($Project) { return (Resolve-Path -LiteralPath $Project).Path }
    $candidates = @(Get-ChildItem (Join-Path $script:RepoRoot 'GameDirectory') -Filter '*.uproject' -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
        $data = Get-Content -LiteralPath $_.FullName -Raw | ConvertFrom-Json
        $data.PSObject.Properties['Modules'] -and 'LyraGame' -in @($data.Modules.Name)
    })
    if ($candidates.Count -ne 1) { throw "Expected one Lyra project under GameDirectory; found $($candidates.Count). See docs/setup/NEXT_AGENT_HANDOFF.md, or pass -Project explicitly." }
    return $candidates[0].FullName
}

function Resolve-ArenaEngine {
    param([string]$Project, [string]$EngineRoot)
    $descriptor = Get-Content -LiteralPath $Project -Raw | ConvertFrom-Json
    $association = $descriptor.EngineAssociation
    $roots = [System.Collections.Generic.List[string]]::new()
    if ($EngineRoot) { $roots.Add($EngineRoot) }
    elseif ($env:UE_ROOT) { $roots.Add($env:UE_ROOT) }
    else {
        $builds = Get-ItemProperty 'HKCU:\Software\Epic Games\Unreal Engine\Builds' -ErrorAction SilentlyContinue
        if ($builds -and $builds.PSObject.Properties[$association]) { $roots.Add($builds.$association) }
        $registered = Get-ItemProperty "HKLM:\SOFTWARE\EpicGames\Unreal Engine\$association" -ErrorAction SilentlyContinue
        if ($registered -and $registered.PSObject.Properties['InstalledDirectory']) { $roots.Add($registered.InstalledDirectory) }
        $manifest = Join-Path $env:ProgramData 'Epic/UnrealEngineLauncher/LauncherInstalled.dat'
        if (Test-Path $manifest) {
            foreach ($entry in (Get-Content $manifest -Raw | ConvertFrom-Json).InstallationList) {
                if ($entry.AppName -eq "UE_$association") { $roots.Add($entry.InstallLocation) }
            }
        }
        $roots.Add((Join-Path $env:ProgramFiles "Epic Games/UE_$association"))
    }
    foreach ($root in ($roots | Select-Object -Unique)) {
        $versionFile = Join-Path $root 'Engine/Build/Build.version'
        if (!(Test-Path $versionFile)) { continue }
        $version = Get-Content $versionFile -Raw | ConvertFrom-Json
        if ($association -match '^\d+\.\d+$' -and "$($version.MajorVersion).$($version.MinorVersion)" -ne $association) {
            throw "Engine version mismatch: project requests $association, candidate is $versionFile."
        }
        $editor = Join-Path $root 'Engine/Binaries/Win64/UnrealEditor.exe'
        $cmd = Join-Path $root 'Engine/Binaries/Win64/UnrealEditor-Cmd.exe'
        $ubt = Join-Path $root 'Engine/Binaries/DotNET/UnrealBuildTool/UnrealBuildTool.dll'
        if (!(Test-Path $editor) -or !(Test-Path $cmd) -or !(Test-Path $ubt)) { continue }
        $runtimes = @(Get-ChildItem (Join-Path $root 'Engine/Binaries/ThirdParty/DotNet') -Filter dotnet.exe -Recurse -File | Where-Object FullName -Match 'win-x64')
        if ($runtimes.Count -ne 1) { throw "Expected one bundled x64 .NET runtime at $root; found $($runtimes.Count)." }
        return [pscustomobject]@{ Root=$root; Editor=$editor; EditorCmd=$cmd; UBT=$ubt; DotNet=$runtimes[0].FullName; Version="$($version.MajorVersion).$($version.MinorVersion).$($version.PatchVersion)"; Project=$Project }
    }
    throw "No complete engine for association '$association'. Install it through Epic Launcher or set UE_ROOT."
}

function New-ArenaEvidence {
    param([string]$Name)
    $id = (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N').Substring(0,8)
    $path = Join-Path $script:RepoRoot "artifacts/setup/$Name-$id"
    New-Item -ItemType Directory -Path $path -Force | Out-Null
    return $path
}

function Invoke-ArenaProcess {
    param([string]$Executable, [string[]]$Arguments, [string]$Evidence, [int]$TimeoutSeconds = 1800)
    $start = [System.Diagnostics.ProcessStartInfo]::new()
    $start.FileName = $Executable
    $start.WorkingDirectory = $script:RepoRoot
    $start.UseShellExecute = $false
    $start.CreateNoWindow = $true
    $start.RedirectStandardOutput = $true
    $start.RedirectStandardError = $true
    foreach ($argument in $Arguments) { $start.ArgumentList.Add($argument) }
    $record = [ordered]@{ executable=$Executable; arguments=$Arguments; startedUtc=[DateTime]::UtcNow.ToString('o'); exitCode=$null; timedOut=$false }
    $record | ConvertTo-Json -Depth 5 | Set-Content (Join-Path $Evidence 'command.json')
    $process = [System.Diagnostics.Process]::new()
    $process.StartInfo = $start
    $started = $false
    try {
        if (!$process.Start()) { throw 'Process could not start.' }
        $started = $true
        $stdout = $process.StandardOutput.ReadToEndAsync()
        $stderr = $process.StandardError.ReadToEndAsync()
        Write-Host "Running PID $($process.Id); evidence: $Evidence"
        $deadline = [DateTime]::UtcNow.AddSeconds($TimeoutSeconds)
        while (!$process.WaitForExit(1000)) {
            if ([DateTime]::UtcNow -gt $deadline) {
                $record.timedOut = $true
                $process.Kill($true)
                $process.WaitForExit()
                break
            }
        }
        $stdout.GetAwaiter().GetResult() | Set-Content (Join-Path $Evidence 'stdout.log')
        $stderr.GetAwaiter().GetResult() | Set-Content (Join-Path $Evidence 'stderr.log')
        $record.exitCode = $process.ExitCode
        $record | ConvertTo-Json -Depth 5 | Set-Content (Join-Path $Evidence 'command.json')
        if ($record.timedOut) { throw "Timed out after $TimeoutSeconds seconds. Evidence: $Evidence" }
        if ($process.ExitCode -ne 0) { throw "Process exited $($process.ExitCode). Evidence: $Evidence" }
    }
    finally {
        if ($started -and !$process.HasExited) { $process.Kill($true) }
        $process.Dispose()
    }
}

function Assert-ArenaLog {
    param([string]$Log)
    if (!(Test-Path -LiteralPath $Log)) { throw "Expected Unreal log was not created: $Log" }
    $fatal = Select-String -LiteralPath $Log -Pattern 'Fatal error:|Unhandled Exception:|Ensure condition failed:|:\s*Error:'
    if ($fatal) { throw "Unreal log contains errors or a failed ensure. See $Log" }
}
