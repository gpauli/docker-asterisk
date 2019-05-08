#!/bin/bash

#VERSION=`git ls-remote -t https://github.com/splitbrain/dokuwiki \
#| grep -Po '(?<=release_stable_)[0-9a-z-]*' \
#| sort -ubt - -k 1,1nr -k 2,2nr -k 3,3r \
#| head -n 1`
#       --build-arg BASEVERSION=`git rev-parse --short HEAD` \

VERSION=15.7.1
DOCKER_REPO=docker.high-con.de
IMAGE_NAME=asterisk

docker build \
       --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
       --build-arg VERSION=$VERSION \
       -t makeit_asterisk .

docker tag makeit_asterisk ${DOCKER_REPO}/${IMAGE_NAME}:${VERSION}
docker push ${DOCKER_REPO}/${IMAGE_NAME}:${VERSION}


