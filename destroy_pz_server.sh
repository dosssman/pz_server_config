#!/bin/bash
VULTR_API_KEY=$(cat ./VULTR_API_KEY)
LAST_PZ_SERVER_SUBID=$(cat ./LAST_PZ_SERVER_SUBID)

curl "https://api.vultr.com/v2/instances/${LAST_PZ_SERVER_SUBID}" \
  -X DELETE \
  -H "Authorization: Bearer ${VULTR_API_KEY}"

echo "" > LAST_PZ_SERVER_SUBID
echo "" > PZ_SERVER_IP
