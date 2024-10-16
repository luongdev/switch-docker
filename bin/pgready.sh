#!/bin/bash

check_db_ready() {
  PGPASSWORD=$password psql -h "$host" -p "$port" -U "$user" -d "$dbname" -c '\q' &>/dev/null
  if [ $? -eq 0 ]; then
    echo "Database is ready"
    return 0
  else
    return 1
  fi
}

wait_for_ready=false
dbname="postgres"
max_wait_time=60

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --host|-h) host="$2"; shift ;;
    --port|-p) port="$2"; shift ;;
    --user|-U) user="$2"; shift ;;
    --passwd|-P) password="$2"; shift ;;
    --dbname|-d) dbname="$2"; shift ;;
    --wait|-w) wait_for_ready=true ;;
    --timeout|-t) max_wait_time="$2"; shift ;;
    *) echo "Unknown parameter: $1"; exit 1 ;;
  esac
  shift
done

if [ -z "$host" ] || [ -z "$port" ] || [ -z "$user" ] || [ -z "$password" ]; then
  echo "Usage: $0 --host <host> --port <port> --user <user> --passwd <password> [--dbname <dbname>] [--wait] [--timeout <seconds>]"
  echo "Or with short args: -h <host> -P <port> -u <user> -p <password> [-d <dbname>] [-w] [-t <seconds>]"
  exit 1
fi

if [ "$wait_for_ready" = true ]; then
  echo "Waiting for database to be ready: $max_wait_time sec(s)..."
  start_time=$(date +%s)
  
  while true; do
    if check_db_ready; then
      exit 0
    else
      echo "Database is not ready, checking again in 1 second..."
      sleep 1
    fi
    
    current_time=$(date +%s)
    elapsed_time=$(( current_time - start_time ))

    if [ "$elapsed_time" -ge "$max_wait_time" ]; then
      echo "Timeout reached: $max_wait_time sec(s). Exiting with success (exit code 0)."
      exit 0
    fi
  done
else
  if check_db_ready; then
    exit 0
  else
    echo "Database is not ready"
    exit 1
  fi
fi
