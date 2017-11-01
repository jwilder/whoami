$ErrorActionPreference = 'Stop';
$files = ""
Write-Host Starting build

docker build --pull -t whoami -f Dockerfile.windows .

docker images
