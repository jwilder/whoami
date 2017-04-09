#!/bin/bash
set -e

which docker

systemctl stop docker

echo "Updating Docker engine to master"
curl -L -o /usr/local/bin/docker-containerd https://master.dockerproject.org/linux/amd64/docker-containerd
curl -L -o /usr/local/bin/docker-containerd-ctr https://master.dockerproject.org/linux/amd64/docker-containerd-ctr
curl -L -o /usr/local/bin/docker-containerd-shim https://master.dockerproject.org/linux/amd64/docker-containerd-shim
curl -L -o /usr/local/bin/dockerd https://master.dockerproject.org/linux/amd64/dockerd
curl -L -o /usr/local/bin/docker-init https://master.dockerproject.org/linux/amd64/docker-init
curl -L -o /usr/local/bin/docker-proxy https://master.dockerproject.org/linux/amd64/docker-proxy
curl -L -o /usr/local/bin/docker-runc https://master.dockerproject.org/linux/amd64/docker-runc
curl -L -o /usr/local/bin/docker https://master.dockerproject.org/linux/amd64/docker

systemctl start docker

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
