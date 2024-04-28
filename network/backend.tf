terraform {
  backend "s3" {
    bucket         = "terraform.state.knin.cloud"
    key            = "network/terraform.tfstate"
    region         = "sa-east-1"
    dynamodb_table = "network/terraform-lock-table"
  }
}
