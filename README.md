# whoami for Windows
[![Build status](https://ci.appveyor.com/api/projects/status/bhma7tmx0eje73ao/branch/master?svg=true)](https://ci.appveyor.com/project/StefanScherer/whoami/branch/master)

Simple HTTP docker service that prints it's container ID

    $ docker run -d -p 8000:8000 --name whoami -t stefanscherer/whoami-windows
    736ab83847bb12dddd8b09969433f3a02d64d5b0be48f7a5c59a594e3a6a3541

    $ (iwr http://$(docker inspect -f '{{ .NetworkSettings.Networks.nat.IPAddress }}' whoami):8000 -UseBasicParsing).Content
    I'm 736ab83847bb
