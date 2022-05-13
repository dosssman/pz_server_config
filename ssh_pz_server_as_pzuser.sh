#!/bin/bash

# In case it is the first time the server was started, upload the JSSB server configutation files.
PZ_SERVER_IP=$(cat ./PZ_SERVER_IP)

if [ -z $PZ_SERVER_IP ]; then
    echo "No server IP detected. Aborting..."
    exit
fi

ssh pzuser@${PZ_SERVER_IP}
