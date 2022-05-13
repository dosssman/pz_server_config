#!/bin/bash
VULTR_API_KEY=$(cat ./../VULTR_API_KEY)

curl "https://api.vultr.com/v2/ssh-keys" \
  -X GET \
  -H "Authorization: Bearer ${VULTR_API_KEY}" > ssh_key_list.txt