$ErrorActionPreference = 'Stop'

$projectRoot = $PSScriptRoot
$javaRoot = 'C:\Program Files\Java'
$java17 = Get-ChildItem -Path $javaRoot -Directory -Filter 'jdk-17*' -ErrorAction SilentlyContinue |
  Select-Object -First 1

if (-not $java17) {
  throw "Java 17 was not found under $javaRoot. Install JDK 17 before running the portal."
}

$nodeVersionText = (& node -p 'process.versions.node').Trim()
if ($LASTEXITCODE -ne 0) {
  throw 'Node.js was not found. Install Node.js 22.13 or newer.'
}
$nodeVersion = [version]$nodeVersionText
if ($nodeVersion -lt [version]'22.13') {
  throw "Node.js 22.13 or newer is required; found $nodeVersionText."
}

$env:JAVA_HOME = $java17.FullName
$javaBin = Join-Path $java17.FullName 'bin'
$env:PATH = $javaBin + [IO.Path]::PathSeparator + $env:PATH
$env:LOCAL_ONLY = '1'
if (-not $env:PORT) { $env:PORT = '3002' }

Write-Host "Using Java 17 at $env:JAVA_HOME"
Write-Host "Starting local portal at http://127.0.0.1:$env:PORT"
Push-Location (Join-Path $projectRoot 'execution-service')
try {
  npm start
} finally {
  Pop-Location
}
