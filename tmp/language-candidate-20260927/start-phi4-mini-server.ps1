$ErrorActionPreference = "Stop"
$root = (Resolve-Path ".").Path
$modelRelative = "tmp/language-candidate-20260927/phi4-mini-instruct-q4_k_m.gguf"
$runtimeRelative = "tmp/language-candidate-20260922/windows/llama-server.exe"
$modelPath = (Resolve-Path $modelRelative).Path
$exePath = (Resolve-Path $runtimeRelative).Path
$model = Get-Item -LiteralPath $modelPath
$modelHash = (Get-FileHash -LiteralPath $modelPath -Algorithm SHA256).Hash.ToLowerInvariant()
$runtimeHash = (Get-FileHash -LiteralPath $exePath -Algorithm SHA256).Hash.ToLowerInvariant()
if ($model.Length -ne 2491874688 -or $modelHash -ne "01999f17c39cc3074afae5e9c539bc82d45f2dd7faa3917c66cbef76fce8c0c2") {
    throw "Pinned Phi GGUF failed size/hash verification"
}
if ($runtimeHash -ne "786eea5d9ca4a4257aa175f363338f90e0eb109360b139654c44333d4d129f23") {
    throw "Existing llama.cpp runtime hash changed"
}
if (@(Get-NetTCPConnection -LocalPort 8081 -State Listen -ErrorAction SilentlyContinue).Count -gt 0) {
    throw "Port 8081 already has a listener"
}
$stdoutPath = Join-Path $root "tmp/language-candidate-20260927/phi4-mini-server.stdout.log"
$stderrPath = Join-Path $root "tmp/language-candidate-20260927/phi4-mini-server.stderr.log"
$pidPath = Join-Path $root "tmp/language-candidate-20260927/phi4-mini-server.pid"
$arguments = "-m `"$modelPath`" --host 127.0.0.1 --port 8081 -t 2 -tb 2 -c 2048 -np 1 --jinja --no-webui"
$server = Start-Process -FilePath $exePath -ArgumentList $arguments -WorkingDirectory $root -WindowStyle Hidden -PassThru -RedirectStandardOutput $stdoutPath -RedirectStandardError $stderrPath
Set-Content -LiteralPath $pidPath -Value $server.Id -NoNewline
for ($attempt = 0; $attempt -lt 120; $attempt++) {
    try {
        $response = Invoke-WebRequest -UseBasicParsing -Uri "http://127.0.0.1:8081/health" -TimeoutSec 1
        if ($response.StatusCode -eq 200) {
            [pscustomobject]@{ Pid = $server.Id; Address = "127.0.0.1"; Port = 8081; Health = $response.StatusCode }
            exit 0
        }
    } catch {
        Start-Sleep -Milliseconds 1000
    }
}
Get-Content -LiteralPath $stderrPath -Tail 40
Stop-Process -Id $server.Id -Force -ErrorAction SilentlyContinue
throw "Loopback Phi server did not become healthy"
