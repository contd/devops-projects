variable "aws_region" {
  type        = string
  description = "Used AWS Region."
}

variable "subnet_count" {
  type        = string
  description = "The number of subnets we want to create per type to ensure high availability."
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "accessing_computer_ip" {
  type        = string
  description = "IP of the computer to be allowed to connect to EKS master and nodes."
}

variable "keypair_name" {
  type        = string
  description = "Name of the keypair declared in AWS IAM, used to connect into your instances via SSH."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type to use for nodes (default t2.micro)"
}

variable "hosted_zone_id" {
  type        = string
  description = "ID of the hosted Zone created in Route53 before Terraform deployment."
}

variable "hosted_zone_url" {
  type        = string
  description = "URL of the hosted Zone created in Route53 before Terraform deployment."
}
