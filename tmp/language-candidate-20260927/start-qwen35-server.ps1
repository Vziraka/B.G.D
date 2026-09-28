$ErrorActionPreference = "Stop"
$root = (Resolve-Path ".").Path
$modelPath = (Resolve-Path "tmp/language-candidate-20260926/qwen35-4b-q4_k_m.gguf").Path
$exePath = (Resolve-Path "tmp/language-candidate-20260922/windows/llama-server.exe").Path
$stdoutPath = Join-Path $root "tmp/language-candidate-20260927/qwen35-integrated-server.stdout.log"
$stderrPath = Join-Path $root "tmp/language-candidate-20260927/qwen35-integrated-server.stderr.log"
$pidPath = Join-Path $root "tmp/language-candidate-20260927/qwen35-integrated-server.pid"
$arguments = "-m `"$modelPath`" --host 127.0.0.1 --port 8081 -t 2 -tb 2 -c 2048 -np 1 --jinja --no-webui"
$server = Start-Process -FilePath $exePath -ArgumentList $arguments -WorkingDirectory $root -WindowStyle Hidden -PassThru -RedirectStandardOutput $stdoutPath -RedirectStandardError $stderrPath
Set-Content -LiteralPath $pidPath -Value $server.Id -NoNewline
for ($attempt = 0; $attempt -lt 60; $attempt++) {
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
Get-Content -LiteralPath $stderrPath -Tail 30
Stop-Process -Id $server.Id -Force -ErrorAction SilentlyContinue
throw "Loopback server did not become healthy"
