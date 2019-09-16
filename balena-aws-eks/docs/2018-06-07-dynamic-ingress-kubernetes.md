# Dynamic Ingress in Kubernetes

**Author**: Richard Li (Datawire)
**Date**:  2018-06-07
**Ref**: [https://kubernetes.io/blog/2018/06/07/dynamic-ingress-in-kubernetes/](https://kubernetes.io/blog/2018/06/07/dynamic-ingress-in-kubernetes/)

Kubernetes makes it easy to deploy applications that consist of many micro services, but one of the key challenges with this type of architecture is dynamically routing ingress traffic to each of these services.  One approach is [Ambassador](https://www.getambassador.io), a Kubernetes-native open source API Gateway built on the [Envoy Proxy](https://www.envoyproxy.io). Ambassador is designed for dynamic environment where services may come and go frequently.

Ambassador is configured using Kubernetes annotations. Annotations are used to configure specific mappings from a given Kubernetes service to a particular URL. A mapping can include a number of annotations for configuring a route. Examples include rate limiting, protocol, cross-origin request sharing, traffic shadowing, and routing rules.

## A Basic Ambassador Example

Ambassador is typically installed as a Kubernetes deployment, and is also available as a Helm chart. To configure Ambassador, create a Kubernetes service with the Ambassador annotations. Here is an example that configures Ambassador to route requests to /httpbin/ to the public httpbin.org service:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: httpbin
  annotations:
    getambassador.io/config: |
      ---
      apiVersion: ambassador/v0
      kind:  Mapping
      name:  httpbin_mapping
      prefix: /httpbin/
      service: httpbin.org:80
      host_rewrite: httpbin.org
spec:
  type: ClusterIP
  ports:
    - port: 80
```

A mapping object is created with a prefix of /httpbin/ and a service name of httpbin.org. The host_rewrite annotation specifies that the HTTP `host` header should be set to httpbin.org.

## Kubeflow

[Kubeflow](https://github.com/kubeflow/kubeflow) provides a simple way to easily deploy machine learning infrastructure on Kubernetes. The [Kubeflow](https://github.com/kubeflow/kubeflow) team needed a proxy that provided a central point of authentication and routing to the wide range of services used in [Kubeflow](https://github.com/kubeflow/kubeflow), many of which are ephemeral in nature.

![kubeflow](png/kubeflow.png)
<center><i>Kubeflow architecture, pre-Ambassador</center></i>

## Service configuration

With Ambassador, [Kubeflow](https://github.com/kubeflow/kubeflow) can use a distributed model for configuration. Instead of a central configuration file, Ambassador allows each service to configure its route in Ambassador via Kubernetes annotations. Here is a simplified example configuration:

```yaml
---
apiVersion: ambassador/v0
kind:  Mapping
name: tfserving-mapping-test-post
prefix: /models/test/
rewrite: /model/test/:predict
method: POST
service: test.kubeflow:8000
```

In this example, the “test” service uses Ambassador annotations to dynamically configure a route to the service, triggered only when the HTTP method is a POST, and the annotation also specifies a rewrite rule.

## Kubeflow and Ambassador

![kubeflow-ambassador](png/kubeflow-ambassador.png)

With Ambassador, [Kubeflow](https://github.com/kubeflow/kubeflow) manages routing easily with Kubernetes annotations. [Kubeflow](https://github.com/kubeflow/kubeflow) configures a single ingress object that directs traffic to Ambassador, then creates services with Ambassador annotations as needed to direct traffic to specific back-ends. For example, when deploying TensorFlow services,  [Kubeflow](https://github.com/kubeflow/kubeflow) creates and annotates a Kubernetes service so that the model will be served at `https://<ingress host>/models/<model name>/`. [Kubeflow](https://github.com/kubeflow/kubeflow) can also use the Envoy Proxy to do the actual L7 routing. Using Ambassador, [Kubeflow](https://github.com/kubeflow/kubeflow) takes advantage of additional routing configuration like URL rewriting and method-based routing.

If you’re interested in using Ambassador with [Kubeflow](https://github.com/kubeflow/kubeflow), the standard [Kubeflow](https://github.com/kubeflow/kubeflow) install automatically installs and configures Ambassador.

If you’re interested in using Ambassador as an API Gateway or Kubernetes ingress solution for your non-Kubeflow services, check out the [Getting Started with Ambassador guide](https://www.getambassador.io/user-guide/getting-started).
