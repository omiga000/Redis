$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$config = Join-Path $root '.local/redis.conf'
if (!(Test-Path -LiteralPath $config)) { throw '缺少本机 Redis 配置，请先按开发说明配置 Redis。' }
$pidFile = Join-Path $root '.run/redis.pid'
New-Item -ItemType Directory -Path (Join-Path $root '.run') -Force | Out-Null
if (Test-Path -LiteralPath $pidFile) {
    $recorded = Get-Content -LiteralPath $pidFile -Raw
    if ($recorded -match '^\s*(\d+)\s*$') {
        $existing = Get-CimInstance Win32_Process -Filter "ProcessId = $($Matches[1])" -ErrorAction SilentlyContinue
        if ($existing -and $existing.CommandLine -and $existing.CommandLine.Contains($config)) {
            Write-Host '练习版 Redis 已运行：127.0.0.1:16379'
            exit 0
        }
    }
}
$server = (Get-Command redis-server -ErrorAction Stop).Source
$process = Start-Process -FilePath $server -ArgumentList @(('"' + $config + '"')) -WorkingDirectory $root -WindowStyle Hidden -PassThru
Set-Content -LiteralPath $pidFile -Value $process.Id -Encoding ascii
Write-Host '练习版 Redis 已启动：127.0.0.1:16379；数据位于 .run/redis-data。'
