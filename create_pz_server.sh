#!/bin/bash
# Vultr API V2 Support
VULTR_API_KEY=$(cat ./VULTR_API_KEY)

REGION=cdg # Japan (JP): nrt; France (FR): cdg; Germany (DE): fra
PLAN=vc2-2c-4gb # Shared Insances; 2 vCPU, 4GB RAM
LABEL="PZSteamDediServerNode"
OS_ID=387 # 387 Ubutun 20.04
SSH_KEYS="a6fb92f8-b8d1-47c9-9511-8f2dc116714b,6bc9749a-ad09-4d35-add4-fc41afeb8341,164f25b6-55ff-44c8-a82c-f2bb784fd766"
STARTUP_SCRIPTS="e1e46aeb-b960-42b4-a63d-9a6a16d258e5"

RESPONSE=$(curl "https://api.vultr.com/v2/instances" \
  -X POST \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{"region":"mad", "plan":"vc2-2c-4gb", "label":"PZSteamDediServerNode", "os_id":387, "sshkey_id":["a6fb92f8-b8d1-47c9-9511-8f2dc116714b","6bc9749a-ad09-4d35-add4-fc41afeb8341","164f25b6-55ff-44c8-a82c-f2bb784fd766"], "script_id": "e1e46aeb-b960-42b4-a63d-9a6a16d258e5","backups":"disabled","hostname":"PZSteamDediServerNode"}')

INSTANCE_ID=$(echo $RESPONSE | jq -r .instance | jq -r .id)
echo $INSTANCE_ID > LAST_PZ_SERVER_SUBID

# DEBUG
cat ./LAST_PZ_SERVER_SUBID

sleep 20

echo $NEW_SERVER_IP > PZ_SERVER_IP
