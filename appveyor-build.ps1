$ErrorActionPreference = 'Stop';
$files = ""
Write-Host Starting build

Write-Host Updating base images
docker pull microsoft/nanoserver

docker build -t whoami -f Dockerfile.windows .

docker images
