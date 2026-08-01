terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "hello" {
  name = "nginxdemos/hello:latest"
}

resource "docker_container" "hello" {
  name  = "hello-world"
  image = docker_image.hello.image_id

  ports {
    internal = 80
    external = 8080
  }
}