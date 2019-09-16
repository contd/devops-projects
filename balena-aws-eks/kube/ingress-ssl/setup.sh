#!/usr/bin/env bash

# Ref: ../docs/get-automatic-https-with-lets-encrypt-and-kubernetes-ingress.md

helm install --name cert-manager \
    --namespace ingress \
    --set ingressShim.defaultIssuerName=letsencrypt-prod \
    --set ingressShim.defaultIssuerKind=ClusterIssuer \
    --version v0.5.2 \
    stable/cert-manager

kubectl get pod -n ingress --selector=app=cert-manager
kubectl get crd

# The last step is to define cluster-wide issuer letsencrypt-prod, which we already set in the above steps.
# Let's define cluster issuer using custom resource clusterissuers.certmanager.k8s.io
kubectl apply -f ingress.yaml

# Example app config utilizing Let's Encrypt
helm install --name ghost-app \
    -f values.yaml \
    stable/ghost

