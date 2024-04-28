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

variable "mtls" {
  type = object({
    enabled            = optional(bool)
    bucket             = optional(string)
    truststore_name    = optional(string)
    truststore_version = optional(string)
  })
}

module "aws_api_gateway_domain_name_mtls" {
  count                    = var.mtls.enabled ? 1 : 0
  source                   = "./mtls"
  mtls                     = var.mtls
  domain_name              = var.domain_name
  regional_certificate_arn = var.regional_certificate_arn
  type                     = var.type
  route53_zone_id          = var.route53_zone_id
}

module "aws_api_gateway_domain_name_comum" {
  count                    = var.mtls.enabled ? 0 : 1
  source                   = "./comum"
  domain_name              = var.domain_name
  regional_certificate_arn = var.regional_certificate_arn
  type                     = var.type
  route53_zone_id          = var.route53_zone_id
}
