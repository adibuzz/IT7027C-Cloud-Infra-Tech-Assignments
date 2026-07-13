terraform {
  backend "s3" {
    bucket                      = "capstone-state-bucket"
    key                         = "prod/terraform.tfstate"
    region                      = "us-east-1"
    endpoint                    = "http://localhost:4566"
    access_key                  = "test"
    secret_key                  = "test"
    force_path_style            = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
  }
  required_providers {
    docker = { source = "kreuzwerker/docker", version = "~> 3.0" }
    vault  = { source = "hashicorp/vault", version = "~> 3.0" }
  }
}

provider "docker" {	host = "unix:///var/run/docker.sock" }

provider "vault" {
	address = "http://localhost:8200"
	token = "myroot"
}

# 1. Network & Data Retrieval
resource "docker_network" "capstone_net" { name = "capstone_production_network" }
data "vault_generic_secret" "db_creds" { path = "secret/capstone" }

# 2. Database Backend (Using Vault Secret)
resource "docker_image" "postgres" { name = "postgres:14-alpine" }
resource "docker_container" "database" {
  name  = "capstone_db"
  image = docker_image.postgres.image_id
  env   = ["POSTGRES_PASSWORD=${data.vault_generic_secret.db_creds.data["db_pass"]}"]
  networks_advanced { name = docker_network.capstone_net.name }
}

# 3. Dynamic Web Tier (EXTRA CREDIT: Using `count` to scale dynamically)
variable "web_server_count" { default = 2 }

resource "docker_image" "nginx" { name = "nginxdemos/hello:latest" }
resource "docker_container" "web" {
  count = var.web_server_count
  name  = "capstone_web_${count.index + 1}"
  image = docker_image.nginx.image_id
  networks_advanced { name = docker_network.capstone_net.name }
}

# 4. Dynamic HAProxy Rendering (EXTRA CREDIT: templatefile rendering)
resource "local_file" "haproxy_cfg" {
  filename = "${abspath(path.cwd)}/haproxy.cfg"
  content  = templatefile("${abspath(path.cwd)}/haproxy.cfg.tftpl", { 
    backends = docker_container.web 
  })
}

# Force a 5-second pause to allow filesystem to flush

resource "time_sleep" "wait_for_filesystem_sync" {
depends_on = [local_file.haproxy_cfg]

create_duration = "5s"
}

# 5. Load Balancer 
resource "docker_image" "haproxy" { name = "haproxy:latest" }

resource "docker_container" "lb" {
  name  = "capstone_lb"
  image = docker_image.haproxy.image_id
  ports {
	 internal = 80
	 external = 8800
}
  
  volumes {
    host_path      = local_file.haproxy_cfg.filename
    container_path = "/usr/local/etc/haproxy/haproxy.cfg"
  }
  networks_advanced { name = docker_network.capstone_net.name }
  depends_on = [time_sleep.wait_for_filesystem_sync] # Wait for file to render
}
