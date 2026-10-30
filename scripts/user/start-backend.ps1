param([switch]$Build)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$project = Join-Path $root 'hm-dianping'
$jar = Join-Path $project 'target/hm-dianping-0.0.1-SNAPSHOT.jar'
Push-Location $project
try {
    if ($Build -or !(Test-Path -LiteralPath $jar)) {
        & mvn '-DskipTests' package
        if ($LASTEXITCODE -ne 0) { throw '构建失败，请查看上面的错误。' }
    }
    Write-Host '后端地址：http://127.0.0.1:18081，按 Ctrl+C 停止。'
    & java -jar $jar
    if ($LASTEXITCODE -ne 0) { throw '后端启动失败。' }
} finally { Pop-Location }
