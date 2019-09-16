provider "digitalocean" {
  # export DIGITALOCEAN_API_TOKEN="XXXXXXXXX"
  token = var.token
}
data "digitalocean_kubernetes_cluster" "mainkube" {
  name = var.cluster_name
}
provider "kubernetes" {
  host = data.digitalocean_kubernetes_cluster.mainkube.endpoint

  client_certificate     = "${base64decode(data.digitalocean_kubernetes_cluster.mainkube.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(data.digitalocean_kubernetes_cluster.mainkube.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(data.digitalocean_kubernetes_cluster.mainkube.kube_config.0.cluster_ca_certificate)}"
}
provider "helm" {
  kubernetes {
    host = data.digitalocean_kubernetes_cluster.mainkube.endpoint

    client_certificate     = "${base64decode(data.digitalocean_kubernetes_cluster.mainkube.kube_config.0.client_certificate)}"
    client_key             = "${base64decode(data.digitalocean_kubernetes_cluster.mainkube.kube_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(data.digitalocean_kubernetes_cluster.mainkube.kube_config.0.cluster_ca_certificate)}"
  }
}