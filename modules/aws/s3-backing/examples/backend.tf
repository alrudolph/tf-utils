terraform {
  backend "s3" {
    bucket         = "<my-bucket-name>"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "<my-table-name>"
  }
}
