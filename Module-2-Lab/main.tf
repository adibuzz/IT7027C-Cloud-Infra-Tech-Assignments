terraform {
  required_providers {
    docker = { source = "kreuzwerker/docker", version = "~> 3.0.0" }
  }
}
provider "docker" { host = "unix:///var/run/docker.sock" }

# 1. IaaS Simulation: Raw Ubuntu Server (Kept alive with sleep)
resource "docker_image" "ubuntu" {
  name         = "ubuntu:latest"
  keep_locally = false
}
resource "docker_container" "iaas_server" {
  name  = "iaas_raw_server"
  image = docker_image.ubuntu.image_id
  command = ["sleep", "infinity"] 
}

# 2. PaaS Simulation: Pre-configured Web Server (Nginx)
resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = false
}
resource "docker_container" "paas_webapp" {
  name  = "paas_managed_app"
  image = docker_image.nginx.image_id
  ports {
    internal = 80
    external = 8081
  }
}
