provider "aws" {
  region  = var.aws_region
  version = "~> 1.55.0"
}
provider "kubernetes" {}
provider "helm" {}
