#!/bin/bash
#        --publish 10.1.1.10:80:8080 \
#	   --ip 10.1.2.35 \
#	   --network docker-dmz \

docker start asterisk
if [ $? -ne 0 ] ; then
    docker run \
	   -d \
	   --cap-add SYS_ADMIN \
	   --name asterisk \
	   --ip 192.168.178.4 \
	   --dns 192.168.178.1 \
	   --network docker-adsl \
	   --hostname voip.high-consulting.de \
	   docker.high-con.de/asterisk:15.7.1
fi
./firewall.sh set

