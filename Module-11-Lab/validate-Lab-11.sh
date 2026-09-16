#!/bin/bash

set -u

failures=0

pass() {
	echo "[PASS] $1"
}

fail() {
	echo "[FAIL] $1"
	failures=$((failures + 1))
}

# --- Module 11 Validation Script ---
echo "Starting validation for module 11 lab..."

# Check that the Kubernetes cluster is available before querying resources.
echo "Checking Minikube status..."
if minikube status --output=json 2>/dev/null | grep -q '"Host":"Running"'; then
	pass "Minikube is running"
else
	fail "Minikube is not running"
fi

echo "Checking Kubernetes context..."
if minikube kubectl config current-context 2>/dev/null | grep -qx "minikube"; then
	pass "Kubernetes context is 'minikube'"
else
	fail "Kubernetes context is not 'minikube'"
fi

#1. Validate Docker Component (On-Prem)
echo "Checking Docker container (hybrid-redis)..."
if [ "$(docker inspect -f '{{.State.Running}}' hybrid_redis 2>/dev/null)" == "true" ]; then
pass "Docker container 'hybrid_redis' is running"
else
fail "Docker container 'hybrid_redis' is not running"
fi

echo "Checking Kubernetes namespace (hybrid-cloud-ns)..."
if minikube kubectl get namespace hybrid-cloud-ns > /dev/null 2>&1; then
	pass "Kubernetes namespace 'hybrid-cloud-ns' exists"
else
	fail "Kubernetes namespace 'hybrid-cloud-ns' not found"
fi

if [ "$failures" -eq 0 ]; then
	echo "Validation complete: all tests passed."
else
	echo "Validation complete: $failures test(s) failed."
	exit 1
fi
