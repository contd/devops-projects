//
resource "google_container_cluster" "primary" {
  name                     = var.cluster_name
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = "3"
  master_auth {
    username = var.cluster_admin
    password = var.cluster_password
  }
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    labels = {
      Name = "terraform-kubernetes"
    }
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}
//
resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = var.cluster_pool
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 3
  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
//
output "kube_endpoint" {
  value = google_container_cluster.primary.endpoint
}
//
output "client_certificate" {
  value = google_container_cluster.primary.master_auth.0.client_certificate
}
//
output "client_key" {
  value = google_container_cluster.primary.master_auth.0.client_key
}
//
output "cluster_ca_certificate" {
  value = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
}
