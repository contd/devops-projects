#!/usr/bin/env bash

#################################################################################################
# Install prometheus and grafana
helm repo add coreos https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/
helm install coreos/prometheus-operator --name prometheus-operator --namespace monitoring
helm install coreos/kube-prometheus --name kube-prometheus --namespace monitoring

# Edit the live kube-prometheus svc and change to LoadBalancer
kubectl edit svc kube-prometheus -n monitoring

# Edit the live kube-prometheus-grafana svc and change to LoadBalancer
kubectl edit svc kube-prometheus-grafana -n monitoring

#################################################################################################
# Install the metrics-server addon more easily through helm
helm install --name metrics-server --namespace monitoring stable/metrics-server

#################################################################################################
# Setup Kubernetes Dashboard, Heapster etc.
kubectl apply -f *.yaml
# kubectl apply -f kubernetes-dashboard.yaml
# kubectl apply -f heapster.yaml
# kubectl apply -f influxdb.yaml
# kubectl apply -f heapster-rbac.yaml
# kubectl apply -f eks-admin-service-account.yaml

#################################################################################################
# To access the Dashboard
# Get Token to Login via kubeproxy
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')
# Need to copy the Token from the output of the prev command
kubectl proxy

exit 0
