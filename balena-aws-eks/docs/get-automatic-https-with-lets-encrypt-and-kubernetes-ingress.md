# Get Automatic HTTPS with Let's Encrypt and Kubernetes Ingress

**Author**: Alen Komljen
**Date**: February 04, 2019
**Ref**: [https://akomljen.com/get-automatic-https-with-lets-encrypt-and-kubernetes-ingress/](https://akomljen.com/get-automatic-https-with-lets-encrypt-and-kubernetes-ingress/)

A few days ago I read a great post from Troy Hunt about HTTPS. The title "[HTTPS is easy](https://www.troyhunt.com/https-is-easy/)" is there for a good reason! HTTPS is easy, especially with the platforms like [Kubernetes](https://akomljen.com/tag/kubernetes/). Unfortunately, not all people agree with this. I understand that for some huge organizations moving all traffic to HTTPS is not trivial, but for all others saying how Google is evil with forcing it is just nonsense. You should use HTTPS for every external endpoint and with [Kubernetes ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) and [Let's Encrypt](https://letsencrypt.org/) this can be automatic. Meaning, you need to "switch on HTTPS" if you want. Plugins take care of the rest.

## Requirements

To have automatic HTTPS with Kubernetes, you need to deploy the ingress controller first. However, what is ingress? With ingress in Kubernetes, you control the routing of external traffic. Ingress controller is tightly coupled with Kubernetes API which makes it that good.

Let's wrap up all the requirements:

- Ingress controller on top of Kubernetes
- Automatic DNS

I wrote about the ingress controller in the past. Instructions on how to fulfill all those requirements are available in this blog post, [AWS Cost Savings by Utilizing Kubernetes Ingress with Classic ELB](https://akomljen.com/aws-cost-savings-by-utilizing-kubernetes-ingress-with-classic-elb/).

## Glue Everything Together

The component which manages SSL/TLS certificates is [Cert manager](https://github.com/jetstack/cert-manager). It creates the new certificates automatically for each ingress endpoint. Also, it renews certificates automatically when they expire. Cert manager can work with other providers as well, [HashiCorp Vault](https://www.vaultproject.io/) for example. For all my Kubernetes related articles I use Helm for deployment because of simplicity. And not just that I highly recommend using it for production workloads. Please [read my blog post about Helm](https://akomljen.com/package-kubernetes-applications-with-helm/) if you are new to it.

You need to configure the default [cluster issuer](http://docs.cert-manager.io/en/latest/reference/clusterissuers.html) when deploying Cert manager to support `kubernetes.io/tls-acme: "true"` annotation for automatic TLS:

```sql
ingressShim.defaultIssuerName=letsencrypt-prod
ingressShim.defaultIssuerKind=ClusterIssuer
```

You can define `letsencrypt-prod` cluster issuer later. Let's deploy Cert manager first:

```bash
helm install --name cert-manager \
    --namespace ingress \
    --set ingressShim.defaultIssuerName=letsencrypt-prod \
    --set ingressShim.defaultIssuerKind=ClusterIssuer \
    stable/cert-manager \
    --version v0.5.2

⚡ kubectl get pod -n ingress --selector=app=cert-manager
NAME                                        READY     STATUS    RESTARTS   AGE
cert-manager-cert-manager-7797579f9-m4dbc   1/1       Running   0          1m
```

**NOTE:** Much changed in new cert manager version 0.6, so temporarily install the older version `v0.5.2`.

When installed Cert manager provides [Kubernetes custom resources](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/):

```bash
kubectl get crd
NAME                                         AGE
certificates.certmanager.k8s.io              1m
clusterissuers.certmanager.k8s.io            1m
issuers.certmanager.k8s.io                   1m
```

The last step is to define cluster-wide issuer `letsencrypt-prod`, which we already set in the above steps. Let's define cluster issuer using custom resource `clusterissuers.certmanager.k8s.io`:

```bash
cat << EOF| kubectl create -n ingress -f -
apiVersion: certmanager.k8s.io/v1alpha1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: [email protected]
    privateKeySecretRef:
      name: letsencrypt-prod
    http01: {}
EOF
```

**NOTE:** Please use the valid email address!

When all is ready, it is time for testing. Let's deploy the new [Ghost blog](https://ghost.org/) on this cluster accessible through `ghost.test.akomljen.com` domain and with HTTPS by default. Again let's use Helm to install it:

```bash
cat > values.yaml <<EOF
serviceType: ClusterIP
ghostHost: ghost.test.akomljen.com
ingress:
  enabled: true
  hosts:
    - name: ghost.test.akomljen.com
      tls: true
      tlsSecret: test-app-tls
      annotations:
        kubernetes.io/ingress.class: nginx
        kubernetes.io/tls-acme: "true"
mariadb:
  replication:
    enabled: true
EOF

helm install --name test-app \
    -f values.yaml \
    stable/ghost
```

After a few minutes, you can go right ahead and open defined endpoint in your browser. HTTPS is on by default!

## Summary

Easy right 😉. We are lucky that there are security professionals like Troy Hunt who promote security as something that can be "easily" implemented with the right set of patterns. At the same time, cloud-native technologies are helping us to automate all those things. Stay tuned for the next one.
