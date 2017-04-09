Write-Host Starting test

$ErrorActionPreference = 'SilentlyContinue';
docker kill whoamitest
docker rm -f whoamitest

$ErrorActionPreference = 'Stop';
Write-Host Starting container
docker run --name whoamitest -p 8080:8080 -d whoami
Start-Sleep 15
Write-Host Testing from another container
docker run --rm microsoft/nanoserver powershell -command invoke-webrequest -usebasicparsing http://whoamitest:8080

$ErrorActionPreference = 'SilentlyContinue';
docker kill whoamitest
docker rm -f whoamitest
