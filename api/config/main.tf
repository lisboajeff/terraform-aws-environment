variable "domains" {
  description = "List of domains"
  type = list(object({
    name = string
    sub_domains = list(object({
      name = string
      mtls = optional(object({
        enabled            = optional(bool)
        truststore         = optional(string)
        bucket             = optional(string)
        truststore_name    = optional(string)
        truststore_version = optional(string)
      }))
    }))
  }))
}

output "output" {
  value = var.domains
}
