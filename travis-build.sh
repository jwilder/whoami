#!/bin/bash
set -e

docker version
uname -a
echo "Updating Docker engine to 17.05.0"
sudo service docker stop
curl -fsSL https://get.docker.com/ | sudo sh
docker version

if [ "$ARCH" != "amd64" ]; then
  # prepare qemu
  docker run --rm --privileged multiarch/qemu-user-static:register --reset

  if [ "$ARCH" == "arm64" ]; then
    # prepare qemu binary
    docker create --name register hypriot/qemu-register
    docker cp register:qemu-aarch64 qemu-aarch64-static
  fi
fi

if [ -d tmp ]; then
  docker rm build
  rm -rf tmp
fi

docker build -t whoami -f "Dockerfile.$ARCH" .
