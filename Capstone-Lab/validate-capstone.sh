#!/bin/bash

# --- Capstone Validation Script ---
echo "Starting validation for Capstone lab deployment..."
echo "--------------------------------------------------"

# 1. Validate Load Balancer Container (HAProxy)
echo "Checking Docker container (capstone_lb)..."
if [ "$(docker inspect -f '{{.State.Running}}' capstone_lb 2>/dev/null)" == "true" ]; then
    echo "[PASS] Docker container 'capstone_lb' is running."
else
    echo "[FAIL] Docker container 'capstone_lb' is not running."
    exit 1
fi

# 2. Validate Dynamic Web Containers (Nginx)
echo -e "\nChecking dynamic Nginx backend containers..."
# Filters for any container running the specific Nginx image used in the capstone
BACKENDS=$(docker ps -q --filter "ancestor=nginxdemos/hello:latest")

if [ -n "$BACKENDS" ]; then
    # Count the number of running backends dynamically
    COUNT=$(echo "$BACKENDS" | wc -w)
    echo "[PASS] Found $COUNT Nginx backend container(s) successfully running."
else
    echo "[FAIL] No Nginx backend containers are currently running."
    exit 1
fi

# 3. Validate Network Routing & Load Balancing
echo -e "\nTesting HAProxy routing response on port 80..."
# Silently ping localhost:8800 and extract only the HTTP status code
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8800)

if [ "$HTTP_STATUS" == "200" ]; then
    echo "[PASS] Load balancer is successfully routing HTTP traffic (Status: 200 OK)."
else
    echo "[FAIL] Load balancer failed to route traffic. Returned HTTP status: $HTTP_STATUS"
    exit 1
fi

echo "--------------------------------------------------"
echo "Capstone deployment validation complete: ALL CHECKS PASSED."
exit 0
