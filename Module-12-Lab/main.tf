terraform {
  required_providers { docker = { source = "kreuzwerker/docker" } }
}
provider "docker" { host = "unix:///var/run/docker.sock" }

resource "docker_network" "obs_net" { name = "observability_vpc" }

# 1. Provision Node Exporter (Target to monitor)
resource "docker_image" "node_exporter" { name = "prom/node-exporter:latest" }
resource "docker_container" "node_exporter" {
  name  = "node_exporter"
  image = docker_image.node_exporter.image_id
  ports {
    internal = 9100
    external = 9100
  }
  networks_advanced { name = docker_network.obs_net.name }
}

# 2. Provision Prometheus
resource "docker_image" "prometheus" { name = "prom/prometheus:latest" }
resource "docker_container" "prometheus" {
  name  = "prometheus_server"
  image = docker_image.prometheus.image_id
  ports {
    internal = 9090
    external = 9090
  }
  volumes {
    host_path      = "${abspath(path.cwd)}/prometheus.yml"
    container_path = "/etc/prometheus/prometheus.yml"
  }
  networks_advanced { name = docker_network.obs_net.name }
}

# 3. Provision Grafana
resource "docker_image" "grafana" { name = "grafana/grafana:latest" }
resource "docker_container" "grafana" {
  name  = "grafana_dashboard"
  image = docker_image.grafana.image_id
  ports {
    internal = 3000
    external = 3000
  }
  networks_advanced { name = docker_network.obs_net.name }
}
