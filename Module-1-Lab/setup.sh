#!/bin/bash
set -e

# Install Microsoft VS Code
# Add official rpm repository (published by Microsoft)
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

# Install using dnf directly
sudo dnf update -y &&
sudo dnf install -y code


# Install Terraform

sudo dnf install -y dnf-utils

# Add official rpm repository (published by Hashicorp)
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
# Install using dnf directly
sudo dnf -y install terraform


# Aws-ClI install # You could potentially use snap for this one, too.
sudo dnf install -y curl unzip
# Download and install the AWS CLI version 2
sudo dnf -y install awscli2.noarch
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip awscliv2.zip
# sudo ./aws/install
# Verify AWS CLI installation
aws --version
# Configure AWS CLI with dummy credentials
aws configure set aws_access_key_id test
aws configure set aws_secret_access_key test
aws configure set default.region us-east-1
aws configure set default.output json

# Install Docker Engine
# Install pre-requisites before install docker engine
sudo dnf install -y dnf-plugins-core
# Add official rpm repository
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

# Install necessary docker packages
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Start docker service
sudo systemctl enable docker --now
sudo systemctl start docker
# Run docker as non-privileged user
sudo usermod -aG docker $USER
newgrp docker