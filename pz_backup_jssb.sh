#!/bin/bash
PZ_SERVER_IP=$(cat ./PZ_SERVER_IP)

# Backup date
CURRENT_DATE=$(date +"%Y_%m_%d__%H_%M_%S")

BACKUP_DIRNAME="backups/Zomboid_bak_${CURRENT_DATE}"

if [ ! -d "backups" ]; then
    mkdir backups
fi

if [ ! -d $BACKUP_DIRNAME ]; then
    mkdir $BACKUP_DIRNAME -p
fi

rsync -ravu pzuser@$PZ_SERVER_IP:/home/pzuser/Zomboid "$BACKUP_DIRNAME""/." --info=progress
