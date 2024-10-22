terragrunt = {
  terraform {
    source = "git::git@github.com:terraform-aws-modules/terraform-aws-autoscaling.git"
  }

  include = {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../alb"]
  }
}

# The number of Amazon EC2 instances that should be running in the group
# type: string
desired_capacity = "0"

# Controls how health checking is done. Values are - EC2 and ELB
# type: string
health_check_type = "EC2"

# The EC2 image ID to launch
# type: string
image_id = "ami-00035f41c82244dab"

# The size of instance to launch
# type: string
instance_type = "m4.large"

# The maximum size of the auto scale group
# type: string
max_size = "0"

# The minimum size of the auto scale group
# type: string
min_size = "0"

# Creates a unique name beginning with the specified prefix
# type: string
name = "ample-zebra"

# A list of security group IDs to assign to the launch configuration
# type: list
security_groups = []

# A list of aws_alb_target_group ARNs, for use with Application Load Balancing
# type: list
target_group_arns = [] # @modulestf:terraform_output.alb.target_group_arns

# A list of subnet IDs to launch resources in
# type: list
vpc_zone_identifier = []


