#!/bin/bash

docker run \
       --rm \
       --volumes-from asterisk \
       --volume $(pwd):/backups \
       docker.high-con.de/alpine-mini-amd64:3.9.3 \
       tar zcf /backups/asterisk_backup_$(date '+%Y%m%d%H%M%S').tar.gz \
       /var/lib/asterisk/sounds \
       /var/lib/asterisk/keys \
       /var/lib/asterisk/phoneprov \
       /var/spool/asterisk \
       /var/log/asterisk \
       /etc/asterisk

# behalte nur die letzten 10 backups lösche den rest
c=0
for item in `ls -t asterisk_backup_*.tar.gz` ; do
    c=$(($c + 1))
    if [ $c -gt 9 ] ; then
	rm -f $item
    fi
done

