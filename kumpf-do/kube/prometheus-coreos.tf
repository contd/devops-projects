data "helm_repository" "coreos" {
  name = "coreos_stable"
  url = "https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/"
}
/*
resource "helm_release" "prometheus-operator" {
    name = "prometheus-operator"
    repository = data.helm_repository.coreos.metadata.0.name
    chart = "prometheus-operator"
    namespace = "monitoring"
}
resource "helm_release" "kube-prometheus" {
  name = "kube-prometheus"
  repository = data.helm_repository.coreos.metadata.0.name
  chart = "kube-prometheus"
  namespace = "monitoring"
}
*/
