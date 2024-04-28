variable "AWS_REGION" {
  type = string
}

provider "aws" {
  region = var.AWS_REGION
}