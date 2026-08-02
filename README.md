# IT7027C - Cloud Infrastructure Technology

This repository contains the complete set of labs and capstone project for the IT7027C Cloud Infrastructure Technology course. It is organized as a hands-on collection of Terraform-based infrastructure exercises that explore Docker, AWS emulation, Vault, Kubernetes, observability, load balancing, hybrid cloud, and CI/CD concepts.

## Repository Structure

- `Module-1-Lab/` through `Module-14-Lab/`: One lab per module, with Terraform manifests and supporting scripts.
- `Capstone-Lab/`: Final capstone project demonstrating integrated infrastructure automation with Docker, Vault, MiniStack, HAProxy, and Terraform.
- `IT7027C-Syllabus-Online.docx` / `IT7027C-Syllabus-Online.pdf`: Course syllabus materials.

## Prerequisites

The labs assume a development environment with the following tools:

- Terraform 1.x
- Docker Engine
- MiniStack for AWS emulation
- HashiCorp Vault (or Vault dev server)
- Kubernetes / Minikube and a valid `~/.kube/config` for Kubernetes labs
- Bash-compatible shell (WSL2, Git Bash, or Linux shell recommended on Windows)

## General Usage

Most module folders follow this workflow:

```bash
cd Module-X-Lab
terraform init
terraform apply -auto-approve
# validate manually or with provided script
terraform destroy -auto-approve
```

Some modules include extra scripts for bootstrapping, validation, or cleanup.

## Module Summaries

### Module-1-Lab
- Purpose: Docker container deployment with Terraform.
- Files: `main.tf`, `setup.sh`
- Outcome: Pulls `nginxdemos/hello:latest` and creates a container named `hello-world` with port mapping from `80` to `8080`.

### Module-2-Lab
- Purpose: Simulate IaaS and PaaS infrastructure models.
- Files: `main.tf`
- Outcome: Creates an Ubuntu container representing raw infrastructure and an NGINX container representing a managed web platform.

### Module-3-Lab
- Purpose: Local AWS service emulation with MiniStack.
- Files: `main.tf`
- Outcome: Configures the AWS provider to use MiniStack endpoints and provisions an SNS topic, an SQS queue, and a subscription linking them.

### Module-4-Lab
- Purpose: Network segmentation and container multi-tier design.
- Files: `main.tf`
- Outcome: Creates a public and private Docker network, deploys a frontend NGINX container attached to both, and deploys a Redis backend container on the private network.

### Module-5-Lab
- Purpose: Local S3-compatible storage emulation.
- Files: `main.tf`
- Outcome: Creates an S3 bucket and uploads a simple object to demonstrate object storage operations.

### Module-6-Lab
- Purpose: Serverless architecture using local AWS emulation.
- Files: `main.tf`, `lambda_function.py`
- Outcome: Creates a DynamoDB table, packages a Python Lambda function, and deploys the function locally.

### Module-7-Lab
- Purpose: Secrets management integration with Vault.
- Files: `main.tf`
- Outcome: Reads a secret from Vault and passes the secret data into a PostgreSQL container environment variable.

### Module-8-Lab
- Purpose: Terraform remote state backend configuration.
- Files: `main.tf`
- Outcome: Configures an S3 remote backend against MiniStack and outputs the current Terraform workspace.

### Module-9-Lab
- Purpose: Kubernetes workload provisioning with Terraform.
- Files: `main.tf`
- Outcome: Creates a Kubernetes namespace, deploys an NGINX deployment with two replicas, and exposes it with a NodePort service.

### Module-10-Lab
- Purpose: Load balancing with HAProxy and Docker.
- Files: `main.tf`, `haproxy.cfg`
- Outcome: Launches two NGINX backend containers and an HAProxy load balancer container that routes traffic between them.

### Module-11-Lab
- Purpose: Hybrid cloud simulation with multiple providers.
- Files: `main.tf`, `val11-lab.sh`
- Outcome: Uses Docker to simulate an on-premises Redis cache and includes a Kubernetes provider configuration for hybrid cloud deployments. Validation script checks both Docker and Kubernetes resources.

### Module-12-Lab
- Purpose: Observability stack deployment.
- Files: `main.tf`, `prometheus.yml`
- Outcome: Deploys Prometheus, Grafana, and node exporter containers, and configures Prometheus to scrape metrics from node exporter.

### Module-13-Lab
- Purpose: CI/CD and pipeline verification using MiniStack.
- Files: `main.tf`, `verify-local.sh`, `.github/`, `.gitignore`
- Outcome: Creates a MiniStack-backed S3 bucket and validates it using a shell script. Includes GitHub Actions workflow examples.

### Module-14-Lab
- Purpose: Disaster recovery and provider aliasing in Terraform.
- Files: `main.tf`
- Outcome: Configures two aliased AWS providers for primary and DR regions, provisions S3 website buckets in each region, and exposes a failover-aware endpoint output.

## Capstone-Lab

The final capstone lab integrates multiple course concepts into a single local infrastructure pipeline.

- `bootstrap.sh`: Boots MiniStack and Vault, creates the Terraform backend bucket, and injects Vault secrets.
- `cleanup.sh`: Destroys Terraform resources and removes Docker containers/images.
- `deploy.yml`: Example GitHub Actions workflow for Terraform initialization, validation, and apply.
- `haproxy.cfg.tftpl`: Template file used to render HAProxy configuration dynamically.
- `validate-capstone.sh`: Verification script for the capstone deployment.

### Capstone Features
- Docker network creation for production-style infrastructure.
- MiniStack S3 backend for Terraform state.
- Vault secret injection for database credentials.
- Dynamic scaling of NGINX web servers via Terraform `count`.
- HAProxy load balancing with templated configuration.
- Validation of deployed load balancer and backend containers.

### Capstone Workflow

```bash
cd Capstone-Lab
bash bootstrap.sh
terraform init
terraform apply -auto-approve
bash validate-capstone.sh
bash cleanup.sh
```

## Important Notes

- Many labs use Docker UNIX socket configuration (`unix:///var/run/docker.sock`). On Windows, use WSL2 or a compatible Docker environment.
- MiniStack and Vault are expected to run on `localhost:4566` and `localhost:8200` respectively for the relevant labs.
- Kubernetes labs expect a valid local Kubernetes cluster and kubeconfig file.
- The repository is best used as a curriculum reference; each module is intentionally isolated to illustrate a single concept.

## Useful Commands

```bash
terraform init
terraform apply -auto-approve
terraform destroy -auto-approve
bash <script-name>.sh
```

---

This repository is intended for hands-on learning and demonstration of cloud infrastructure practices using Terraform, containerization, DevOps automation, and local service emulation.