variable "domains" {
  description = "List of domains and their respective subdomains"
  type = list(object({
    name     = string
    wildcard = list(string)
    sub_domains = list(object({
      name = string
      mtls = optional(object({
        enabled    = optional(bool)
        truststore = optional(string)
        bucket = optional(string)
        truststore_name = optional(string)
        truststore_version = optional(string)
      }))
    }))
  }))
}

output "output" {
  value = var.domains
}