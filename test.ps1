$ErrorActionPreference = 'Stop';
Write-Host Starting test

docker kill whoamitest
docker rm -f whoamitest

docker run --name whoamitest -p 8000:8000 -d whoami
$ip=$(docker inspect -f '{{ .NetworkSettings.Networks.nat.IPAddress  }}' whoamitest)
docker run --rm microsoft/nanoserver powershell -command invoke-webrequest -usebasicparsing http://$($ip):8000

docker kill whoamitest
docker rm -f whoamitest
