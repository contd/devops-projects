output "vpc_id" {
  value = aws_vpc.eks-vpc.id
}
output "subnet_ids" {
  value = "${aws_subnet.eks-subnets.*.id}"
}
output "subnet_group" {
  value = aws_db_subnet_group.default.name
}
output "cluster_security_group" {
  value = aws_security_group.eks-cluster.id
}
output "node_security_group" {
  value = aws_security_group.eks-node.id
}
