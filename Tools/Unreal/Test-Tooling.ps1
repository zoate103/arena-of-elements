#Requires -Version 7.0
[CmdletBinding()]
param()
. "$PSScriptRoot/Common.ps1"
$errors = @()
Get-ChildItem "$PSScriptRoot/*.ps1" | ForEach-Object {
    $tokens = $null; $parseErrors = $null
    $null = [System.Management.Automation.Language.Parser]::ParseFile($_.FullName, [ref]$tokens, [ref]$parseErrors)
    $errors += $parseErrors
}
if ($errors.Count) { throw ($errors | Out-String) }
$evidence = New-ArenaEvidence 'tooling-tests'
$pwsh = (Get-Process -Id $PID).Path
foreach ($case in @('success', 'failure', 'timeout')) {
    $folder = Join-Path $evidence $case
    New-Item -ItemType Directory $folder | Out-Null
    $scriptFile = Join-Path $folder 'script with spaces.ps1'
    $body = switch ($case) {
        'success' { "Write-Output 'stdout proof'; [Console]::Error.WriteLine('stderr proof'); exit 0" }
        'failure' { 'exit 17' }
        'timeout' { 'Start-Sleep -Seconds 30' }
    }
    $body | Set-Content $scriptFile
    $failed = $false
    try { Invoke-ArenaProcess $pwsh @('-NoProfile','-File',$scriptFile) $folder 2 }
    catch { $failed = $true }
    $result = Get-Content (Join-Path $folder 'command.json') -Raw | ConvertFrom-Json
    if ($case -eq 'success' -and ($failed -or $result.exitCode -ne 0)) { throw 'Success/space-path handling failed' }
    if ($case -eq 'success') {
        if ((Get-Content (Join-Path $folder 'stdout.log') -Raw).Trim() -ne 'stdout proof') { throw 'stdout capture failed' }
        if ((Get-Content (Join-Path $folder 'stderr.log') -Raw).Trim() -ne 'stderr proof') { throw 'stderr capture failed' }
    }
    if ($case -eq 'failure' -and (!$failed -or $result.exitCode -ne 17)) { throw 'Nonzero exit was not preserved' }
    if ($case -eq 'timeout' -and (!$failed -or !$result.timedOut)) { throw 'Timeout was not detected' }
}
$badLog = Join-Path $evidence 'expected-error.log'
'LogGameFeatures: Error: deliberate fixture' | Set-Content $badLog
$rejected = $false
try { Assert-ArenaLog $badLog } catch { $rejected = $true }
if (!$rejected) { throw 'Logged Unreal error was accepted' }
Write-Host "TOOLING TESTS PASS: parser, paths with spaces, nonzero exit, log error and bounded timeout ($evidence)"
