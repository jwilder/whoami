#!/bin/bash
set -e

echo "Updating Docker engine to master"
sudo service docker stop
sudo curl -L -o /usr/bin/docker-containerd https://master.dockerproject.org/linux/amd64/docker-containerd
sudo curl -L -o /usr/bin/docker-containerd-ctr https://master.dockerproject.org/linux/amd64/docker-containerd-ctr
sudo curl -L -o /usr/bin/docker-containerd-shim https://master.dockerproject.org/linux/amd64/docker-containerd-shim
sudo curl -L -o /usr/bin/dockerd https://master.dockerproject.org/linux/amd64/dockerd
sudo curl -L -o /usr/bin/docker-init https://master.dockerproject.org/linux/amd64/docker-init
sudo curl -L -o /usr/bin/docker-proxy https://master.dockerproject.org/linux/amd64/docker-proxy
sudo curl -L -o /usr/bin/docker-runc https://master.dockerproject.org/linux/amd64/docker-runc
sudo curl -L -o /usr/bin/docker https://master.dockerproject.org/linux/amd64/docker
sudo service docker start
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
