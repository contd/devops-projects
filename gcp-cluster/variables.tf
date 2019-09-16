//
variable "netname" {
  type        = string
  description = "Name of GCP cluster network"
}
// Region to build into
variable "region" {
  type        = string
  description = "Used GCP Region."
}
//
variable "project" {
  type        = string
  description = "Google GCP Project"
}
//
variable "subnet_count" {
  type        = string
  description = "Subnet count"
}
//
variable gcp_ip_cidr1_range {
  type        = string
  description = "IP CIDR Range 1 for Google VPC."
}
//
variable gcp_ip_cidr2_range {
  type        = string
  description = "IP CIDR Range 2 for Google VPC."
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
//
variable "dbname" {
  type        = string
  description = "Name of the GCP hosted Postgres database"
}
//
variable "dbtier" {
  type        = string
  description = "Tier of the GCP hosted Postgres database"
}
