// Region to build into
variable "region" {
  type        = string
  description = "Used GCP Region."
}

//
variable "cluster_name" {
  type        = string
  description = "Name of the kubernetes cluster"
}

//
variable "cluster_pool" {
  type        = string
  description = "Name of the cluster node pool"
}

//
variable "cluster_admin" {
  type        = string
  description = "Admin username for cluster"
}

//
variable "cluster_password" {
  type        = string
  description = "Admin password for cluster"
}
