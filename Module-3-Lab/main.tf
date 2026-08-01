terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

# Configure AWS provider to use LocalStack endpoints
provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3  = "http://localhost:4566"
    sns = "http://localhost:4566"
    sqs = "http://localhost:4566"
  }
}

resource "aws_sns_topic" "local_updates" {
  name = "local-cloud-updates-topic"
}

resource "aws_sqs_queue" "local_queue" {
  name = "local-cloud-queue"
}

resource "aws_sns_topic_subscription" "local_sub" {
  topic_arn = aws_sns_topic.local_updates.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.local_queue.arn
}
