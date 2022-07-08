#!/bin/bash 
VERSION=$(git log -1 --pretty=%h)
REPO="robinsalehjan/tilde:"

TAG="$REPO$VERSION"
LATEST="${REPO}latest"

BUILD_TIMESTAMP=$( date '+%F_%H:%M:%S' )

docker build -t "$TAG" -t "$LATEST" --build-arg VERSION="$VERSION" --build-arg BUILD_TIMESTAMP="$BUILD_TIMESTAMP" . 
docker push "$TAG" 
docker push "$LATEST"