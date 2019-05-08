#!/bin/bash 

if [[ ! -e "$1" ]]; then
    echo "Backup File <${1}> does not exist"
    exit -1
fi

docker run \
       --rm \
       --volumes-from asterisk \
       -w / \
       -v $(pwd):/backup \
       docker.high-con.de/alpine-mini-amd64:3.9.3 \
       tar xzvf /backup/${1}

