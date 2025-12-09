#!/bin/bash

# Kubernetes Studio Environment Test Script
# This script verifies that the Kubernetes environment is properly set up

set -e  # Exit on any error

echo "========================================="
echo "Kubernetes Studio Environment Test"
echo "========================================="

# Check if kubectl is installed
echo "1. Checking if kubectl is installed..."
if command -v kubectl &> /dev/null
then
    echo "   ✓ kubectl is installed"
    echo "   Version: $(kubectl version --client --short)"
else
    echo "   ✗ kubectl is not installed"
    exit 1
fi

# Check Kubernetes cluster connectivity
echo "2. Checking Kubernetes cluster connectivity..."
if kubectl cluster-info &> /dev/null
then
    echo "   ✓ Kubernetes cluster is accessible"
    echo "   Cluster info:"
    kubectl cluster-info | head -3
else
    echo "   ✗ Cannot connect to Kubernetes cluster"
    exit 1
fi

# Check nodes
echo "3. Checking cluster nodes..."
NODE_COUNT=$(kubectl get nodes --no-headers | wc -l)
if [ $NODE_COUNT -gt 0 ]
then
    echo "   ✓ Found $NODE_COUNT node(s) in the cluster"
    kubectl get nodes | head -5
else
    echo "   ✗ No nodes found in the cluster"
    exit 1
fi

# Check if metrics server is available
echo "4. Checking if metrics server is available..."
if kubectl top nodes &> /dev/null
then
    echo "   ✓ Metrics server is available"
else
    echo "   ⚠ Metrics server is not available (optional for learning)"
fi

# Check if helm is installed (optional)
echo "5. Checking if Helm is installed..."
if command -v helm &> /dev/null
then
    echo "   ✓ Helm is installed"
    echo "   Version: $(helm version --short 2>/dev/null || echo 'unknown')"
else
    echo "   ⚠ Helm is not installed (optional for advanced topics)"
fi

echo ""
echo "Environment test completed!"
echo "Your Kubernetes environment is ready for learning."
