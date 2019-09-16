# Create a Production-Ready PostgreSQL Cluster with Bitnami, Kubernetes and Helm

Published on July 25, 2018 - Vikram Vaswani

In a previous post, I discussed [Bitnami’s PostgreSQL with Replication solution](https://engineering.bitnami.com/articles/worried-about-big-data-scale-up-with-bitnami-secure-fault-tolerant-postgresql-cluster.html), which can be deployed on multiple virtual machines. But what if you’re using Kubernetes instead? Well, Bitnami also offers a [PostgreSQL Helm chart](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) that comes pre-configured for security, scalability and data replication. It’s a great combination: all the open source goodness of PostgreSQL (foreign keys, joins, views, triggers, stored procedures…) together with the consistency, portability and self-healing features of Kubernetes.

In this blog post, I’ll walk you through the main features of Bitnami’s PostgreSQL Helm chart and explain how you can use it to deploy a production-ready PostgreSQL cluster quickly and efficiently on Kubernetes.

## Deployment Options

The Bitnami PostgreSQL Helm chart can be deployed on any Kubernetes cluster. Two pre-defined configuration files are provided to help you get started quickly: [values.yaml](https://raw.githubusercontent.com/bitnami/charts/master/bitnami/postgresql/values.yaml) for development or test environments, and [values-production.yaml](https://github.com/bitnami/charts/blob/master/bitnami/postgresql/values-production.yaml) for production environments.

The default [values.yaml](https://raw.githubusercontent.com/bitnami/charts/master/bitnami/postgresql/values.yaml) configuration creates a single node, while the production [values-production.yaml](https://github.com/bitnami/charts/blob/master/bitnami/postgresql/values-production.yaml) configuration creates a master node and a StatefulSet for the slave nodes. This allows the number of slave nodes to be scaled up or down independently.

You can use the Bitnami PostgreSQL Helm chart on any Kubernetes cluster that has Helm installed. For this blog post, I’ll use the [Microsoft Azure Container Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/), but the chart works the same way on [Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine/), [Amazon Elastic Container Service (EKS)](https://aws.amazon.com/eks/) or even [minikube](https://github.com/kubernetes/minikube).

The following sections assume that you have provisioned a new AKS cluster and installed kubectl and Helm. For a detailed walkthrough of performing these steps, [refer to our AKS guide](https://docs.bitnami.com/azure/get-started-aks/).

## Deployment and Testing

Deploying the PostgreSQL cluster with Helm is a simple two-step process:

- Download [the values-production.yaml file](https://github.com/bitnami/charts/blob/master/bitnami/postgresql/values-production.yaml):

```bash
curl -O https://raw.githubusercontent.com/bitnami/charts/master/bitnami/postgresql/values-production.yaml
```

- Deploy the Helm chart using the commands below, replacing the ROOT\_PASSWORD and REPLICATION\_PASSWORD placeholders with secure values:

```bash
helm install --name my-release bitnami/postgresql -f values-production.yaml --set postgresqlPassword=ROOT_PASSWORD --set replication.password=REPLICATION_PASSWORD
```

    This command creates a deployment with the name *my-release*. You can use a different release name if you wish - just remember to update it in the previous and following commands.

Monitor the pods until the deployment is complete:

```bash
kubectl get pods -w
```

If you see output similar to that shown below, your PostgreSQL cluster is deployed and ready for action.

To check that everything is working correctly, connect to the primary node using a PostgreSQL client pod, specify the root password as shown, and then run the query shown:

```bash
kubectl run my-release-postgresql-client --rm --tty -i --image bitnami/postgresql --env="PGPASSWORD=ROOT_PASSWORD" --command -- psql --host my-release-postgresql -U postgres

postgres=# SELECT client_addr, state FROM pg_stat_replication;
```

This query will list the IP addresses of the other members of the PostgreSQL cluster. If you see output similar to the image below, your cluster nodes are connected and talking to each other.

## Default Network Topology and Security

The Bitnami PostgreSQL chart is configured with password-based authentication enabled by default, and no RBAC rules are required for its deployment. The default administrator username is *postgres*, and the default replication account username is *repl\_user*. Passwords for both accounts should be specified at deployment time, as shown in the previous section.

The [values-production.yaml](https://raw.githubusercontent.com/bitnami/charts/master/bitnami/postgresql/values-production.yaml) configuration configures two nodes by default: a master and a slave. However, you can scale the cluster up or down by adding or removing nodes even after the initial deployment. The PostgreSQL service is available on the standard port 5432. Remote connections are enabled for this port by default.

PostgreSQL does not have any minimal hardware requirements, but we recommend using virtual machines with at least 1 GB of RAM and sufficient disk space for your data. However, these are minimum recommendations only and depending on the likely workload of your database cluster, you may want to use [machine types optimized for relational database servers](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/series/). You can also reconfigure the minimum resources per pod in the [values-production.yaml](https://raw.githubusercontent.com/bitnami/charts/master/bitnami/postgresql/values-production.yaml) file.

## Data Replication and Persistence

A key feature of Bitnami’s PostgreSQL Helm chart is that it comes pre-configured to provide a horizontally scalable and fault-tolerant deployment. Data automatically replicates from the master node to all slave nodes. The master node receives all write operations, while the slave nodes repeat the operations performed by the master node on their own copies of the data set and are used for read operation. This model improves the overall performance of the solution. It also simplifies disaster recovery, because a copy of the data is maintained on each node in the cluster.

To see replication in action, add some data to the master node and then check that the same data exists on a slave node:

```bash
# create and insert data on the master
kubectl run my-release-postgresql-client --rm --tty -i --image bitnami/postgresql --env="PGPASSWORD=ROOT_PASSWORD" --command -- psql --host my-release-postgresql -U postgres
postgres=# CREATE TABLE test (id int not null, val text not null);
postgres=# INSERT INTO test VALUES (1, 'foo');
postgres=# INSERT INTO test VALUES (2, 'bar');

# connect to the slave and verify data
kubectl exec -it my-release-postgresql-slave-0 -- bash
> export PGPASSWORD=ROOT_PASSWORD
> psql --host 127.0.0.1 -U postgres
postgres=# SELECT * FROM test;
```

The PostgreSQL with Replication chart is configured to use [streaming replication](https://www.postgresql.org/docs/current/static/warm-standby.html#STREAMING-REPLICATION) by default, which is asynchronous. This approach produces a more fault-tolerant deployment, as it keeps standby servers up-to-date and therefore results in a smaller window of disruption if the master node fails and needs to be replaced by a standby.

## Custom Configuration

If you wish to use a custom *postgresql.conf* file instead of the default, simply add it to the [*files/* directory of the chart](https://github.com/bitnami/charts/tree/master/bitnami/postgresql/files) and it will be deployed in place of the default one. This is ideal for when you need to customize some aspects of your PostgreSQL deployment.

## Horizontal Scaling

You can easily scale the cluster up or down by adding or removing nodes. When using [values-production.yaml](https://raw.githubusercontent.com/bitnami/charts/master/bitnami/postgresql/values-production.yaml), the chart creates separate StatefulSets for master and slave nodes. Depending on your requirements, simply scale the slave StatefulSet up or down.

For example, to scale the number of slave nodes up to 3, use the command below:

```bash
kubectl scale statefulset my-postgresql-slave --replicas=3
```

You can use the query shown previously to check that the new nodes are connected to the cluster, as shown below:

## Updates

You can update to the latest version with these commands:

```bash
helm repo update
helm upgrade my-release bitnami/postgresql -f values-production.yaml --set postgresqlPassword=ROOT_PASSWORD --set replication.password=REPLICATION_PASSWORD
```

You can also upgrade using an image tag. For example, to replace an existing deployment with a specific Oracle Linux-based image:

```bash
helm repo update
helm upgrade my-release bitnami/postgresql -f values-production.yaml --set postgresqlPassword=ROOT_PASSWORD --set replication.password=REPLICATION_PASSWORD --set image.tag=10.4.0-ol-7
```

If this sounds interesting to you, why not try it now? [Deploy the Bitnami PostgreSQL Helm chart now on Microsoft Azure Container Service (AKS)](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) and then [tweet @bitnami](https://twitter.com/bitnami) and tell us what you think!
