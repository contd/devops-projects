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
variable gcp_ip_cidr1_range {
  type        = string
  description = "IP CIDR Range 1 for Google VPC."
}
//
variable gcp_ip_cidr2_range {
  type        = string
  description = "IP CIDR Range 2 for Google VPC."
}
