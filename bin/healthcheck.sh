#!/bin/bash

fs_cli -x status | grep -q ^UP || exit 1

SOFIA_EXISTS=$(fs_cli -x "module_exists mod_sofia")
if [ "$SOFIA_EXISTS" != "true" ]; then
    echo "mod_sofia not loaded"
    exit 1
fi

PROFILE_RUNNING=$(fs_cli -x "sofia status" | grep -cE "profile\s+.*RUNNING")
if [ "$PROFILE_RUNNING" -eq 0 ]; then
    echo "No profile running"
    exit 1
fi
