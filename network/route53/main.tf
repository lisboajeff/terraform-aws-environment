variable "domain_name" {
  type = string
  description = "Domain name"
}

resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

output "name_servers" {
  value = aws_route53_zone.primary.name_servers
}

output "route53_zone_id" {
  value = aws_route53_zone.primary.zone_id
}