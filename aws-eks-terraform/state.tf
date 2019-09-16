/*
// Uncomment to enable remote state storage for remote backup of state
terraform {
  required_version = "~> 0.11"

  backend "s3" {
    encrypt = true
    bucket  = "aws-eks-terraform"
    key     = "terraform.tfstate"
    region  = "us-east-2"
  }
}
*/
