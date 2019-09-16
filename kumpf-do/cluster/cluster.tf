resource "digitalocean_kubernetes_cluster" "mainkube" {
  name    = var.cluster_name
  region  = var.region
  version = var.cluster_version
  tags    = ["staging"]
  node_pool {
    name       = var.node_pool_name
    size       = var.node_pool_size
    node_count = var.number_nodes
  }
}
