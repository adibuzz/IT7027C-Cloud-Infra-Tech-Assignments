# Install Microsoft VS Code
#!/bin/bash

# Add official rpm repository (published by Microsoft)
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

# Install using dnf directly
dnf update -y &&
sudo dnf install code

# Install pre-requisites before install docker enginer
sudo dnf install -y dnf-plugins-core
# Add official rpm repository
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

# Install necessary docker packages
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# Run docker as non-previliged user
sudo usermod -aG docker $USER
newgrp docker
sudo systemctl restart docker

# Verify Successful Docker Installation
docker run hello-world


# Install Terraform
#sudo yum install -y yum-utils

sudo dnf install -y dnf-utils

#sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo dnf -y install terraform

#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


# Aws-ClI install
sudo dnf install -y curl unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
# Verify AWS CLI installation
aws --version

aws configure
#test
#test
#us-east-1


# Install git
sudo dnf install git-core -y

# Install GitHub CLI
sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
sudo dnf install gh -y
