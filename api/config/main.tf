variable "domains" {
  description = "List of domains"
  type = list(object({
    name = string
    sub_domains = list(object({
      name = string
      mtls = optional(object({
        truststore         = string
        bucket             = string
        truststore_name    = string
        truststore_version = string
      }))
    }))
  }))
}

output "output" {
  value = var.domains
}
