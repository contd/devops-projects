# Kubernetes Ingress with AWS ALB Ingress Controller

**Author**: Nishi Davidson
**Publiched**: 11-20-2018
**Ref**: [https://github.com/kubernetes-sigs/aws-alb-ingress-controller/blob/master/README.md](https://github.com/kubernetes-sigs/aws-alb-ingress-controller/blob/master/README.md)

[Kubernetes Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) is an api object that allows you manage external (or) internal HTTP[s] access to [Kubernetes services](https://kubernetes.io/docs/concepts/services-networking/service/) running in a cluster. [Amazon Elastic Load Balancing Application Load Balancer](https://aws.amazon.com/elasticloadbalancing/features/#Details_for_Elastic_Load_Balancing_Products) (ALB) is a popular AWS service that load balances incoming traffic at the application layer (layer 7) across multiple targets, such as Amazon EC2 instances, in a region. ALB supports multiple features including host or path based routing, TLS (Transport layer security) termination, WebSockets, HTTP/2, AWS WAF (web application firewall) integration, integrated access logs, and health checks.

The [AWS ALB Ingress controller](https://github.com/kubernetes-sigs/aws-alb-ingress-controller) is a controller that triggers the creation of an [ALB](https://aws.amazon.com/elasticloadbalancing/features/#Details_for_Elastic_Load_Balancing_Products) and the necessary supporting AWS resources whenever a Kubernetes user declares an Ingress resource on the cluster. The Ingress resource uses the ALB to route HTTP[s] traffic to different endpoints within the cluster. The AWS ALB Ingress controller works on any Kubernetes cluster including Amazon Elastic Container Service for Kubernetes (EKS).

## Terminology

We will use the following acronyms to describe the Kubernetes Ingress concepts in more detail:

- **ALB**: [AWS Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html)
- **ENI**: [Elastic Network Interfaces](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html)
- **[NodePort](https://kubernetes.io/docs/concepts/services-networking/service/#nodeport)**: When a user sets the `type` field to `NodePort`, the Kubernetes master allocates a static port from a range, and each Node will proxy that port (the same port number on every Node) into your `Service`.

## How Kubernetes Ingress works with [aws-alb-ingress-controller](https://github.com/kubernetes-sigs/aws-alb-ingress-controller)

The following diagram details the AWS components that the aws-alb-ingress-controller creates whenever an Ingress resource is defined by the user. The Ingress resource routes ingress traffic from the ALB to the Kubernetes cluster.

![How Kubernetes Ingress works with aws-alb-ingress-controller](png/controller-design.png)

### Ingress Creation

Following the steps in the numbered blue circles in the above diagram:

1. The controller watches for [ingress events](https://kubernetes.io/docs/concepts/services-networking/ingress/#ingress-controllers) from the API server. When it finds ingress resources that satisfy its requirements, it begins creation of AWS resources.
2. An ALB is created for the Ingress resource.
3. [TargetGroups](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html) are created for each backend specified in the Ingress resource.
4. [Listeners](http://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-listeners.html) are created for every port specified as Ingress resource annotation. When no port is specified, sensible defaults (`80` or `443`) are used.
5. [Rules](http://docs.aws.amazon.com/elasticloadbalancing/latest/application/listener-update-rules.html) are created for each path specified in your ingress resource. This ensures that traffic to a specific path is routed to the correct TargetGroup created.

### Ingress Traffic

AWS ALB Ingress controller supports two traffic modes: **instance mode** and **ip mode**. Users can explicitly specify these traffic modes by declaring the **alb.ingress.kubernetes.io/target-type** annotation on the Ingress and the Service definitions.

- **instance mode:** Ingress traffic starts from the ALB and reaches the [NodePort](https://kubernetes.io/docs/concepts/services-networking/service/#nodeport) opened for your service. Traffic is then routed to the container Pods within cluster. The number of hops for the packet to reach its destination in this mode is always two.
- **ip mode:** Ingress traffic starts from the ALB and reaches the container Pods within cluster directly. In order to use this mode, the networking plugin for the Kubernetes cluster must use a secondary IP address on ENI as pod IP, aka [AWS CNI plugin for Kubernetes](https://github.com/aws/amazon-vpc-cni-k8s). The number of hops for the packet to reach its destination in this mode is always one.

## Deploy Amazon EKS with eksctl

First, let's deploy an Amazon EKS cluster with [eksctl cli tool](https://github.com/weaveworks/eksctl).

Install eksctl with Homebrew for macOS users:

```bash
brew install weaveworks/tap/eksctl
```

Create EKS cluster with cluster name "attractive-gopher"

```bash
eksctl create cluster --name=attractive-gopher
```

Go to the "Subnets" section in the VPC Console. Find all the Public subnets for your EKS cluster.

__Example:__

```bash
eksctl-attractive-gopher-cluster/SubnetPublic<USWEST2a>
eksctl-attractive-gopher-cluster/SubnetPublic<USWEST2b>
eksctl-attractive-gopher-cluster/SubnetPublic<USWEST2c>
```

Configure the Public subnets in the console as defined in [this guide](https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/controller/config/#subnet-auto-discovery). (Most Kubernetes distributions on AWS already do this for you, e.g. kops)

## Deploy AWS ALB Ingress controller

Next, let's deploy the AWS ALB Ingress controller into our Kubernetes cluster.

Create the IAM policy to give the Ingress controller the right permissions:

1. Go to the IAM Console and choose the section **Policies**.
2. Select **Create policy**.
3. Embed the contents of the template [iam-policy.json](https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.0.0/docs/examples/iam-policy.json) in the JSON section.
4. **Review policy** and save as "ingressController-iam-policy"

Attach the IAM policy to the EKS worker nodes:

1. Go back to the IAM Console.
2. Choose the section **Roles** and search for the NodeInstanceRole of your EKS worker node. Example: eksctl-attractive-gopher-NodeInstanceRole-xxxxxx
3. Attach policy "ingressController-iam-policy."

Deploy RBAC Roles and RoleBindings needed by the AWS ALB Ingress controller:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.0.0/docs/examples/rbac-role.yaml
```

Download the AWS ALB Ingress controller YAML into a local file:

```bash
curl -sS "https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.0.0/docs/examples/alb-ingress-controller.yaml" > alb-ingress-controller.yaml
```

Edit the AWS ALB Ingress controller YAML to include the clusterName of the Kubernetes (or) Amazon EKS cluster.

Edit the **–cluster-name** flag to be the real name of our Kubernetes (or) Amazon EKS cluster.

Deploy the AWS ALB Ingress controller YAML:

```bash
kubectl apply -f alb-ingress-controller.yaml
```

Verify that the deployment was successful and the controller started:

```bash
kubectl logs -n kube-system $(kubectl get po -n kube-system | egrep -o alb-ingress[a-zA-Z0-9-]+)
```

You should be able to see the following output:

```bash
-------------------------------------------------------------------------------
AWS ALB Ingress controller
  Release: v1.0.0
  Build: git-6ee1276
  Repository: https://github.com/kubernetes-sigs/aws-alb-ingress-controller
-------------------------------------------------------------------------------
```

## Deploy Sample Application

Now let's deploy a sample [2048 game](https://gabrielecirulli.github.io/2048/) into our Kubernetes cluster and use the Ingress resource to expose it to traffic:

Deploy 2048 game resources:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.0.0/docs/examples/2048/2048-namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.0.0/docs/examples/2048/2048-deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.0.0/docs/examples/2048/2048-service.yaml
```

Deploy an Ingress resource for the 2048 game:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.0.0/docs/examples/2048/2048-ingress.yaml
```

After few seconds, verify that the Ingress resource is enabled:

```bash
kubectl get ingress/2048-ingress -n 2048-game
```

You should be able to see the following output:

```bash
NAME         HOSTS         ADDRESS         PORTS   AGE
2048-ingress   *    DNS-Name-Of-Your-ALB    80     3m
```

Open a browser. Copy and paste your "DNS-Name-Of-Your-ALB". You should be to access your newly deployed 2048 game – have fun!

## Get Involved

The AWS ALB Ingress controller, a subproject of Kubernetes SIG (Special Interest Group) AWS, is a fully open source project maintained by Yang Yang ([@M00nf1sh](https://twitter.com/M00nf1sh)) and Kraig Amador. Kubernetes SIG-AWS's technical roadmap is currently steered by three SIG chairs: Nishi Davidson ([@nishidavidson](https://twitter.com/nishidavidson)), Justin Santa Barbara, and Kris Nova ([@krisnova](https://twitter.com/krisnova)).

AWS ALB Ingress controller has been pegged as an alpha feature in Kubernetes 1.13, due to release early December 2018\. The AWS team has also tested the Ingress controller with Amazon EKS that currently supports Kubernetes version 1.10.

More resources:

- [AWS ALB Ingress Controller documentation](https://kubernetes-sigs.github.io/aws-alb-ingress-controller/)
- [aws-alb-ingress-controller Github repo](https://github.com/kubernetes-sigs/aws-alb-ingress-controller/)
- [Contribute to aws-alb-ingress-controller](https://github.com/kubernetes-sigs/aws-alb-ingress-controller/issues)

![Yang Yang](https://d2908q01vomqb2.cloudfront.net/ca3512f4dfa95a03169c5a670a4c91a19b3077b4/2018/11/20/yy-150x150.jpg)

### Yang Yang

Yang is a software engineer at Amazon Web Services. He is a Kubernetes enthusiast and has been working for Amazon as a full stack engineer for four years.

![Kraig Amador](https://d2908q01vomqb2.cloudfront.net/ca3512f4dfa95a03169c5a670a4c91a19b3077b4/2018/11/20/Screen-Shot-2018-11-19-at-3.43.32-PM-150x150.png)

### Kraig Amador

Kraig is a Senior Director at Ticketmaster where he led the team that pioneered adoption of AWS enablement and migration. He was also an early adopter of running Kubernetes on AWS with enterprise workloads, leading to the development of the AWS ALB ingress controller.

![Nishi Davidson](https://d2908q01vomqb2.cloudfront.net/ca3512f4dfa95a03169c5a670a4c91a19b3077b4/2018/04/30/Nishi-Davidson.jpg)

### Nishi Davidson

Nishi Davidson has been in the cloud infrastructure and software application space for 15 years working across engineering, product management and strategy in South East Asia and the US markets. Currently she is responsible for AWS's open source engineering efforts in the Kubernetes community. In the past, she ran SAP's private cloud, Kubernetes managed service engineering for internal BUs. Nishi has led product/field engineering teams and introduced multiple cloud products/solutions to the market while working at HP, TCS, Juniper Networks, NetApp and DSSD (EMC). Nishi holds an MBA from Massachusetts Institute of Technology, Sloan and a bachelor's in Electrical and Electronics Engineering from CEG, Guindy, Anna University.

[View Comments](https://commenting.awsblogs.com/embed.html?disqus_shortname=aws-open-source-blog&disqus_identifier=1873&disqus_title=Kubernetes+Ingress+with+AWS+ALB+Ingress+Controller&disqus_url=https://aws.amazon.com/blogs/opensource/kubernetes-ingress-aws-alb-ingress-controller/)

### Resources

[Open Source at AWS](https://aws.amazon.com/opensource?sc_ichannel=ha&sc_icampaign=acq_awsblogsb&sc_icontent=opensource-resources) [Projects on GitHub](https://aws.github.io)
