terraform {
  backend "s3" {
    bucket         = "terraform.state.knin.cloud"
    key            = "api/terraform.tfstate"
    region         = "sa-east-1"
    dynamodb_table = "api/terraform-lock-table"
  }
}
