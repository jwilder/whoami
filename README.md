# whoami multi-arch image
[![Build status](https://ci.appveyor.com/api/projects/status/bhma7tmx0eje73ao/branch/master?svg=true)](https://ci.appveyor.com/project/StefanScherer/whoami/branch/master)
[![Build Status](https://travis-ci.org/StefanScherer/whoami.svg?branch=master)](https://travis-ci.org/StefanScherer/whoami)
[![This image on DockerHub](https://img.shields.io/docker/pulls/stefanscherer/whoami.svg)](https://hub.docker.com/r/stefanscherer/whoami/)

## Linux

Simple HTTP docker service that prints it's container ID

    $ docker run -d -p 8080:8080 --name whoami -t stefanscherer/whoami
    736ab83847bb12dddd8b09969433f3a02d64d5b0be48f7a5c59a594e3a6a3541

    $ curl http://localhost:8080
    I'm 736ab83847bb

## Windows

Simple HTTP docker service that prints it's container ID

    $ docker run -d -p 8080:8080 --name whoami -t stefanscherer/whoami
    736ab83847bb12dddd8b09969433f3a02d64d5b0be48f7a5c59a594e3a6a3541

    $ (iwr http://$(docker inspect -f '{{ .NetworkSettings.Networks.nat.IPAddress }}' whoami):8080 -UseBasicParsing).Content
    I'm 736ab83847bb

Used for a first [swarm-mode demo](https://github.com/StefanScherer/docker-windows-box/tree/master/swarm-mode) with Windows containers.
