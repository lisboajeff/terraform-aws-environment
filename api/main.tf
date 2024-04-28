locals {
  sub_domains_map = {
    for item in flatten([
      for domain in module.domain_setup.output : [
        for sub_domain in domain.sub_domains : {
          key = "${sub_domain.name}",
          value = {
            domain_name     = domain.name,
            sub_domain_name = sub_domain.name,
            mtls            = sub_domain.mtls != null ? merge(sub_domain.mtls, { enabled = true }) : { enabled = false }
          }
        }
      ]
    ]) : item.key => item.value
  }
}

module "custom_domain" {
  for_each        = local.sub_domains_map
  source          = "./custom"
  domain_name     = each.value.domain_name
  sub_domain_name = each.value.sub_domain_name
  mtls            = each.value.mtls
}
