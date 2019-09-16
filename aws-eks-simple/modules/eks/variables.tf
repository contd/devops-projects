variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "vpc_id" {
  type = string
}

variable "accessing_computer_ip" {
  type        = string
  description = "Public IP of the computer accessing the cluster via kubectl or browser."
}

variable "aws_region" {
  type        = string
  description = "WIP: List of used aws_regions. Should be a single one, might not be used at all."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type to use for nodes (default t2.micro)"
}

variable "keypair_name" {
  type = string
}

variable "app_subnet_ids" {
  type = list(string)
}
