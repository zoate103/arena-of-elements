#Requires -Version 7.0
[CmdletBinding()]
param([string]$Project)
. "$PSScriptRoot/Common.ps1"
$Project = Resolve-ArenaProject $Project
$data = Get-Content -LiteralPath $Project -Raw | ConvertFrom-Json
if (!$data.PSObject.Properties['Modules'] -or 'LyraGame' -notin @($data.Modules.Name)) { throw 'This is not a Lyra project. No changes made.' }
$null = Resolve-ArenaEngine $Project
$root = Split-Path $Project
foreach ($process in @(Get-CimInstance Win32_Process -Filter "name='UnrealEditor.exe'")) {
    if ($process.CommandLine -and $process.CommandLine.Contains($Project)) { throw 'Close this Lyra Editor before changing its plugins.' }
}
$source = Join-Path $script:RepoRoot 'ArenaOfElements'
$files = @(Get-ChildItem $source -File -Recurse | Where-Object { $_.FullName -notmatch '[\\/](Binaries|Intermediate|Saved|__pycache__)[\\/]' })
# Preflight every destination before copying anything. Never overwrite divergent files.
foreach ($file in $files) {
    $relative = [IO.Path]::GetRelativePath($source, $file.FullName)
    $target = Join-Path $root $relative
    if ((Test-Path $target) -and (Get-FileHash $target).Hash -ne (Get-FileHash $file.FullName).Hash) { throw "Existing file differs; reconcile manually: $target" }
}
foreach ($file in $files) {
    $target = Join-Path $root ([IO.Path]::GetRelativePath($source, $file.FullName))
    if (!(Test-Path $target)) {
        New-Item -ItemType Directory (Split-Path $target) -Force | Out-Null
        Copy-Item -LiteralPath $file.FullName -Destination $target
    }
}
if (!$data.PSObject.Properties['Plugins']) { $data | Add-Member Plugins @() }
foreach ($name in @('GameplayAbilities','Niagara','GameFeatures','ArenaOfElements','ArenaSetupAutomation','PythonScriptPlugin','EditorScriptingUtilities')) {
    $entry = @($data.Plugins | Where-Object Name -EQ $name)
    if ($entry.Count -gt 1) { throw "Duplicate plugin entry: $name" }
    if (!$entry.Count) { $plugin = [pscustomobject]@{Name=$name;Enabled=$true}; $data.Plugins = @($data.Plugins) + $plugin }
    else { $plugin = $entry[0]; $plugin.Enabled = $true }
    if ($name -in @('ArenaSetupAutomation','PythonScriptPlugin','EditorScriptingUtilities')) {
        $plugin | Add-Member TargetAllowList @('Editor') -Force
    }
}
$updated = $data | ConvertTo-Json -Depth 30
if ((Get-Content $Project -Raw).Trim() -ne $updated.Trim()) {
    $backup = "$Project.backup-$(Get-Date -Format yyyyMMdd-HHmmss)-$([guid]::NewGuid().ToString('N').Substring(0,8))"
    Copy-Item -LiteralPath $Project -Destination $backup
    $updated | Set-Content -LiteralPath $Project -Encoding utf8
    Write-Host "Updated plugins. Project backup: $backup"
}
Write-Host 'Lyra setup layer installed. Run Build-Editor, Python validation and Run-Tests next.'
