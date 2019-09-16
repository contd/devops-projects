#!/usr/bin/env bash

kubectl create secret generic vault \
    --from-file=certs/ca.pem \
    --from-file=certs/vault.pem \
    --from-file=certs/vault-key.pem

kubectl create configmap vault --from-file=vault/config.json
kubectl describe configmap vault

kubectl create -f vault/service.yml
kubectl get service vault

kubectl apply -f vault/deployment.yml

# kubectl get pods to get vault address for POD
POD=$(kubectl get pods -o=name | grep vault | sed "s/^.\{4\}//")

while true; do
  STATUS=$(kubectl get pods ${POD} -o jsonpath="{.status.phase}")
  if [ "$STATUS" == "Running" ]; then
    break
  else
    echo "Pod status is: ${STATUS}"
    sleep 5
  fi
done

kubectl port-forward $POD 8200:8200 &

# In separate terminal or add & after port forward command
export VAULT_ADDR=https://127.0.0.1:8200
export VAULT_CACERT="certs/ca.pem"
# Exmple usage
vault operator init -key-shares=1 -key-threshold=1
vault operator unseal
vault login
