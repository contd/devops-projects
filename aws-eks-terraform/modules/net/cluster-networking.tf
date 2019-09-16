data "aws_availability_zones" "available" {}
// VPC for whole EKS network
resource "aws_vpc" "eks-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  tags = "${
    map(
     "Name", "terraform-eks-vpc",
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"
}
// Subnet for the EKS cluster and other resources related to hosted services and servers
resource "aws_subnet" "eks-subnets" {
  count             = 2
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = aws_vpc.eks-vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = "${
    map(
     "Name", "terraform-eks-subnet",
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"
}
// Group subnets for cluster
resource "aws_db_subnet_group" "default" {
  name = "main"
  subnet_ids = ["${aws_subnet.eks-subnets.*.id}"]
}
// Allows EKS cluster to connect to the internet
resource "aws_internet_gateway" "eks-gw" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = {
    Name = "terraform-eks-gateway"
  }
}
// Makes sure that gateways are addressed by instances inside the subnets by default
// when they try to connect to the internet.
// Route table for the application subnet
resource "aws_route_table" "eks-routetbl" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-gw.id
  }
}
// Associates application route table with corresponding subnet
resource "aws_route_table_association" "eks" {
  count          = 2
  subnet_id      = aws_subnet.eks-subnets.*.id[count.index]
  route_table_id = aws_route_table.eks-routetbl.id
}