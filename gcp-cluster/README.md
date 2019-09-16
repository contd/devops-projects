# Google Cloud Platform Terraform

Once Kubernetes cluster is up and running via `Terraform` the kubectl config needs to be updated. Using the `gcloud` command, get the name of the cluster which also verifies the cluster is up and running.

```bash
gcloud contaner clusters list

NAME              LOCATION  MASTER_VERSION  MASTER_IP      MACHINE_TYPE   NODE_VERSION  NUM_NODES  STATUS
gcpkubercluster1  us-east1  1.11.7-gke.4    35.231.151.80  n1-standard-1  1.11.7-gke.4  9          RUNNING
```

Then run the next command to actually update the kubectl config (you may need to add the --zone=us-east1)

```bash
gcloud container clusters get-credentials gcpkubercluster1
or
gcloud container clusters get-credentials gcpkubercluster1 --zone=us-east1
```

When using kubectl and deploying things that require cluster-admin privileges, you want to be sure to be using the right service account. This is defined in the `account.json` file but kubectl may be using you main google account. To be sure, set the `GOOGLE_APPLICATION_CREDENTIALS` environment variable like so:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=./account.json
```

## Notes

Extented infrastructure when `Terraform` a `GCP Kubernetes` container cluster. The following output is the result of `kubectl get all -n kube-system`.

```bash
kubectl get all -n kube-system

NAME                                                               READY   STATUS    RESTARTS   AGE
pod/event-exporter-v0.2.3-85644fcdf-x8gz2                          2/2     Running   0          2h
pod/fluentd-gcp-scaler-8b674f786-k75dg                             1/1     Running   0          2h
pod/fluentd-gcp-v3.2.0-xfv89                                       2/2     Running   0          2h
pod/fluentd-gcp-v3.2.0-xv8lj                                       2/2     Running   0          2h
pod/heapster-v1.6.0-beta.1-76796b6bdb-9bxp4                        3/3     Running   0          2h
pod/kube-dns-7df4cb66cb-gc8gx                                      4/4     Running   0          2h
pod/kube-dns-7df4cb66cb-vsc96                                      4/4     Running   0          2h
pod/kube-dns-autoscaler-67c97c87fb-nq8sz                           1/1     Running   0          2h
pod/kube-proxy-gke-gcpkubecluster1-gcpkubenodepool-2229197f-m0sh   1/1     Running   0          2h
pod/kube-proxy-gke-gcpkubecluster1-gcpkubenodepool-e14f3238-sc8b   1/1     Running   0          2h
pod/l7-default-backend-7ff48cffd7-xgc4b                            1/1     Running   0          2h
pod/metrics-server-v0.2.1-fd596d746-gll74                          2/2     Running   0          2h

NAME                           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
service/default-http-backend   NodePort    10.35.242.54    <none>        80:32611/TCP    2h
service/heapster               ClusterIP   10.35.245.182   <none>        80/TCP          2h
service/kube-dns               ClusterIP   10.35.240.10    <none>        53/UDP,53/TCP   2h
service/metrics-server         ClusterIP   10.35.248.9     <none>        443/TCP         2h

NAME                                      DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR                                  AGE
daemonset.apps/fluentd-gcp-v3.2.0         2         2         2       2            2           beta.kubernetes.io/fluentd-ds-ready=true       2h
daemonset.apps/metadata-proxy-v0.1        0         0         0       0            0           beta.kubernetes.io/metadata-proxy-ready=true   2h
daemonset.apps/nvidia-gpu-device-plugin   0         0         0       0            0           <none>                                         2h

NAME                                     DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/event-exporter-v0.2.3    1         1         1            1           2h
deployment.apps/fluentd-gcp-scaler       1         1         1            1           2h
deployment.apps/heapster-v1.6.0-beta.1   1         1         1            1           2h
deployment.apps/kube-dns                 2         2         2            2           2h
deployment.apps/kube-dns-autoscaler      1         1         1            1           2h
deployment.apps/l7-default-backend       1         1         1            1           2h
deployment.apps/metrics-server-v0.2.1    1         1         1            1           2h

NAME                                                DESIRED   CURRENT   READY   AGE
replicaset.apps/event-exporter-v0.2.3-85644fcdf     1         1         1       2h
replicaset.apps/fluentd-gcp-scaler-8b674f786        1         1         1       2h
replicaset.apps/heapster-v1.6.0-beta.1-665b9cbc64   0         0         0       2h
replicaset.apps/heapster-v1.6.0-beta.1-76796b6bdb   1         1         1       2h
replicaset.apps/kube-dns-7df4cb66cb                 2         2         2       2h
replicaset.apps/kube-dns-autoscaler-67c97c87fb      1         1         1       2h
replicaset.apps/l7-default-backend-7ff48cffd7       1         1         1       2h
replicaset.apps/metrics-server-v0.2.1-597c89dc98    0         0         0       2h
replicaset.apps/metrics-server-v0.2.1-fd596d746     1         1         1       2h
```
