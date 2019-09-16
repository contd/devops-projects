#!/usr/bin/env bash

# Install Traefik with Lets Encrypt
# helm install --name traefik --namespace kube-system -f traefik-config.yaml stable/traefik
# kubectl create -n ingress -f traefik-issuer.yaml

# Make the TLS certificate to provide via a Kubernetes secret in the same
# namespace as the ingress. The following two commands will generate a
# new certificate and create a secret containing the key and cert files.
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=traefik-ui"
kubectl -n kube-system create secret tls traefik-ui-tls-cert --key=tls.key --cert=tls.crt

# To provide basic authentication to prtect a web interface (i.e. prometheus), create an htpassword file
htpasswd -c ./auth admin
# Use the auth file to add it as a kuberntes secret
kubectl create secret generic promsecret --from-file auth --namespace=monitoring

exit 0
