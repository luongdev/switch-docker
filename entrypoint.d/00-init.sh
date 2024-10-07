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

get_dsn() {
  local db_host=${DB_HOST:-localhost}
  local db_port=${DB_PORT:-5432}
  local db_name=${DB_NAME:-switch}
  local db_user=${DB_USER:-postgres}
  local db_pass=${DB_PASS:-}
  local db_opts=${DB_OPTS:-}

  echo "pgsql://hostaddr=$db_host port=$db_port dbname=$db_name user=$db_user password=$db_pass options='$db_opts'"
}

ser_vars() {
  export DSN=$(get_dsn)
  echo "DSN: $DSN"

  envsubst < /etc/switch/templates/vars.template          > /etc/switch/conf/env.xml
}

if [ ! -e $started_file ]; then
  echo "----- Initializing -----$NEWLINE"
  
  set_owner
  ser_vars

  touch $started_file
else
  echo "----- Container initialized -----$NEWLINE"
fi