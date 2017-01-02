$ErrorActionPreference = 'Stop';
$files = ""
Write-Host Starting build

Write-Host Updating base images
docker pull microsoft/windowsservercore
docker pull microsoft/nanoserver

Write-Host Removing old images
$ErrorActionPreference = 'SilentlyContinue';
docker rmi $(docker images --no-trunc --format '{{.Repository}}:{{.Tag}}' | sls -notmatch -pattern '(REPOSITORY|microsoft\/(windowsservercore|nanoserver))')
$ErrorActionPreference = 'Stop';
Write-Host Prune system
docker system prune -f

docker build -t httpbuild -f Dockerfile.build .
docker create --name httpbuild httpbuild
docker cp httpbuild:/code/http.exe tmp
docker build -t whoami .

docker images
