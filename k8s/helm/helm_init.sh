#!/usr/bin/env bash

# Fix privileges to allow tiller for helm to be setup
kubectl create -f rbac-config.yaml

# Setup tiller on cluster (tiller = helm on cluster)
helm init --service-account tiller

exit 0
