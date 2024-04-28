variable "domain_name" {
  type        = string
  description = "Domain name"
}

variable "sub_domain_name" {
  type = string
}

variable "type" {
  type    = string
  default = "REGIONAL"
}

variable "mtls" {
  type = object({
    enabled            = bool
    bucket             = optional(string)
    truststore_name    = optional(string)
    truststore_version = optional(string)
  })
}

data "aws_acm_certificate" "acm" {
  domain      = var.domain_name
  statuses    = ["ISSUED"] # Lista de status desejados
  most_recent = true       # Se existirem múltiplos certificados, pega o mais recente
}

data "aws_route53_zone" "primary" {
  name = var.domain_name
}

module "aws_api_gateway_domain_name_mtls" {
  count                    = var.mtls.enabled ? 1 : 0
  source                   = "./mtls"
  mtls                     = var.mtls
  domain_name              = var.sub_domain_name
  regional_certificate_arn = data.aws_acm_certificate.acm.arn
  type                     = var.type
  route53_zone_id          = data.aws_route53_zone.primary.zone_id
}

module "aws_api_gateway_domain_name_comum" {
  count                    = var.mtls.enabled ? 0 : 1
  source                   = "./comum"
  domain_name              = var.sub_domain_name
  regional_certificate_arn = data.aws_acm_certificate.acm.arn
  type                     = var.type
  route53_zone_id          = data.aws_route53_zone.primary.zone_id
}
