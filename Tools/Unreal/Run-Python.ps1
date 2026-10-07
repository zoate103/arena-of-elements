#Requires -Version 7.0
[CmdletBinding()]
param([Parameter(Mandatory)][string]$Script, [string]$Project, [string]$EngineRoot, [switch]$FullEditor, [switch]$Render, [switch]$Isolated, [int]$TimeoutSeconds=1200)
. "$PSScriptRoot/Common.ps1"
$Project = Resolve-ArenaProject $Project
$ue = Resolve-ArenaEngine $Project $EngineRoot
if (!(Test-Path -LiteralPath $Script)) { $Script = Join-Path (Split-Path $Project) "Content/Python/arena_setup/$Script" }
$Script = (Resolve-Path -LiteralPath $Script).Path
$evidence = New-ArenaEvidence 'python'
$log = Join-Path $evidence 'Unreal.log'
# A fresh wrapper produces a completion marker only after the requested script returns.
$wrapper = Join-Path $evidence 'invoke.py'
$pyPath = ConvertTo-Json $Script -Compress
$expected = ConvertTo-Json ([IO.Path]::GetFileNameWithoutExtension($Project)) -Compress
@"
import os, runpy, unreal
os.environ['ARENA_EXPECTED_PROJECT'] = $expected
runpy.run_path($pyPath, run_name='__main__')
unreal.log('ARENA_PYTHON_COMPLETED_SUCCESSFULLY')
"@ | Set-Content -LiteralPath $wrapper -Encoding utf8
$arguments = @($Project, '-unattended', '-nop4', '-nosplash', '-stdout', '-FullStdOutLogOutput', '-culture=en', '-LogCmds=LogAutomationTest Log', "-abslog=$log")
if ($Isolated) {
    # Keep the automation process's Saved/Search database and user settings separate
    # from an interactive editor already using this project. Source/Content stay put.
    $userDir = Join-Path $evidence 'UserData'
    New-Item -ItemType Directory -Path $userDir | Out-Null
    $arguments += "-UserDir=$userDir"
}
if (!$Render) { $arguments += '-NullRHI' }
if ($FullEditor) { $arguments += "-ExecutePythonScript=$wrapper" }
else { $arguments += @('-run=pythonscript', "-script=$wrapper") }
Invoke-ArenaProcess $ue.EditorCmd $arguments $evidence $TimeoutSeconds
Assert-ArenaLog $log
if (!(Select-String -LiteralPath $log -SimpleMatch 'LogPython: ARENA_PYTHON_COMPLETED_SUCCESSFULLY')) { throw "Python did not complete: $log" }
Write-Host "PYTHON PASS: $Script ($evidence)"
