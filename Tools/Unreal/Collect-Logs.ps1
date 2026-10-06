#Requires -Version 7.0
[CmdletBinding()]
param([string]$Project)
. "$PSScriptRoot/Common.ps1"
$Project = Resolve-ArenaProject $Project
$evidence = New-ArenaEvidence 'collected-logs'
$sources = @((Join-Path (Split-Path $Project) 'Saved/Logs'), (Join-Path $env:LOCALAPPDATA 'UnrealBuildTool'))
foreach ($kind in @('build','python','tests','editor')) {
    $latest = Get-ChildItem (Join-Path $script:RepoRoot 'artifacts/setup') -Directory -Filter "$kind-*" |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($latest) { $sources += $latest.FullName }
}
$index = @()
for ($i=0; $i -lt $sources.Count; $i++) {
    $files = @(Get-ChildItem $sources[$i] -File -Filter '*.log' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 3)
    foreach ($file in $files) {
        $target = Join-Path $evidence "$i-$($file.Name)"
        Copy-Item -LiteralPath $file.FullName -Destination $target
        $index += @{ source=$file.FullName; copy=$target; modified=$file.LastWriteTimeUtc.ToString('o') }
    }
}
ConvertTo-Json -InputObject $index -Depth 4 | Set-Content (Join-Path $evidence 'manifest.json')
Write-Host "Collected $($index.Count) log(s): $evidence"
