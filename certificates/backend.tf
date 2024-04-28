terraform {
  backend "s3" {
    bucket         = "terraform.state.knin.cloud"
    key            = "certificates/terraform.tfstate"
    region         = var.AWS_REGION
    dynamodb_table = "certificates/terraform-lock-table"
  }
}
