#Requires -Version 7.0
[CmdletBinding()]
param([string]$Project, [string]$EngineRoot)
. "$PSScriptRoot/Common.ps1"
$Project = Resolve-ArenaProject $Project
Resolve-ArenaEngine $Project $EngineRoot
