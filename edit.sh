#!/bin/bash

tmpdir=$(mktemp -d /tmp/docker-asterisk.XXXXXX)
trap 'rm -rf -- "$tmpdir"' INT TERM HUP EXIT

echo "**** container:/tmp -> $tmpdir"
docker run -it --rm --volumes-from asterisk --volume $tmpdir:/tmp docker.high-con.de/alpine-mini-amd64:3.9.3 /bin/sh


