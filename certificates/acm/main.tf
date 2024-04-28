variable "domain_name" {
  type        = string
  description = "Domain name"
}

variable "subject_alternative_names" {
  type    = list(string)
  default = []
}

variable "environment" {
  type    = string
  default = "PROD"
}

data "aws_route53_zone" "primary" {
  name = var.domain_name
}

resource "aws_acm_certificate" "certificate" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = var.subject_alternative_names
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Environment = var.environment
  }
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    } if dvo.domain_name == var.domain_name
  }
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 60
}

output "aws_acm_certificate_arn" {
  value = aws_acm_certificate.certificate.arn
}

output "route53_zone_id" {
  value = data.aws_route53_zone.primary.zone_id
}
