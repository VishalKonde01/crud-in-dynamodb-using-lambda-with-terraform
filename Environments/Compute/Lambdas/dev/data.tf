data "terraform_remote_state" "dynamodb_backend" {
  
backend = "s3" 
    config = {
       bucket = "terraform-backend-bucket-vishal"
    key    = "Database/dynamodb/dev/test/terraform.tfstate"
    region = "ap-south-1"
    }


}


# data "terraform_remote_state" "lambda_role" {
  
# backend = "s3" 
#     config = {
#        bucket = "terraform-backend-bucket-vishal"
#     key    = "IAM/role/test/terraform.tfstate"
#     region = "ap-south-1"
#     }


# }


data "terraform_remote_state" "vpc_backend" {
  
backend = "s3" 
    config = {
      bucket = "terraform-backend-bucket-vishal"
    key    = "Network/VPC/dev/Meta-Args/test/terraform.tfstate"
    region = "ap-south-1"
    }


}


