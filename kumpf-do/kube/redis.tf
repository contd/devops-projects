data "helm_repository" "stable" {
    name = "stable"
    url  = "https://kubernetes-charts.storage.googleapis.com"
}
/*
resource "helm_release" "stable" {
  name       = "my-redis-release"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "redis"
  version    = "6.0.1"

  values = [
    file("values.yaml")
  ]

  set {
    name  = "cluster.enabled"
    value = "true"
  }

  set {
    name  = "metrics.enabled"
    value = "true"
  }

  set_string {
    name  = "service.annotations.prometheus\\.io/port"
    value = "9127"
  }
}
*/