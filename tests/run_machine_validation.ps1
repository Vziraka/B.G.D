# Explicit NON-BIOMETRIC validation only. Run from a normal PowerShell shell.
# Review it and the named suite, then approve its one administrator test process.
# No production key, camera, microphone or Windows verification prompt is used.
param(
    [Parameter(Mandatory=$true)][string]$PythonPath,
    [int]$CoordinatorProcessId = 0,
    [string]$ValidationRun = ''
)

$ErrorActionPreference = 'Stop'
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal]::new($identity)
$repoPath = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$pythonExecutable = (Resolve-Path -LiteralPath $PythonPath).Path
if ([IO.Path]::GetFileName($pythonExecutable) -ne 'python.exe') {
    throw 'Select the reviewed CPython 3.13.12 python.exe.'
}
$reportDirectory = Join-Path $repoPath '.scratch\pc-biometric-desk'
if (!$principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $ValidationRun = [guid]::NewGuid().ToString('N')
    $testArguments = @('-NoProfile', '-File', ('"' + $PSCommandPath + '"'),
                      '-PythonPath', ('"' + $pythonExecutable + '"'),
                      '-CoordinatorProcessId', "$PID", '-ValidationRun', $ValidationRun)
    $systemPowerShell = Join-Path ([Environment]::SystemDirectory) 'WindowsPowerShell\v1.0\powershell.exe'
    $testProcess = Start-Process -FilePath $systemPowerShell -Verb RunAs `
        -ArgumentList $testArguments -WindowStyle Hidden -PassThru
    # This actual unelevated process supplies the token for permission checks.
    # Keeping it alive avoids substituting an unusable identification-only token.
    $testProcess.WaitForExit()
    $reportPath = Join-Path $reportDirectory ("machine-validation." + $ValidationRun + '.log')
    $exitPath = Join-Path $reportDirectory ("machine-validation." + $ValidationRun + '.exit')
    Get-Content -LiteralPath $reportPath
    Write-Output ("Evidence: " + $reportPath)
    exit ([int](Get-Content -LiteralPath $exitPath -Raw))
}
if ($CoordinatorProcessId -le 0 -or $ValidationRun -cnotmatch '^[0-9a-f]{32}$') {
    throw 'Start this runner from a normal shell so the actual unelevated coordinator remains available.'
}
$env:BGD_VALIDATION_UNELEVATED_PID = "$CoordinatorProcessId"
$startInfo = [Diagnostics.ProcessStartInfo]::new()
$startInfo.FileName = $pythonExecutable
$startInfo.Arguments = '-m unittest discover -s tests -p machine_authority_validation.py -v'
$startInfo.WorkingDirectory = $repoPath
$startInfo.UseShellExecute = $false
$startInfo.CreateNoWindow = $true
$startInfo.RedirectStandardOutput = $true
$startInfo.RedirectStandardError = $true
$testProcess = [Diagnostics.Process]::Start($startInfo)
$standardOutput = $testProcess.StandardOutput.ReadToEndAsync()
$standardError = $testProcess.StandardError.ReadToEndAsync()
$testProcess.WaitForExit()
$reportPath = Join-Path $reportDirectory ("machine-validation." + $ValidationRun + '.log')
$exitPath = Join-Path $reportDirectory ("machine-validation." + $ValidationRun + '.exit')
Set-Content -LiteralPath $reportPath -Value ($standardOutput.Result + $standardError.Result) -Encoding UTF8
Set-Content -LiteralPath $exitPath -Value $testProcess.ExitCode -Encoding UTF8
exit $testProcess.ExitCode
