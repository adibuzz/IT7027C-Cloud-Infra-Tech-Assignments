terraform {
  required_providers {
    docker = { 
      source = "kreuzwerker/docker"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Provider 1: Docker (Simulating On-Prem)
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Provider 2: Kubernetes (Simulating Public Cloud)
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

# Provider 3: AWS (MiniStack / LocalStack)
provider "aws" {
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    iam = "http://localhost:4566"
  }
}

# --- Resources ---

# Docker Resource
resource "docker_image" "redis" {
  name = "redis:alpine"
}

resource "docker_container" "on_prem_cache" {
  name  = "hybrid_redis"
  image = docker_image.redis.image_id
}

# Kubernetes Resource
resource "kubernetes_namespace" "hybrid_ns" {
  metadata {
    name = "hybrid-dev" # Corrected from "hybrid-cloud-ns"
  }
}

# AWS Resource
resource "aws_iam_role" "mock_role" {
  name = "hybrid_dev_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# After terraform resource deployment
# for Redis, run docker ps 
# for the IAM role, run aws --endpoint-url=http://localhost:4566 iam get-role --role-name hybrid_dev_role 
# for the K8s namespace, run minikube kubectl get namespaces