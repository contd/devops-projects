data "digitalocean_ssh_key" "main" {
  name = var.ssh_key_name
}
data "digitalocean_domain" "kumpf" {
  name = var.domains["kumpf"]
}
data "digitalocean_domain" "jason" {
  name = var.domains["jason"]
}
output "domain_kumpf" {
  value = data.digitalocean_domain.kumpf.zone_file
}
output "domain_jason" {
  value = data.digitalocean_domain.jason.zone_file
}
output "ssh_key_id" {
  value = data.digitalocean_ssh_key.main.id
}
output "ssh_key_pub" {
  value = data.digitalocean_ssh_key.main.public_key
}
output "kube_node_pool_name" {
  value = digitalocean_kubernetes_cluster.mainkube.node_pool.name
}
output "kube_node_pool_status" {
  value = digitalocean_kubernetes_cluster.mainkube.node_pool.status
}
output "kube_endpoint" {
  value = digitalocean_kubernetes_cluster.mainkube.endpoint
}
output "kube_client_certificate" {
  value = "${base64decode(digitalocean_kubernetes_cluster.mainkube.kube_config.0.client_certificate)}"
}
output "kube_client_key" {
  value  = "${base64decode(digitalocean_kubernetes_cluster.mainkube.kube_config.0.client_key)}"
}
output "kube_cluster_ca_certificate" {
  value = "${base64decode(digitalocean_kubernetes_cluster.mainkube.kube_config.0.cluster_ca_certificate)}"
}
output "kubeconfig" {
  value = digitalocean_kubernetes_cluster.mainkube.kube_config.0.raw_config
}
