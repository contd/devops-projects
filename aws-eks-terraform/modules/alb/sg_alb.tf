// Security group allowing public traffic for the eks load balancer.
resource "aws_security_group" "front_end_sg" {
  name        = "eks-security-group-public"
  description = "Security group allowing public traffic for the eks load balancer."
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "terraform-front_end_sg",
     "kubernetes.io/cluster/eks", "owned",
    )
  }"
}
// Allow eks load balancer to communicate with public traffic securely.
resource "aws_security_group_rule" "front_end_sg_http" {
  description       = "Allow eks load balancer to communicate with public traffic securely."
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.front_end_sg.id
  to_port           = 443
  type              = "ingress"
}
// Allow eks load balancer to communicate with public traffic.
resource "aws_security_group_rule" "front_end_sg_https" {
  description       = "Allow eks load balancer to communicate with public traffic."
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.front_end_sg.id
  to_port           = 80
  type              = "ingress"
}
