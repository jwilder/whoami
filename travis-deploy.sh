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
  wget https://5028-88013053-gh.circle-artifacts.com/1/work/build/docker-linux-amd64
  mv docker-linux-amd64 docker
  chmod +x docker
  ./docker version
  
  set -x
  
  echo "Pushing manifest $image:$TRAVIS_TAG"
  ./docker -D manifest create "$image:$TRAVIS_TAG" \
    "$image:linux-amd64-$TRAVIS_TAG" \
    "$image:linux-arm-$TRAVIS_TAG" \
    "$image:linux-arm64-$TRAVIS_TAG" \
    "$image:windows-amd64-$TRAVIS_TAG"
  ./docker manifest annotate "$image:$TRAVIS_TAG" "$image:linux-arm-$TRAVIS_TAG" --os linux --arch arm
  ./docker manifest annotate "$image:$TRAVIS_TAG" "$image:linux-arm64-$TRAVIS_TAG" --os linux --arch arm64
  ./docker manifest push "$image:$TRAVIS_TAG"

  echo "Pushing manifest $image:latest"
  ./docker -D manifest create "$image:latest" \
    "$image:linux-amd64-$TRAVIS_TAG" \
    "$image:linux-arm-$TRAVIS_TAG" \
    "$image:linux-arm64-$TRAVIS_TAG" \
    "$image:windows-amd64-$TRAVIS_TAG"
  ./docker manifest annotate "$image:latest" "$image:linux-arm-$TRAVIS_TAG" --os linux --arch arm
  ./docker manifest annotate "$image:latest" "$image:linux-arm64-$TRAVIS_TAG" --os linux --arch arm64
  ./docker manifest push "$image:latest"

  echo "Downloading manifest-tool"
  wget https://github.com/estesp/manifest-tool/releases/download/v0.6.0/manifest-tool-linux-amd64
  mv manifest-tool-linux-amd64 manifest-tool
  chmod +x manifest-tool
  ./manifest-tool

  echo "Pushing manifest $image:$TRAVIS_TAG"
  ./manifest-tool push from-args \
    --platforms linux/amd64,linux/arm,linux/arm64,windows/amd64 \
    --template "$image:OS-ARCH-$TRAVIS_TAG" \
    --target "$image:$TRAVIS_TAG-manifest-tool"

  echo "Pushing manifest $image:latest"
  ./manifest-tool push from-args \
    --platforms linux/amd64,linux/arm,linux/arm64,windows/amd64 \
    --template "$image:OS-ARCH-$TRAVIS_TAG" \
    --target "$image:latest-manifest-tool"
fi
