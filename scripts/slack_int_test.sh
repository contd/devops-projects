#!/usr/bin/env bash

curl -X POST --data-urlencode \
  "payload={\"channel\": \"#alerts\", \"username\": \"webhookbot\", \"text\": \"This is posted to #general and comes from a bot named webhookbot.\", \"icon_emoji\": \":ghost:\"}" \
  https://hooks.slack.com/services/TXXXXXXXX/BYYYYYYYY/dddddddddddddddddddddddd