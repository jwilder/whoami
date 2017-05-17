#!/bin/bash
set -e

image="stefanscherer/whoami"
docker tag whoami "$image:linux-$ARCH-$TRAVIS_TAG"
docker push "$image:linux-$ARCH-$TRAVIS_TAG"

if [ "$ARCH" == "amd64" ]; then
  set +e
  echo "Waiting for other images $image:linux-arm-$TRAVIS_TAG"
  until docker run --rm stefanscherer/winspector "$image:linux-arm-$TRAVIS_TAG"
  do
    sleep 15
    echo "Try again"
  done
  until docker run --rm stefanscherer/winspector "$image:linux-arm64-$TRAVIS_TAG"
  do
    sleep 15
    echo "Try again"
  done
  until docker run --rm stefanscherer/winspector "$image:windows-amd64-$TRAVIS_TAG"
  do
    sleep 15
    echo "Try again"
  done
  set -e

  echo "Downloading docker client with manifest command"
  wget https://github.com/StefanScherer/dockerfiles-windows/releases/download/2017-05-17-docker-manifest/docker-linux-amd64
  mv docker-linux-amd64 docker
  chmod +x docker

  echo "Pushing manifest $image:$TRAVIS_TAG"
  ./docker manifest create "$image:$TRAVIS_TAG" \
    "$image:linux-amd64-$TRAVIS_TAG" \
    "$image:linux-arm-$TRAVIS_TAG" \
    "$image:linux-arm64-$TRAVIS_TAG" \
    "$image:windows-amd64-$TRAVIS_TAG"
  ./docker manifest annotate "$image:$TRAVIS_TAG" "$image:linux-arm-$TRAVIS_TAG" --os linux --arch arm
  ./docker manifest annotate "$image:$TRAVIS_TAG" "$image:linux-arm64-$TRAVIS_TAG" --os linux --arch arm64
  ./docker manifest push "$image:$TRAVIS_TAG"

  echo "Pushing manifest $image:latest"
  ./docker manifest create "$image:latest" \
    "$image:linux-amd64-$TRAVIS_TAG" \
    "$image:linux-arm-$TRAVIS_TAG" \
    "$image:linux-arm64-$TRAVIS_TAG" \
    "$image:windows-amd64-$TRAVIS_TAG"
  ./docker manifest annotate "$image:$TRAVIS_TAG" "$image:linux-arm-$TRAVIS_TAG" --os linux --arch arm
  ./docker manifest annotate "$image:$TRAVIS_TAG" "$image:linux-arm64-$TRAVIS_TAG" --os linux --arch arm64
  ./docker manifest push "$image:latest"
fi
