$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$nginx = Join-Path $root 'nginx-1.18.0'
$prefix = $nginx.Replace('\','/') + '/'
& (Join-Path $nginx 'nginx.exe') -p $prefix -c conf/nginx.conf -t
if ($LASTEXITCODE -ne 0) { throw '前端配置检查失败。' }
$pidFile = Join-Path $nginx 'logs/nginx.pid'
if (Test-Path -LiteralPath $pidFile) {
    $savedPid = [string](Get-Content -LiteralPath $pidFile -Raw)
    $existing = $null
    if ($savedPid -match '^\s*(\d+)\s*$') {
        $existing = Get-Process -Id ([int]$Matches[1]) -ErrorAction SilentlyContinue
    }
    if ($existing -and $existing.Path -eq (Join-Path $nginx 'nginx.exe')) {
        Write-Host '本练习版前端已运行：http://127.0.0.1:18080'
        exit 0
    }
}
Start-Process -FilePath (Join-Path $nginx 'nginx.exe') -ArgumentList @('-p', $prefix, '-c', 'conf/nginx.conf') -WorkingDirectory $nginx -WindowStyle Hidden
Write-Host '前端地址：http://127.0.0.1:18080'
