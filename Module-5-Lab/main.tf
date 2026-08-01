terraform {
  required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
}

provider "aws" {
  access_key                  = "admin"
  secret_key                  = "password"
  region                      = "us-east-1"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  endpoints { s3 = "http://localhost:9000" }
}

resource "aws_s3_bucket" "local_storage" {
  bucket = "my-local-cloud-bucket"
}

resource "aws_s3_object" "sample_file" {
  bucket  = aws_s3_bucket.local_storage.id
  key     = "hello.txt"
  content = "Welcome to Local S3 Object Storage!"
}
