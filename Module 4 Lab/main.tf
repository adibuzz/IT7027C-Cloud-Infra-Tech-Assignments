terraform {
  required_providers { docker = { source = "kreuzwerker/docker" } }
}
provider "docker" { host = "unix:///var/run/docker.sock" }

# Create isolated networks
resource "docker_network" "public_net" { name = "public_vpc" }
resource "docker_network" "private_net" { name = "private_vpc" }

# Frontend (Public AND Private)
resource "docker_image" "nginx" { name = "nginx:alpine" }
resource "docker_container" "frontend" {
  name  = "frontend_web"
  image = docker_image.nginx.image_id
  networks_advanced { name = docker_network.public_net.name }

	 # Connected to the outside world
	networks_advanced {name = docker_network.public_net.name}
	# NEW: Connected to the backend database network
	networks_advanced {name = docker_network.private_net.name}
}

# Database (Private - intentionally no ports exposed to host)
resource "docker_image" "redis" { name = "redis:alpine" }
resource "docker_container" "backend_db" {
  name  = "backend_db"
  image = docker_image.redis.image_id
  networks_advanced { name = docker_network.private_net.name }
}
