terraform {

required_providers {docker = {source = "kreuzwerker/docker"} }
}

provider "docker" {host = "unix:///var/run/docker.sock"}

resource "docker_network" "lb_net" { name = "lb_network" }

resource "docker_image" "nginx" {name = "nginxdemos/hello:latest"}
resource "docker_image" "haproxy" {name = "haproxy:latest"}

# Create two backends
resource "docker_container" "web1" {

	name = "web1"
	image = docker_image.nginx.image_id
	networks_advanced {name = docker_network.lb_net.name}
}

resource "docker_container" "web2" {

	name = "web2"
	image = docker_image.nginx.image_id
	networks_advanced {name = docker_network.lb_net.name}
}

# Create Load Balancer

resource "docker_container" "lb" {
	name = "haproxy_lb"
	image = docker_image.haproxy.image_id
	ports {
	internal = 80
	external = 8080
}

	volumes {
	host_path = "${abspath(path.cwd)}/haproxy.cfg"
	container_path = "/usr/local/etc/haproxy/haproxy.cfg"
	}

	networks_advanced {name = docker_network.lb_net.name}
}
