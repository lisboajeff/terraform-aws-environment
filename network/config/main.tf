variable "domains" {
  description = "List of domains"
  type = list(object({
    name     = string
  }))
}

output "output" {
  value = var.domains
}