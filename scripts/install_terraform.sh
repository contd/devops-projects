#!/usr/bin/env bash

TERRAFORM_URL="https://releases.hashicorp.com/terraform/"
TERRAFORM_VER=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform  | jq -r -M '.current_version')
TERRAFORM_ZIP="terraform_${TERRAFORM_VER}_linux_amd64.zip"
TERRAFORM_LNK=$(echo "${TERRAFORM_URL}/${TERRAFORM_VER}/")

ansi --yellow $TERRAFORM_URL
ansi --green $TERRAFORM_VER
ansi --cyan $TERRAFORM_LNK

curl -LO $TERRAFORM_LNK
unzip $TERRAFORM_ZIP
chmod +x terraform && sudo mv terraform /usr/local/bin/ && rm $TERRAFORM_ZIP
