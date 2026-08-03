terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# --- variables.tf Architecture ---
variable "enable_failover" {
  type        = bool
  default     = false
  description = "Set to true to declaratively divert traffic from the primary region to the disaster recovery region."
}

# --- provider.tf Aliasing Architecture ---
# Primary Region Configuration
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "mock_key"
  secret_key                  = "mock_secret"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style         = true
  endpoints {
    s3 = "http://localhost:4566"
  }
}

# Secondary/Disaster Recovery Region Configuration (Aliased)
provider "aws" {
  alias                       = "west"
  region                      = "us-west-2"
  access_key                  = "mock_key"
  secret_key                  = "mock_secret"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style         = true
  endpoints {
    s3 = "http://localhost:4566"
  }
}

# --- Active Workloads ---
# Resource in Primary Region (us-east-1)
resource "aws_s3_bucket" "primary_site" {
  bucket        = "company-active-primary-datacenter"
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "primary_web" {
  bucket = aws_s3_bucket.primary_site.id
  index_document { suffix = "index.html" }
}

# Resource in Disaster Recovery Region (us-west-2 via Alias)
resource "aws_s3_bucket" "backup_site" {
  provider      = aws.west
  bucket        = "company-resilient-standby-datacenter"
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "backup_web" {
  provider = aws.west
  bucket   = aws_s3_bucket.backup_site.id
  index_document { suffix = "index.html" }
}

# --- Declarative DNS / Traffic Routing Logic ---
# Emulating a dynamic routing change based on state variables
output "active_production_endpoint" {
  value = var.enable_failover ? aws_s3_bucket_website_configuration.backup_web.website_endpoint : aws_s3_bucket_website_configuration.primary_web.website_endpoint
  description = "The live endpoint handling global enterprise traffic."
}

# Simulate regional catastrophe by this bash command: aws --endpoint-url=http://localhost:4566 s3 rb s3://company-active-primary-datacenter --force

# After that, instruct Terraform to execute the disaster recovery routing procedure by modifying the runtime state variables: terraform apply -var="enable_failover=true" -auto-approve
# Observe how the infrastructure reconciles and shifts the active endpoint location natively without dropping global infrastructure context.