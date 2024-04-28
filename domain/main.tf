module "certificate" {
  for_each                  = { for domain in module.domain_setup.output : domain.name => domain }
  source                    = "./certificates"
  domain_name               = each.value.name
  subject_alternative_names = each.value.wildcard
}

locals {
  sub_domains_map = {
    for item in flatten([
      for domain in module.domain_setup.output : [
        for sub_domain in domain.sub_domains : {
          key = "${sub_domain.name}",
          value = {
            domain_name     = sub_domain.name,
            certificate_arn = module.certificate[domain.name].aws_acm_certificate_arn
            route53_zone_id = module.certificate[domain.name].route53_zone_id
            mtls            = sub_domain.mtls != null ? merge(sub_domain.mtls, { enabled = true }) : { enabled = false }
          }
        }
      ]
    ]) : item.key => item.value
  }
}

module "custom_domain" {
  for_each                 = local.sub_domains_map
  source                   = "./api"
  domain_name              = each.value.domain_name
  regional_certificate_arn = each.value.certificate_arn
  route53_zone_id          = each.value.route53_zone_id
  mtls                     = each.value.mtls
}
