// To set the desired AMI and custom user_data for the EC2 nodes used
data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.eks.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}
// Required userdata for EKS worker nodes to properly configure Kubernetes applications on
// the EC2 instance. https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
// Also added tweaks for some container apps need higher ulimit and such (i.e ElasticStack)
locals {
  eks-node-userdata = <<USERDATA
#!/bin/bash
cat << EOF >/etc/security/limits.conf
# /etc/security/limits.conf
#
* soft nofile 65536
* hard nofile 131072
* soft nproc 2048
* hard nproc 4096
# End of file
EOF
cat << EOF >>/etc/sysctl.conf
# Added for Elasticsearch
vm.max_map_count = 262144
EOF
sysctl -p
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks.certificate_authority.0.data}' '${var.cluster_name}'
USERDATA
}
/*
// EKS EC2 Optimized and Custom Launch Template
resource "aws_launch_template" "eks" {
  name                 = "EKS EC2 Optimized and Custom Launch Template"
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size      = 20
      snapshot_id      = ""
    }
  }
  ebs_optimized = true
  iam_instance_profile {
    name               = "balena-ec2"
  }
  image_id             = "ami-0484545fe7d3da96f"
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.eks-node.name
  key_name             = "id_rsa"
  security_groups      = [var.node_security_group]
  user_data_base64     = "${base64encode(local.eks-node-userdata)}"
  tag_specifications {
    resource_type      = "instance"
    tags = {
      Name             = "terraform-eks-ec2"
    }
  }
}
*/
// How new nodes are configured when launched and added to the pool
resource "aws_launch_configuration" "eks" {
  associate_public_ip_address = true
  name_prefix          = "terraform-eks"
  key_name             = "id_rsa"
  iam_instance_profile = aws_iam_instance_profile.eks-node.name
  image_id             = data.aws_ami.eks-worker.id
  instance_type        = var.instance_type
  security_groups      = [var.node_security_group]
  user_data_base64     = "${base64encode(local.eks-node-userdata)}"
  ebs_optimized        = true

  lifecycle {
    create_before_destroy = true
  }
}
// Target Group resource for use with Load Balancer resources
resource "aws_lb_target_group" "eks" {
  name = "terraform-eks-group"
  port = 31742
  protocol = "HTTPS"
  vpc_id = var.vpc_id
  target_type = "instance"
}
// Node group to auto-scale to meet container deployment demands
resource "aws_autoscaling_group" "eks" {
  desired_capacity     = 3
  max_size             = 3
  min_size             = 1
  name                 = "terraform-eks"
  vpc_zone_identifier  = [var.subnet_ids]
  target_group_arns    = [aws_lb_target_group.eks.arn]

  launch_configuration = aws_launch_configuration.eks.id
  //launch_template {
  //  id      = aws_launch_template.eks.id
  //  version = "$$Latest"
  //}

  tag {
    key                 = "Name"
    value               = "terraform-eks"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}
