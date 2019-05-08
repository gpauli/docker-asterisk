FROM docker.high-con.de/alpine-mini-amd64:3.9.3

MAINTAINER Gerd Pauli <gp@high-consulting.de>

RUN apk add --update \
      asterisk \
      asterisk-sample-config \
      asterisk-fax \
      asterisk-sounds-moh \
      asterisk-sounds-en \
      mpg123 \
      emacs-nox \
      mc \
      tiff-tools \
      mini-sendmail \
      mutt \
      && asterisk -U asterisk \
      && sleep 5 \
      && pkill -9 asterisk \
      && pkill -9 astcanary \
      && sleep 2 \
      && rm -rf /var/run/asterisk/* \
      && mkdir -p /var/spool/asterisk/fax \
      && chown -R asterisk: /var/spool/asterisk/fax \
      && truncate -s 0 /var/log/asterisk/messages \
      /var/log/asterisk/queue_log \
      &&  rm -rf /var/cache/apk/* \
      /tmp/* \
      /var/tmp/*

EXPOSE 5060/udp 5060/tcp
VOLUME /var/lib/asterisk/sounds /var/lib/asterisk/moh /var/lib/asterisk/keys /var/lib/asterisk/phoneprov /var/spool/asterisk /var/lib/asterisk/scripts /var/log/asterisk /etc/asterisk

ADD docker-entrypoint.sh /docker-entrypoint.sh
ADD fax2mail /var/lib/asterisk/scripts/fax2mail

ENTRYPOINT ["/docker-entrypoint.sh"]
