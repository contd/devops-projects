#!/usr/bin/env bash

if [[ -z $DIGITALOCEAN_API_TOKEN ]];then
  ansi --red "DIGITALOCEAN_API_TOKEN not set!"
  exit 1
fi

curl -s -X GET \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${DIGITALOCEAN_API_TOKEN}" \
  "https://api.digitalocean.com/v2/sizes" \
  | jq .

exit 0