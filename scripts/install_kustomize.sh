#!/usr/bin/env bash

KUSTOMIZE_VER=kustomize_2.0.3_linux_amd64

curl -sL https://github.com/kubernetes-sigs/kustomize/releases/download/v2.0.3/${KUSTOMIZE_VER} -o kustomize
chmod +x kustomize && sudo mv kustomize /usr/local/bin/
