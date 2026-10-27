resource "aws_security_group" "lambda_sg" {

  name = "${var.project_name}-lambda-sg"

  vpc_id = var.vpc_id

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-lambda-sg"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}



data "archive_file" "lambda_zip" {

  type = "zip"

  source_file = "${path.module}/lambda/lambda_function.py"

  output_path = "${path.module}/lambda/lambda_function.zip"
}


resource "aws_lambda_function" "CRUD" {

  function_name = "${var.project_name}-CRUD"

  role    = aws_iam_role.lambda_execution_role.arn
  handler = "lambda_function.lambda_handler"

  runtime = "python3.14"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  timeout = 90


  depends_on = [
    aws_iam_role_policy_attachment.dynamodb_crud_attachment
  ]

  tags = {
    Name        = "${var.project_name}-lambda"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}