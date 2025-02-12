# How to Integrate Rolling Update Strategy for TPR in Kubernetes

**Author**: Orain Xiong
**Date**: 03-13-2018
**Ref**: [https://kubernetes.io/blog/2018/03/how-to-integrate-rollingupdate-strategy/](https://kubernetes.io/blog/2018/03/how-to-integrate-rollingupdate-strategy/)

With Kubernetes, it's easy to manage and scale stateless applications like web apps and API services right out of the box. To date, almost all of the talks about Kubernetes has been about microservices and stateless applications.

With the popularity of container-based microservice architectures, there is a strong need to deploy and manage RDBMS(Relational Database Management Systems). RDBMS requires experienced database-specific knowledge to correctly scale, upgrade, and re-configure while protecting against data loss or unavailability.

For example, MySQL (the most popular open source RDBMS) needs to store data in files that are persistent and exclusive to each MySQL database's storage. Each MySQL database needs to be individually distinct, another, more complex is in cluster that need to distinguish one MySQL database from a cluster as a different role, such as master, slave, or shard. High availability and zero data loss are also hard to accomplish when replacing database nodes on failed machines.

Using powerful Kubernetes API extension mechanisms, we can encode RDBMS domain knowledge into software, named WQ-RDS, running atop Kubernetes like built-in resources.

WQ-RDS leverages Kubernetes primitive resources and controllers, it deliveries a number of enterprise-grade features and brings a significantly reliable way to automate time-consuming operational tasks like database setup, patching backups, and setting up high availability clusters. WQ-RDS supports mainstream versions of Oracle and MySQL (both compatible with MariaDB).

Let's demonstrate how to manage a MySQL sharding cluster.

##  MySQL Sharding Cluster

MySQL Sharding Cluster is a scale-out database architecture. Based on the hash algorithm, the architecture distributes data across all the shards of the cluster. Sharding is entirely transparent to clients: Proxy is able to connect to any Shards in the cluster and issue queries to the correct shards directly.

![](/btrfs/home/develop/current-projects/devops/terraform/aws-eks/docs/png/rolling_update_strategy_001.png)

Note: Each shard corresponds to a single MySQL instance. Currently, WQ-RDS supports a maximum of 64 shards.


All of the shards are built with Kubernetes Statefulset, Services, Storage Class, configmap, secrets and MySQL. WQ-RDS manages the entire lifecycle of the sharding cluster. Advantages of the sharding cluster are obvious:  

* Scale out queries per second (QPS) and transactions per second (TPS)
* Scale out storage capacity: gain more storage by distributing data to multiple nodes

##  Create a MySQL Sharding Cluster

Let's create a Kubernetes cluster with 8 shards.  

```bash
 kubectl create -f mysqlshardingcluster.yaml
```

Next, create a MySQL Sharding Cluster including 8 shards.  

* TPR : MysqlCluster and MysqlDatabase

```bash
[root@k8s-master ~]# kubectl get mysqlcluster  
NAME             KIND
clustershard-c   MysqlCluster.v1.mysql.orain.com
```

MysqlDatabase from clustershard-c0 to clustershard-c7 belongs to MysqlCluster clustershard-c.

```bash
[root@k8s-master ~]# kubectl get mysqldatabase  
NAME KIND  
clustershard-c0 MysqlDatabase.v1.mysql.orain.com  
clustershard-c1 MysqlDatabase.v1.mysql.orain.com  
clustershard-c2 MysqlDatabase.v1.mysql.orain.com  
clustershard-c3 MysqlDatabase.v1.mysql.orain.com  
clustershard-c4 MysqlDatabase.v1.mysql.orain.com  
clustershard-c5 MysqlDatabase.v1.mysql.orain.com  
clustershard-c6 MysqlDatabase.v1.mysql.orain.com  
clustershard-c7 MysqlDatabase.v1.mysql.orain.com
```

Next, let's look at two main features: high availability and RollingUpdate strategy.

To demonstrate, we'll start by running sysbench to generate some load on the cluster. In this example, QPS metrics are generated by MySQL export, collected by Prometheus, and visualized in Grafana.

##  Feature: high availability

WQ-RDS handles MySQL instance crashes while protecting against data loss.
When killing clustershard-c0, WQ-RDS will detect that clustershard-c0 is unavailable and replace clustershard-c0 on failed machine, taking about 35 seconds on average.

![](/btrfs/home/develop/current-projects/devops/terraform/aws-eks/docs/png/rolling_update_strategy_002.png)

zero data loss at same time.

![](/btrfs/home/develop/current-projects/devops/terraform/aws-eks/docs/png/rolling_update_strategy_003.png)

##  Feature : RollingUpdate Strategy

MySQL Sharding Cluster brings us not only strong scalability but also some level of maintenance complexity. For example, when updating a MySQL configuration like innodb_buffer_pool_size, a DBA has to perform a number of steps:

1. Apply change time.  
2. Disable client access to database proxies.  
3. Start a rolling upgrade.

Rolling upgrades need to proceed in order and are the most demanding step of the process. One cannot continue a rolling upgrade until and unless previous updates to MySQL instances are running and ready.

4. Verify the cluster.  
5. Enable client access to database proxies.

Possible problems with a rolling upgrade include:  

* node reboot
* MySQL instances restart
* human error

Instead, WQ-RDS enables a DBA to perform rolling upgrades automatically.

##  StatefulSet RollingUpdate in Kubernetes

Kubernetes 1.7 includes a major feature that adds automated updates to StatefulSets and supports a range of update strategies including rolling updates.

**Note:** For more information about [StatefulSet RollingUpdate][4], see the Kubernetes docs.

Because TPR (currently CRD) does not support the rolling upgrade strategy, we needed to integrate the RollingUpdate strategy into WQ-RDS. Fortunately, the [Kubernetes repo][5] is a treasure for learning. In the process of implementation, there are some points to share:  

- **MySQL Sharding Cluster has ****changed**: Each StatefulSet has its corresponding ControllerRevision, which records all the revision data and order (like git). Whenever StatefulSet is syncing, StatefulSet Controller will firstly compare it's spec to the latest corresponding ControllerRevision data (similar to git diff). If changed, a new ControllerrRevision will be generated, and the revision number will be incremented by 1. WQ-RDS borrows the process, MySQL Sharding Cluster object will record all the revision and order in ControllerRevision.
- **How to initialize MySQL Sharding Cluster to meet request ****replicas**: Statefulset supports two [Pod management policies][4]: Parallel and OrderedReady. Because MySQL Sharding Cluster doesn't require ordered creation for its initial processes, we use the Parallel policy to accelerate the initialization of the cluster.
- **How to perform a Rolling ****Upgrade**: Statefulset recreates pods in strictly decreasing order. The difference is that WQ-RDS updates shards instead of recreating them, as shown below:

![](/btrfs/home/develop/current-projects/devops/terraform/aws-eks/docs/png/rolling_update_strategy_004.png)

* **When RollingUpdate ends**: Kubernetes signals termination clearly. A rolling update completes when all of a set's Pods have been updated to the updateRevision. The status's currentRevision is set to updateRevision and its updateRevision is set to the empty string. The status's currentReplicas is set to updateReplicas and its updateReplicas are set to 0.

##  Controller revision in WQ-RDS

Revision information is stored in MysqlCluster.Status and is no different than Statefulset.Status.

```yaml
root@k8s-master ~]# kubectl get mysqlcluster -o yaml clustershard-c
apiVersion: v1
items:
\- apiVersion: mysql.orain.com/v1
 kind: MysqlCluster
 metadata:
   creationTimestamp: 2017-10-20T08:19:41Z
   labels:
     AppName: clustershard-crm
     Createdby: orain.com
     DBType: MySQL
   name: clustershard-c
   namespace: default
   resourceVersion: "415852"
   selfLink: /apis/mysql.orain.com/v1/namespaces/default/mysqlclusters/clustershard-c
   uid: 6bb089bb-b56f-11e7-ae02-525400e717a6
 spec:
     dbresourcespec:
       limitedcpu: 1200m
       limitedmemory: 400Mi
       requestcpu: 1000m
       requestmemory: 400Mi
 status:
   currentReplicas: 8
   currentRevision: clustershard-c-648d878965
   replicas: 8
   updateRevision: clustershard-c-648d878965
kind: List
```

## Example: Perform a rolling upgrade

Finally, We can now update "clustershard-c" to update configuration "innodb_buffer_pool_size" from 6GB to 7GB and reboot.

The process takes 480 seconds.

![](/btrfs/home/develop/current-projects/devops/terraform/aws-eks/docs/png/rolling_update_strategy_005.png)

The upgrade is in monotonically decreasing manner:

![](/btrfs/home/develop/current-projects/devops/terraform/aws-eks/docs/png/rolling_update_strategy_006.png)

![](/btrfs/home/develop/current-projects/devops/terraform/aws-eks/docs/png/rolling_update_strategy_007.png)

![](/btrfs/home/develop/current-projects/devops/terraform/aws-eks/docs/png/rolling_update_strategy_008.png)

![](/btrfs/home/develop/current-projects/devops/terraform/aws-eks/docs/png/rolling_update_strategy_009.png)

![](/btrfs/home/develop/current-projects/devops/terraform/aws-eks/docs/png/rolling_update_strategy_010.png)

![](/btrfs/home/develop/current-projects/devops/terraform/aws-eks/docs/png/rolling_update_strategy_011.png)

![](/btrfs/home/develop/current-projects/devops/terraform/aws-eks/docs/png/rolling_update_strategy_012.png)

![](/btrfs/home/develop/current-projects/devops/terraform/aws-eks/docs/png/rolling_update_strategy_013.png) 

##  Conclusion

Rolling Upgrade is meaningful to database administrators. It provides a more effective way to operator database.
