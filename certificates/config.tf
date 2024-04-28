variable "domain_yaml_path" {
  type        = string
  default     = ""
  description = "Path to the domain.yaml file"
}
locals {
  yaml_content = file("${var.domain_yaml_path}")
  yaml_data = yamldecode(local.yaml_content)
}

output "config" {
  value = local.yaml_data.domains
}

module "domain_setup" {
  source   = "./config"
  domains  = local.yaml_data.domains
}
