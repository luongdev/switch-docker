#!/bin/bash

mkdir -p \
  /etc/switch/data \
  /var/switch \
  /var/log/switch \
  /usr/local/db

useradd -u 1000 -U -d /etc/switch/data -s /bin/bash switch

chown -R switch:switch \
  /etc/switch \
  /var/switch \
  /usr/local \
  /var/log/switch

trap 'freeswitch -stop' SIGTERM

gosu switch freeswitch -u switch -g switch -nc -nf -nonat -c &
pid="$!"

wait $pid
exit 0
