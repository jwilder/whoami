# whoami for Windows

Simple HTTP docker service that prints it's container ID

    $ docker run -d -p 8000:8000 --name whoami -t stefanscherer/whoami-windows
    736ab83847bb12dddd8b09969433f3a02d64d5b0be48f7a5c59a594e3a6a3541

    $ iwr http://$(docker inspect -f '{{ .NetworkSettings.Networks.nat.IPAddress }}' whoami):8000
    I'm 736ab83847bb
