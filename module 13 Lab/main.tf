terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "mock_key"
  secret_key                  = "mock_secret"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  
  # Crucial for GitHub Actions DNS routing
  s3_use_path_style           = true

  endpoints {
    s3 = "http://localhost:4566"
  }
}

resource "aws_s3_bucket" "pipeline_bucket" {
  bucket        = "module-13-pipeline-verification-bucket"
  force_destroy = true

  tags = {
    Environment = "CI-CD-Testing"
    ManagedBy   = "GitHubActions"
  }
}
