variable "domains" {
  description = "List of domains and their respective subdomains"
  type = list(object({
    name     = string
    wildcard = list(string)
  }))
}

output "output" {
  value = var.domains
}
