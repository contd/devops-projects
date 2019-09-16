output "kubeconfig" {
  value = local.kubeconfig
}
output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}
output "target_group_arn" {
  value = aws_lb_target_group.eks.arn
}