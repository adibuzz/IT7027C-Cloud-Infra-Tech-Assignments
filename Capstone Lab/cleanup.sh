#!/bin/bash

# --- Cleaning terraform deployments

terraform destroy -auto-approve

# --- Stop all Containers

docker stop $(docker ps -q)

# --- Remove containers

docker rm ministack local-vault

# --- Remove all docker images

docker system prune -a

echo "Cleaning is done! Thank you."
