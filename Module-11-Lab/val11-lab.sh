#!/bin/bash

# --- Module 11 Validation Script ---
echo "Starting validation for module 11 lab..."

#1. Validate Docker Component (On-Prem)
echo "Checking Docker container (hybrid-redis)..."
if [ "$(docker inspect -f '{{.State.Running}}' hybrid_redis 2>/dev/null)" == "true" ]; then
echo "[PASS] Docker container 'hybrid_redis' is running"
else
echo "[Fail] Docker container 'hybrid_redis' is not running."
fi

echo "Checking Kubernetes Namespace (hybrid-cloud-ns). .."
if minikube kubectl get namespace hybrid-cloud-ns > /dev/null 2>&1; then
	echo "[PASS] Kubernetes namespace 'hybrid-cloud-ns' exists."
else
	echo "[FAIL] Kubernetes namespace 'hybrid-cloud-ns' not found."
fi

echo "Validation Complete. Thank you."
