#!/bin/bash
echo "Bootstrapping Local Cloud Infrastructure..."

# 1. Start MiniStack (S3) & Vault in the background
docker run -d -p 4566:4566 --name ministack ministackorg/ministack
docker run -d --cap-add=IPC_LOCK -e 'VAULT_DEV_ROOT_TOKEN_ID=myroot' -p 8200:8200 --name local-vault hashicorp/vault

# 2. Wait for services to be healthy
sleep 5

# 3. Create the S3 State Bucket manually via CLI
AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test aws s3api create-bucket \
    --bucket capstone-state-bucket \
    --endpoint-url=http://localhost:4566 \
    --region us-east-1

# 4. Inject Vault Secrets
docker exec -e VAULT_ADDR='http://127.0.0.1:8200' -e VAULT_TOKEN='myroot' \
    local-vault vault kv put secret/capstone db_pass="SuperSecureP@ssw0rd!"

echo "Bootstrap complete. Environment ready for CI/CD Pipeline."
