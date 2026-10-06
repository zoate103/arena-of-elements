#Requires -Version 7.0
[CmdletBinding()]
param([string]$Project, [string]$EngineRoot, [string]$Filter='ArenaOfElements', [switch]$Render, [int]$TimeoutSeconds=1200)
. "$PSScriptRoot/Common.ps1"
if ($Filter -notmatch '^[A-Za-z0-9_.]+$') { throw 'Test filter must be a dotted automation namespace.' }
$Project = Resolve-ArenaProject $Project
$ue = Resolve-ArenaEngine $Project $EngineRoot
$evidence = New-ArenaEvidence 'tests'
$log = Join-Path $evidence 'Unreal.log'
$report = Join-Path $evidence 'report'
$arguments = @($Project, '-unattended', '-nop4', '-nosplash', '-stdout', '-FullStdOutLogOutput', '-culture=en', '-LogCmds=LogAutomationTest Log', "-abslog=$log", "-ExecCmds=Automation RunTests $Filter", '-TestExit=Automation Test Queue Empty', "-ReportExportPath=$report")
if (!$Render) { $arguments += '-NullRHI' }
Invoke-ArenaProcess $ue.EditorCmd $arguments $evidence $TimeoutSeconds
Assert-ArenaLog $log
$index = Join-Path $report 'index.json'
if (!(Test-Path $index)) { throw "Automation did not produce a report: $report" }
$result = Get-Content $index -Raw | ConvertFrom-Json
$tests = @($result.tests)
if (!$tests.Count) { throw 'Zero tests discovered; this is not a pass.' }
$failures = @($tests | Where-Object { $_.state -notin @('Success', 'SuccessWithWarnings') })
if ($failures.Count) { throw "$($failures.Count) test(s) failed or did not finish. See $index" }
Write-Host "AUTOMATION PASS: $($tests.Count) test(s) ($index)"
