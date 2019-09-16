//
resource "google_compute_network" "gcpnet" {
  name                    = var.netname
  auto_create_subnetworks = false
}
//
resource "google_compute_subnetwork" "subnet1" {
  name          = "subnet1"
  ip_cidr_range = var.gcp_ip_cidr1_range
  region        = var.region
  network       = google_compute_network.gcpnet.name
}
//
resource "google_compute_subnetwork" "subnet2" {
  name          = "subnet2"
  ip_cidr_range = var.gcp_ip_cidr2_range
  region        = var.region
  network       = google_compute_network.gcpnet.name
}
//
output "gcp_network_name" {
  value = google_compute_network.gcpnet.name
}
//
output "gcp_network_uri" {
  value = google_compute_network.gcpnet.self_link
}
//
output "gcp_subnetwork1_id" {
  value = google_compute_subnetwork.subnet1.self_link
}
//
output "gcp_subnetwork2_id" {
  value = google_compute_subnetwork.subnet2.self_link
}
