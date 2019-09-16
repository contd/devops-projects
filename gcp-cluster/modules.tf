// Network infrastructure module
module "network" {
  source = "./modules/network"
  // pass variables from .tfvars
  netname            = var.netname
  region             = var.region
  gcp_ip_cidr1_range = var.gcp_ip_cidr1_range
  gcp_ip_cidr2_range = var.gcp_ip_cidr2_range
}
// Kubernetes cluster module
module "cluster" {
  source = "./modules/cluster"
  // pass variables from .tfvars
  region           = var.region
  cluster_name     = var.cluster_name
  cluster_pool     = var.cluster_pool
  cluster_admin    = var.cluster_admin
  cluster_password = var.cluster_password
}
// GCP Hosted Database module
/*
module "database" {
  source = "./modules/data"
  // pass variables from .tfvars
  region  = var.region
  dbname  = var.dbname
  dbtier  = var.dbtier
}
*/

