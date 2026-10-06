#Requires -Version 7.0
[CmdletBinding()]
param([string]$Project, [string]$EngineRoot)
. "$PSScriptRoot/Common.ps1"
$Project = Resolve-ArenaProject $Project
$ue = Resolve-ArenaEngine $Project $EngineRoot
$evidence = New-ArenaEvidence 'editor'
# This command explicitly launches the interactive editor requested by the caller.
$process = Start-Process -FilePath $ue.Editor -ArgumentList @(('"{0}"' -f $Project), ('-abslog="{0}"' -f (Join-Path $evidence 'Unreal.log'))) -PassThru
Write-Host "Editor PID $($process.Id); log: $evidence/Unreal.log. Launch is not a startup verification."
