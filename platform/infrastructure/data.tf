data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_acm_certificate" "ingress" {
  domain      = "*.${var.route53_domain_name}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "selected" {
  name = var.route53_domain_name
}
