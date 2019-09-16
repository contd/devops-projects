terragrunt = {
  terraform {
    source = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc.git"
  }

  include = {
    path = "${find_in_parent_folders()}"
  }

  
}

# A list of availability zones in the region
# type: list
azs = []

# The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden
# type: string
cidr = ""

# A list of database subnets
# type: list
database_subnets = []

# Name to be used on all the resources as identifier
# type: string
name = "picked-shark"

# A list of private subnets inside the VPC
# type: list
private_subnets = []

# A list of public subnets inside the VPC
# type: list
public_subnets = []


