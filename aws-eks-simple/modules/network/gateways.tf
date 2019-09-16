resource "aws_internet_gateway" "kumpf" {
  vpc_id = aws_vpc.kumpf.id
}

resource "aws_eip" "nat_gateway" {
  count = var.subnet_count
  vpc   = true
}

resource "aws_nat_gateway" "kumpf" {
  count         = var.subnet_count
  allocation_id = aws_eip.nat_gateway.*.id[count.index]
  subnet_id     = aws_subnet.gateway.*.id[count.index]
  tags = {
    Name = "nat_gateway"
  }
  depends_on = ["aws_internet_gateway.kumpf"]
}
