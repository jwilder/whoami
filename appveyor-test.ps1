Write-Host Starting test

$ErrorActionPreference = 'SilentlyContinue';
docker kill whoamitest
docker rm -f whoamitest

$ErrorActionPreference = 'Stop';
Write-Host Starting container
docker run --name whoamitest -p 8080:8080 -d whoami
Start-Sleep 10

docker logs whoamitest

$ErrorActionPreference = 'SilentlyContinue';
docker kill whoamitest
docker rm -f whoamitest
