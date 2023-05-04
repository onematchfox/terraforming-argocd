locals {
  ingress_host = var.create_ingress ? "${var.service}.${var.ingress_domain}" : null

  ingress_helm_values = {
    create = var.create_ingress
    annotations = {
      "alb.ingress.kubernetes.io/certificate-arn" = local.ingress_certificate_arn
    }
    host = local.ingress_host
  }

  ingress_certificate_arn = var.create_ingress ? aws_acm_certificate.ingress[0].arn : null
}

resource "aws_acm_certificate" "ingress" {
  count = var.create_ingress ? 1 : 0

  domain_name       = local.ingress_host
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "ingress_cert_validation" {
  for_each = var.create_ingress ? {
    for dvo in aws_acm_certificate.ingress[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.selected.zone_id
}
