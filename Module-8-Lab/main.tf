terraform {
  # 1. Backend block configured for MiniStack S3 (LocalStack)
  backend "s3" {
    bucket                      = "my-local-cloud-bucket"
    key                         = "terraform.tfstate"
    region                      = "us-east-1"
    endpoint                    = "http://localhost:4566"
    access_key                  = "test"
    secret_key                  = "test"
    force_path_style            = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# 2. AWS Provider configured to use the local MiniStack environment
provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    # Directing S3 API calls to the local MiniStack container
    s3 = "http://localhost:4566"
  }
}

# 3. A sample resource from a previous week to act as the "Project"
# We are dynamically appending the workspace name to the bucket so it provisions
# differently depending on if you are in the 'dev' or 'prod' workspace.
resource "aws_s3_bucket" "project_bucket" {
  bucket = "my-app-data-${terraform.workspace}"
}

# 4. Output to verify which environment you are currently operating in
output "environment" {
  value = terraform.workspace
}