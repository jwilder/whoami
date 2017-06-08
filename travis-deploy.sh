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

  echo "Downloading manifest-tool"
  wget https://github.com/estesp/manifest-tool/releases/download/v0.5.0/manifest-tool-linux-amd64
  mv manifest-tool-linux-amd64 manifest-tool
  chmod +x manifest-tool
  ./manifest-tool

  echo "Pushing manifest $image:$TRAVIS_TAG"
  ./manifest-tool push from-args \
    --platforms linux/amd64,linux/arm,linux/arm64,windows/amd64 \
    --template "$image:OS-ARCH-$TRAVIS_TAG" \
    --target "$image:$TRAVIS_TAG"

  echo "Pushing manifest $image:latest"
  ./manifest-tool push from-args \
    --platforms linux/amd64,linux/arm,linux/arm64,windows/amd64 \
    --template "$image:OS-ARCH-$TRAVIS_TAG" \
    --target "$image:latest"
fi
