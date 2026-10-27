terraform {
  backend "s3" {
    bucket = "terraform-backend-bucket-vishal"
    key    = "Database/dynamodb/dev/test/terraform.tfstate"
    region = "ap-south-1"
  }
}