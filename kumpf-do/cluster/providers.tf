provider "digitalocean" {
  # export DIGITALOCEAN_API_TOKEN="XXXXXXXXX"
  token = var.token
}
provider "kubernetes" {
  host = digitalocean_kubernetes_cluster.mainkube.endpoint

  client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.mainkube.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(digitalocean_kubernetes_cluster.mainkube.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.mainkube.kube_config.0.cluster_ca_certificate)}"
}