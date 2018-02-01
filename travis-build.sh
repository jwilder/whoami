#!/bin/bash
set -e

docker version

if [ -d tmp ]; then
  docker rm build
  rm -rf tmp
fi

docker build -t whoami --build-arg "arch=$ARCH" .
