terraform {
  backend "s3" {
    bucket = "terraform-backend-bucket-vishal"
    key    = "Compute/Lambda/dev/test/terraform.tfstate"
    region = "ap-south-1"
  }
}