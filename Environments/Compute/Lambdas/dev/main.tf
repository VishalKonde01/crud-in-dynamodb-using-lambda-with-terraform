module "aws_lambda_function" {
  source = "../../../../Modules/Compute/Lambdas"


aws_region = var.aws_region

project_name = var.project_name

function_name = var.function_name

vpc_id = data.terraform_remote_state.vpc_backend.outputs.vpc_id

table_arn = data.terraform_remote_state.dynamodb_backend.outputs.table_arn

}