terragrunt = {
  terraform {
    source = "git::git@github.com:terraform-aws-modules/terraform-aws-alb.git"
  }

  include = {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../vpc", "../security-group_1"]
  }
}

# The resource name and Name tag of the load balancer.
# type: string
load_balancer_name = "quick-python"

# Controls if the ALB will log requests to S3.
# type: bool
logging_enabled = false

# The security groups to attach to the load balancer. e.g. ["sg-edcd9784","sg-edcd9785"]
# type: list
security_groups = [] # @modulestf:terraform_output.security-group_1.this_security_group_id.to_list

# A list of subnets to associate with the load balancer. e.g. ['subnet-1a2b3c4d','subnet-1a2b3c4e','subnet-1a2b3c4f']
# type: list
subnets = [] # @modulestf:terraform_output.vpc.public_subnets

# VPC id where the load balancer and other resources will be deployed.
# type: string
vpc_id = "" # @modulestf:terraform_output.vpc.vpc_id


