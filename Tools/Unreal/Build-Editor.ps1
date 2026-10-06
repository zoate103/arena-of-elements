#Requires -Version 7.0
[CmdletBinding()]
param([string]$Project, [string]$EngineRoot, [string]$Target, [switch]$GenerateProjectFiles, [int]$TimeoutSeconds=3600)
. "$PSScriptRoot/Common.ps1"
$Project = Resolve-ArenaProject $Project
$ue = Resolve-ArenaEngine $Project $EngineRoot
if (!$Target) {
    $targets = @(Get-ChildItem (Join-Path (Split-Path $Project) 'Source') -Filter '*Editor.Target.cs' -File)
    if ($targets.Count -ne 1) { throw 'Cannot determine unique Editor target. Pass -Target.' }
    $Target = $targets[0].Name -replace '\.Target\.cs$', ''
}
$evidence = New-ArenaEvidence 'build'
if ($GenerateProjectFiles) {
    $generation = Join-Path $evidence 'generation'
    New-Item -ItemType Directory $generation | Out-Null
    Invoke-ArenaProcess $ue.DotNet @($ue.UBT, '-ProjectFiles', "-Project=$Project", '-Game', '-Engine', '-NoIntelliSense') $generation $TimeoutSeconds
}
Invoke-ArenaProcess $ue.DotNet @($ue.UBT, $Target, 'Win64', 'Development', "-Project=$Project", '-WaitMutex', '-NoHotReloadFromIDE', '-NoLiveCoding', "-Log=$evidence/UnrealBuildTool.log") $evidence $TimeoutSeconds
Write-Host "BUILD PASS: $Target ($evidence)"
