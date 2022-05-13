#!/bin/bash
VULTR_API_KEY=$(cat ./../VULTR_API_KEY)

curl "https://api.vultr.com/v2/regions" \
  -X GET \
  -H "Authorization: Bearer ${VULTR_API_KEY}" > regions_list.txt