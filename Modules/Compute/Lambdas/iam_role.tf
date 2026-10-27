
# 1. IAM Role Trust Policy
data "aws_iam_policy_document" "lambda_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# 2. IAM Execution Role
resource "aws_iam_role" "lambda_execution_role" {
  name               = "${var.function_name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
}

# 3. Least-Privilege DynamoDB Policy
data "aws_iam_policy_document" "dynamodb_crud" {
  statement {
    sid    = "DynamoDBCrudAccess"
    effect = "Allow"

    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Scan"
    ]

    resources = [var.table_arn]
  }
}

# 4. Create IAM Policy
resource "aws_iam_policy" "dynamodb_crud_policy" {
  name        = "${var.function_name}-dynamodb-crud-policy"
  description = "Allow Lambda CRUD operations on the gamescores table"

  policy = data.aws_iam_policy_document.dynamodb_crud.json
}

# 5. Attach Policy to IAM Role
resource "aws_iam_role_policy_attachment" "dynamodb_crud_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.dynamodb_crud_policy.arn
}

# 6. Allow Lambda to write logs to CloudWatch
resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
