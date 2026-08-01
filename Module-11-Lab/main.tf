terraform {

	required_providers {
		docker = { source = "kreuzwerker/docker"}
		kubernetes = {source = "hashicorp/kubernetes"}
			}
}

provider "docker" {host = "unix:///var/run/docker.sock" }

# Added config_context here as well for stability

provider "kubernetes" {

	config_path = "~/.kube/config"
	config_context = "minikube"
}


# Provider 1: Docker (Simulating On-Prem)

resource "docker_image" "redis" {name = "redis:alpine"}

resource "docker_container" "on_prem_cache" {
name = "hybrid_redis"
image = docker_image.redis.image_id
}

# Provider 2: Kubernetes (Simulating Public Cloud)

resource "kubernetes_namespace" "hybrid_ns" {
metadata {name = "hybrid-cloud-ns"}
}
