#!/bin/bash
VULTR_API_KEY=$(cat ./../VULTR_API_KEY)

curl "https://api.vultr.com/v2/startup-scripts" \
  -X GET \
  -H "Authorization: Bearer ${VULTR_API_KEY}" > startup_scripts_list.txt