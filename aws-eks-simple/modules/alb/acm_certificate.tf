data "aws_acm_certificate" "kumpf" {
  domain   = "*.${var.hosted_zone_url}"
  statuses = ["ISSUED"]
}
