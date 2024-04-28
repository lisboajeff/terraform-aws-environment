variable "domain_name" {
  type        = string
  description = "Domain name"
}

variable "regional_certificate_arn" {
  type        = string
  description = "CERTIFICATE ARN"
}

variable "type" {
  type    = string
  default = "REGIONAL"
}

variable "route53_zone_id" {
  type = string
}

resource "aws_api_gateway_domain_name" "api_domain" {
  domain_name              = var.domain_name
  regional_certificate_arn = var.regional_certificate_arn
  endpoint_configuration {
    types = [var.type]
  }
}

resource "aws_route53_record" "api_dns" {
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = aws_api_gateway_domain_name.api_domain.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.api_domain.regional_zone_id
    evaluate_target_health = true
  }
}
