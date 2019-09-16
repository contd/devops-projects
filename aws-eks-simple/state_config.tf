/*
terraform {
 backend "s3" {
   region         = "us-east-2"
   bucket         = "aws-eks-simple-terraform"
   key            = "terraform.tfstate"
   encrypt        = "true"
   dynamodb_table = "tf-article-statelock"
 }
}
*/
