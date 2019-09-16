// Name of the EKS cluster
variable "cluster_name" {
  type        = "string"
  description = "Name of the EKS cluster"
}
// Name of the node group
variable "node_name" {
  type        = "string"
  description = "Name of the node group"
}
// AWS Region to build into
variable "aws_region" {
  type        = "string"
  description = "Used AWS Region."
}
// EC2 instance type (m4.large usually)
variable "instance_type" {
  type        = "string"
  description = "EC2 instance type (m4.large usually)"
}
// ID of the hosted Zone created in Route53 before Terraform deployment.
variable "hosted_zone_id" {
  type        = "string"
  description = "ID of the hosted Zone created in Route53 before Terraform deployment."
}
// Domain Name of the hosted Zone created in Route53 before Terraform deployment.
variable "hosted_zone_url" {
  type        = "string"
  description = "URL of the hosted Zone created in Route53 before Terraform deployment."
}
// Production or Development setting
variable "environment" {
  type        = "string"
  description = "Production or Development setting"
}
