#!/usr/bin/env bash

HELM_VER=helm-v2.13.0-linux-amd64.tar.gz

curl -OL https://storage.googleapis.com/kubernetes-helm/${HELM_VER}
tar -xzvf ${HELM_VER}
sudo mv ./linux-amd64/helm /usr/local/bin/helm
rm -rf ./linux-amd64
