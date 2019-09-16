variable "vpc_id" {
  type = "string"
}
// ID of the hosted Zone created in Route53 before Terraform deployment.
variable "hosted_zone_id" {
  type = "string"
  description = "ID of the hosted Zone created in Route53 before Terraform deployment."
}
// Domain Name of the hosted Zone created in Route53 before Terraform deployment.
variable "hosted_zone_url" {
  type = "string"
  description = "URL of the hosted Zone created in Route53 before Terraform deployment."
}
// Subnets in network for use with elastic load balancers and elastic ips
variable "subnet_ids" {
  type = "list"
  description = "Subnets in network for use with elastic load balancers and elastic ips"
}

// ID of the Security Group used by the Kubernetes worker nodes.
variable "node_sg_id" {
  type = "string"
  description = "ID of the Security Group used by the Kubernetes worker nodes."
}
// ARN of the Target Group pointing at the Kubernetes nodes.
variable "lb_target_group_arn" {
  type = "string"
  description = "ARN of the Target Group pointing at the Kubernetes nodes."
}
