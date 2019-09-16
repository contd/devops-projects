// Application Load Balancer
resource "aws_alb" "front_end" {
  name            = "eks-alb"
  subnets         = [var.subnet_ids]
  security_groups = [var.node_sg_id, aws_security_group.front_end_sg.id]
  ip_address_type = "ipv4"
  tags = "${
    map(
     "Name", "eks-alb",
     "kubernetes.io/cluster/eks", "owned",
    )
  }"
}
// ALB http listener and redirect
resource "aws_alb_listener" "front_end_http" {
  load_balancer_arn = aws_alb.front_end.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type            = "redirect"
    redirect {
      port          = "443"
      protocol      = "HTTPS"
      status_code   = "HTTP_301"
    }
  }
}
// ALB https listener
resource "aws_alb_listener" "front_end_https" {
  load_balancer_arn  = aws_alb.front_end.arn
  port               = 443
  protocol           = "HTTPS"
  ssl_policy         = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn    = aws_acm_certificate_validation.cert.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = var.lb_target_group_arn
  }
}