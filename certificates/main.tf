module "certificate" {
  for_each                  = { for domain in module.domain_setup.output : domain.name => domain }
  source                    = "./acm"
  domain_name               = each.value.name
  subject_alternative_names = each.value.wildcard
}