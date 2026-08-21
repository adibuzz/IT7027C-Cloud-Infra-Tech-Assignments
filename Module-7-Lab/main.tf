# Before running this terraform script, run the following in your terminal
# docker run --cap-add=IPC_LOCK -d --name=dev-vault -e 'VAULT_DEV_ROOT_TOKEN_ID=myroot' -p 8200:8200 hashicorp/vault server -dev
# docker exec -e VAULT_ADDR="http://127.0.0.1:8200" dev-vault vault kv put secret/db config_password="YourSecurePassword123!"

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
data "vault_kv_secret_v2" "db_creds" {
  mount = "secret"
  name = "db"
}

# Use the secret in a container deployment
resource "docker_image" "postgres" { name = "postgres:13-alpine" }
resource "docker_container" "db" {
  name  = "secure_db"
  image = docker_image.postgres.image_id
  env   = ["POSTGRES_PASSWORD=${data.vault_kv_secret_v2.db_creds.data["config_password"]}"]
}