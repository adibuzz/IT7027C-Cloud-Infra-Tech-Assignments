#!/bin/bash
echo "Starting MiniStack via Docker..."
docker run -d -p 4566:4566 --name ministack_lab ministackorg/ministack:latest

echo "Waiting for LocalStack to initialize..."
sleep 10

echo "Initializing Terraform..."
terraform init

echo "Applying Infrastructure..."
terraform apply -auto-approve

echo "Validating Bucket Creation..."
aws --endpoint-url=http://localhost:4566 s3 ls | grep "module-13-pipeline-verification-bucket"

if [ $? -eq 0 ]; then
    echo "✅ Validation Successful: S3 Bucket exists in MiniStack."
else
    echo "❌ Validation Failed: S3 Bucket not found."
fi

echo "Cleaning up local environment..."
terraform destroy -auto-approve
docker stop ministack_lab && docker rm ministack_lab
