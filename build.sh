#!/bin/bash
docker build -t httpbuild -f Dockerfile.build .
docker rm -f httpbuild
docker create --name httpbuild httpbuild
rm -rf tmp
mkdir tmp
docker cp httpbuild:/code/http.exe tmp
docker build -t whoami .
