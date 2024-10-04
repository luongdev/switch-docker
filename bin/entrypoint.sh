#!/bin/bash

directory="/entrypoint.d"
file_ext=".sh"

for file in "$directory"/*; do
  if [[ "$file" == *"$file_ext" ]]; then
    sh -c "$file"
  fi
done

trap 'freeswitch -stop' SIGTERM

chown switch:switch /dev/stdout
gosu switch freeswitch -u switch -g switch -nc -nf -nonat -c &
pid="$!"

wait $pid
exit 0
