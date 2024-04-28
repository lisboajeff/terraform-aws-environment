terraform {
  backend "s3" {
    bucket         = "terraform.state.knin.cloud"
    key            = "certificates/terraform.tfstate"
    region         = "sa-east-1"
    dynamodb_table = "certificates/terraform-lock-table"
  }
}
