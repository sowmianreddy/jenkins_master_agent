#!/bin/bash

set -eo pipefail

usage() {
  echo "USAGE: $0 TARGET"
  echo "  - TARGET: The image to build (master|agent)" 
  echo
  echo "  Environment variables supported:"
  echo "  - IMG_TAG: The tag to give the built image. Defaults to git tag or commit hash"
  echo "  - GCP_PROJECT_ID: The GCP Project ID for the registry to push to"
  echo "  - IMAGE_NAME: The name to give the built Docker image"
  echo "  - DOCKER_ARGS: A single string containing a set of arguments to pass to the build, e.g. '--build-arg DOCKER_GID=412'"
  echo
  exit $1
}

# Get build target
TARGET="$1"
if [ "$TARGET" == "help" ]; then
  usage 0
elif [ -z "$TARGET" ] || ([ "$TARGET" != "master" ] && [ "$TARGET" != "agent" ]); then
  usage 1
fi

if [ "$TARGET" == "master" ]; then
  IMAGE_NAME="sowmianreddy/jenkins-master"
else
  IMAGE_NAME="sowmianreddy/jenkins-agent"
fi

IMG_TAG="latest"

# Build Jenkins image
docker build -f "$TARGET/Dockerfile" -t $IMAGE_NAME:$IMG_TAG .

docker push "$IMAGE_NAME:$IMG_TAG"
