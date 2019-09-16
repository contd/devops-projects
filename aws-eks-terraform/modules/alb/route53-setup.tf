//
resource "aws_acm_certificate" "cert" {
  domain_name       = var.hosted_zone_url
  subject_alternative_names = ["www.${var.hosted_zone_url}", var.hosted_zone_url]
  validation_method = "DNS"
  tags = {
    Environment = "production"
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_route53_zone" "public" {
  name = var.hosted_zone_url
}
// Route53 Private Zone
resource "aws_route53_zone" "private" {
  name = var.hosted_zone_url
  vpc {
    vpc_id = var.vpc_id
  }
}
// Route53 dns root domain A record
resource "aws_route53_record" "web" {
  zone_id = var.hosted_zone_id
  name    = var.hosted_zone_url
  type    = "A"
  alias {
    name                   = aws_alb.front_end.dns_name
    zone_id                = aws_alb.front_end.zone_id
    evaluate_target_health = false
  }
}
// Route53 dns api subdomain A record
resource "aws_route53_record" "api" {
  zone_id = var.hosted_zone_id
  name    = "api.${var.hosted_zone_url}"
  type    = "A"
  alias {
    name                   = aws_alb.front_end.dns_name
    zone_id                = aws_alb.front_end.zone_id
    evaluate_target_health = false
  }
}
// Route53 cert_validation record
resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_type
  zone_id = aws_route53_zone.public.zone_id
  records = [aws_acm_certificate.cert.domain_validation_options.0.resource_record_value]
  ttl     = 60
}
resource "aws_route53_record" "cert_validation_alt1" {
  name    = aws_acm_certificate.cert.domain_validation_options.1.resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options.1.resource_record_type
  zone_id = aws_route53_zone.public.zone_id
  records = [aws_acm_certificate.cert.domain_validation_options.1.resource_record_value]
  ttl     = 60
}
resource "aws_route53_record" "cert_validation_alt2" {
  name    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_type
  zone_id = aws_route53_zone.private.zone_id
  records = [aws_acm_certificate.cert.domain_validation_options.0.resource_record_value]
  ttl     = 60
}
// Create certificate for domain(s)
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [
    aws_route53_record.cert_validation.fqdn,
    aws_route53_record.cert_validation_alt1.fqdn,
    aws_route53_record.cert_validation_alt2.fqdn
  ]
}
