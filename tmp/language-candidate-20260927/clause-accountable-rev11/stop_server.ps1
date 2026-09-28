param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('rev11-open-run')]
    [string]$Label
)

$readyPath = Join-Path $PSScriptRoot ($Label + '-server-ready.json')
$stopPath = Join-Path $PSScriptRoot ($Label + '-server-stop.json')
$ready = Get-Content -Raw -LiteralPath $readyPath | ConvertFrom-Json
$serverProcessId = [int]$ready.pid
$process = Get-Process -Id $serverProcessId -ErrorAction SilentlyContinue
if ($null -ne $process) {
    Stop-Process -Id $serverProcessId -Force
    Start-Sleep -Milliseconds 500
}
$stillRunning = $true
for ($attempt = 0; $attempt -lt 20; $attempt++) {
    $remainingProcess = Get-Process -Id $serverProcessId -ErrorAction SilentlyContinue
    if ($null -eq $remainingProcess) {
        $stillRunning = $false
        break
    }
    Start-Sleep -Milliseconds 250
}
$listener = @(Get-NetTCPConnection -State Listen -LocalPort 8084 -ErrorAction SilentlyContinue)
$result = [ordered]@{
    pid = $serverProcessId
    process_stopped = -not $stillRunning
    loopback_listener_remaining = $listener.Count -gt 0
    remaining_listener_addresses = @($listener | ForEach-Object { $_.LocalAddress })
}
$result | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $stopPath -Encoding utf8
Get-Content -Raw -LiteralPath $stopPath
if ($stillRunning -or $listener.Count -gt 0) { exit 1 }
