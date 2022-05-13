#!/bin/bash
VULTR_API_KEY=$(cat ./VULTR_API_KEY)
LAST_PZ_SERVER_SUBID=$(cat ./LAST_PZ_SERVER_SUBID)

curl "https://api.vultr.com/v2/instances/${LAST_PZ_SERVER_SUBID}" \
  -X GET \
  --silent \
  -H "Authorization: Bearer ${VULTR_API_KEY}" | jq -r .instance | jq -r .main_ip
