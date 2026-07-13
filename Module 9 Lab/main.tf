terraform {

required_providers {

	kubernetes = {source = "hashicorp/kubernetes", version = "~>2.0"}
}
}


provider "kubernetes" {

	config_path = "~/.kube/config"
}


resource "kubernetes_namespace" "app_ns" {
	metadata { name = "local-k8s-app"}
}

resource "kubernetes_deployment" "nginx" {

metadata {

	name = "nginx-deployment"
	namespace = kubernetes_namespace.app_ns.metadata[0].name
}

spec {

	replicas = 2
	selector {match_labels = {app = "WebApp"} }
	template {
		metadata {labels = {app = "WebApp"} }
spec {
container {
image = "nginx:1.21.6"
name = "nginx"
port {container_port = 80}

}
}
}
}
}

# New Resource: Expose the deployment to access it locally 
resource "kubernetes_service" "nginx_service" {
	metadata {
		name = "nginx-service"
		namespace = kubernetes_namespace.app_ns.metadata[0].name
}

spec {
	selector = {app = "WebApp"}
	port {
		port		= 80
		target_port	= 80
}
type = "NodePort"
}
}



