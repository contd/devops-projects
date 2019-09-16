#!/usr/bin/env bash

export GOSSIP_ENCRYPTION_KEY=$(consul keygen)

kubectl create secret generic consul \
  --from-literal="gossip-encryption-key=${GOSSIP_ENCRYPTION_KEY}" \
  --from-file=certs/ca.pem \
  --from-file=certs/consul.pem \
  --from-file=certs/consul-key.pem

kubectl describe secrets consul

kubectl create configmap consul --from-file=consul/config.json
kubectl describe configmap consul

kubectl create -f consul/service.yml
kubectl get service consul

kubectl create -f consul/statefulset.yml

# To acces web interface http://localhost:8500
kubectl port-forward consul-1 8500:8500
