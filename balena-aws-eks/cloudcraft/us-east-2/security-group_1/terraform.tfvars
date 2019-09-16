terragrunt = {
  terraform {
    source = "git::git@github.com:terraform-aws-modules/terraform-aws-security-group.git"
  }

  include = {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../vpc"]
  }
}

# Name of security group
# type: string
name = "ready-jackal"

# ID of the VPC where to create security group
# type: string
vpc_id = "" # @modulestf:terraform_output.vpc.vpc_id


