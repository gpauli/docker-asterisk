#!/bin/sh

# run as user asterisk by default
ASTERISK_USER=${ASTERISK_USER:-asterisk}
ASTERISK_GROUP=${ASTERISK_GROUP:-${ASTERISK_USER}}

if [ "$1" = "" ]; then
    COMMAND="/usr/sbin/asterisk -T -W -U ${ASTERISK_USER} -p -vvvdddf"
else
    COMMAND="$@"
fi

if [ "${ASTERISK_UID}" != "" ] && [ "${ASTERISK_GID}" != "" ]; then
    # recreate user and group for asterisk
    # if they've sent as env variables (i.e. to macth with host user to fix permissions for mounted folders

    deluser asterisk && \
	addgroup -g ${ASTERISK_GID} ${ASTERISK_GROUP} && \
	adduser -D -H -u ${ASTERISK_UID} -G ${ASTERISK_GROUP} ${ASTERISK_USER} \
	    || exit
fi

if [ -e "/var/log/asterisk/messages" ] ; then
    mv /var/log/asterisk/messages /var/log/asterisk/messages.`date '+%Y%m%d%H%M%S'`
fi

# behalte nur die letzten 10 backups lösche den rest
c=0
for item in `ls -t /var/log/asterisk/messages.*` ; do
    c=$(($c + 1))
    if [ $c -gt 9 ] ; then
	rm -f $item
    fi
done

chown -R ${ASTERISK_USER}: /var/log/asterisk \
      /var/lib/asterisk \
      /var/run/asterisk \
      /var/spool/asterisk; \
exec ${COMMAND}
