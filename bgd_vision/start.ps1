param([switch]$NoBrowser)
$ErrorActionPreference = 'Stop'
$bgdKey = Join-Path $env:USERPROFILE '.ssh/bgd_pi_codex_ed25519'
$bgdDestination = 'bgd-pi@bgd-pi.local'
$bgdRemote = @'
set -eu
cd "$HOME/bgd-vision"
mkdir -p logs
if ! pgrep -f '^/home/bgd-pi/bgd-vision/.venv/bin/python -m bgd_vision ' >/dev/null; then
    PYTHONPATH="$HOME/bgd-vision/candidates/boxmot25" nohup /home/bgd-pi/bgd-vision/.venv/bin/python -m bgd_vision --model /home/bgd-pi/bgd-vision/models/yolo26n_ncnn_model >logs/service.log 2>&1 </dev/null &
fi
'@
$bgdPayload = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($bgdRemote.Replace("`r", '') + "`n"))
ssh -i $bgdKey -o IdentitiesOnly=yes -o BatchMode=yes -o ConnectTimeout=10 $bgdDestination "printf '%s' '$bgdPayload' | base64 -d | sh"
if ($LASTEXITCODE -ne 0) { throw 'Could not start the Pi application.' }
$bgdListener = Get-NetTCPConnection -LocalPort 8765 -State Listen -ErrorAction SilentlyContinue
if (-not $bgdListener) {
    Start-Process -FilePath 'ssh.exe' -WindowStyle Hidden -ArgumentList @('-i', ('"' + $bgdKey + '"'), '-o', 'IdentitiesOnly=yes', '-o', 'BatchMode=yes', '-o', 'ExitOnForwardFailure=yes', '-o', 'ServerAliveInterval=15', '-o', 'ServerAliveCountMax=3', '-N', '-L', '127.0.0.1:8765:127.0.0.1:8765', $bgdDestination)
}
$bgdReady = $false
for ($bgdAttempt = 0; $bgdAttempt -lt 15; $bgdAttempt++) {
    try {
        $bgdStatus = Invoke-RestMethod 'http://127.0.0.1:8765/status' -TimeoutSec 2
        if ($null -eq $bgdStatus.model) { throw 'Port 8765 is occupied by another service.' }
        if ($bgdStatus.error) { throw $bgdStatus.error }
        $bgdReady = $true
        break
    } catch { $bgdLastError = $_.Exception.Message; Start-Sleep -Seconds 1 }
}
if (-not $bgdReady) { throw "Local preview is unavailable: $bgdLastError. Check Pi logs/service.log and the SSH tunnel." }
Write-Output 'Camera desk: http://127.0.0.1:8765/ (model startup can take a moment)'
if (-not $NoBrowser) { Start-Process 'http://127.0.0.1:8765/' }
