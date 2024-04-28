terraform {
  backend "s3" {
    bucket         = "terraform.state.knin.cloud"
    key            = "api/terraform.tfstate"
    region         = var.AWS_REGION
    dynamodb_table = "api/terraform-lock-table"
  }
}
