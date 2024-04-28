locals {
  yaml_content = file("${path.module}/config/domain.yaml")
  yaml_data = yamldecode(local.yaml_content)
}

output "config" {
  value = local.yaml_data.domains
}

module "domain_setup" {
  source   = "./config"
  domains  = local.yaml_data.domains
}
