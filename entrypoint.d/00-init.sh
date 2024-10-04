#!/bin/bash

NEWLINE=$'\n'
started_file="/var/switch/.started"

set_owner() {
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
}



if [ ! -e $started_file ]; then
  echo "----- Initializing -----$NEWLINE"
  
  set_owner

  touch $started_file

  envsubst < /etc/switch/templates/vars.template          > /etc/switch/conf/env.xml
else
  echo "----- Container initialized -----$NEWLINE"
fi