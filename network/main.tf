module "route53_zone" {
  source      = "./route53"
  for_each    = { for domain in module.domain_setup.output : domain.name => domain }
  domain_name = each.value.name
}
