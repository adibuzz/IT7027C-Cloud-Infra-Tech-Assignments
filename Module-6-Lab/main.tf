terraform {
  required_providers {
    aws     = { source = "hashicorp/aws", version = "~> 5.0" }
    archive = { source = "hashicorp/archive", version = "~> 2.4.0" }
  }
}

provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    dynamodb = "http://localhost:4566"
    lambda   = "http://localhost:4566"
    iam      = "http://localhost:4566"
  }
}

# 1. Provision Local DynamoDB Table
resource "aws_dynamodb_table" "local_db" {
  name           = "ServerlessOrders"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "OrderID"

  attribute {
    name = "OrderID"
    type = "S"
  }
}

# 2. Mock IAM Role for Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "local_lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# 3. Zip the Python Function
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function.zip"
}

# 4. Provision Local Lambda Function
resource "aws_lambda_function" "local_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "LocalProcessOrder"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

# After successful terraform deployment, run the following to invoke the lamba function_name
# aws --endpoint-url=http://localhost:4566 lambda invoke --function-name LocalProcessOrder output.txt
# cat output.txt