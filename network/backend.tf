terraform {
  backend "s3" {
    bucket         = "terraform.state.knin.cloud"
    key            = "network/terraform.tfstate"
    region         = var.AWS_REGION
    dynamodb_table = "network/terraform-lock-table"
  }
}
