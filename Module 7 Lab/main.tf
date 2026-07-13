terraform {
  required_providers {
    vault = { source = "hashicorp/vault", version = "~> 3.0" }
    docker = { source = "kreuzwerker/docker", version = "~> 3.0" }
  }
}

provider "vault" {
  address = "http://127.0.0.1:8200"
  token   = "myroot"
}
provider "docker" { host = "unix:///var/run/docker.sock" }

# Read the secret
data "vault_generic_secret" "db_creds" {
  path = "secret/db"
}

# Use the secret in a container deployment
resource "docker_image" "postgres" { name = "postgres:13-alpine" }
resource "docker_container" "db" {
  name  = "secure_db"
  image = docker_image.postgres.image_id
  env   = ["POSTGRES_PASSWORD=${data.vault_generic_secret.db_creds.data["config_password"]}"]
}
