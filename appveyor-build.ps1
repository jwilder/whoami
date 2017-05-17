$ErrorActionPreference = 'Stop';
$files = ""
Write-Host Starting build

Write-Host Updating base images
docker pull microsoft/nanoserver

docker version
Write-Host Updating Docker engine to master
Stop-Service docker
$version = "17.05.0-ce"
$wc = New-Object net.webclient
$wc.DownloadFile("https://get.docker.com/builds/Windows/x86_64/docker-$version.zip", "$env:TEMP\docker.zip")
Expand-Archive -Path "$env:TEMP\docker.zip" -DestinationPath $env:ProgramFiles -Force
Remove-Item "$env:TEMP\docker.zip"
Start-Service docker
docker version

docker build -t whoami -f Dockerfile.windows .

docker images
