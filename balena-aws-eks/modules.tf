module "net" {
  source       = "./modules/net"
  cluster_name = var.cluster_name
}
module "eks" {
  source                 = "./modules/eks"
  cluster_name           = var.cluster_name
  node_name              = var.node_name
  instance_type          = var.instance_type
  cluster_security_group = module.net.cluster_security_group
  node_security_group    = module.net.node_security_group
  vpc_id                 = module.net.vpc_id
  subnet_ids             = module.net.subnet_ids
}
// Application load balancer module
module "alb" {
  source = "./modules/alb"
  // pass variables from .tfvars
  hosted_zone_id          = var.hosted_zone_id
  hosted_zone_url         = var.hosted_zone_url
  // inputs from modules
  vpc_id                  = module.net.vpc_id
  subnet_ids              = module.net.subnet_ids
  node_sg_id              = module.net.node_security_group
  lb_target_group_arn     = module.eks.target_group_arn
}
/*
module "dev" {
  source = "./dev"
}
*/
//
output "kubeconfig" {
  value = module.eks.kubeconfig
}
//
output "config_map_aws_auth" {
  value = module.eks.config_map_aws_auth
}
/*
// Initially used to set an AWS managed Postgresql Server
module "data" {
  source                 = "./modules/data"
  vpc_id                 = module.net.vpc_id
  subnet_group           = module.net.subnet_group
}
// Initially used to set an AWS managed Postgresql Server
output "pg_id" {
  value = module.data.pg_id
}
output "pg_hostname" {
  value = module.data.pg_hostname
}
output "pg_port" {
  value = module.data.pg_port
}
output "pg_endpoint" {
  value = module.data.pg_endpoint
}
*/