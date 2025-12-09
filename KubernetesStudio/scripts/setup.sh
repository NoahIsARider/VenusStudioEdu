#!/bin/bash

# Kubernetes Studio Setup Script
# This script helps set up a basic Kubernetes learning environment

set -e  # Exit on any error

echo "========================================="
echo "Kubernetes Studio Setup Script"
echo "========================================="

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null
then
    echo "Error: kubectl is not installed. Please install kubectl first."
    exit 1
fi

# Check if Kubernetes cluster is accessible
echo "Checking Kubernetes cluster connectivity..."
if ! kubectl cluster-info &> /dev/null
then
    echo "Error: Cannot connect to Kubernetes cluster. Please ensure your cluster is running."
    exit 1
fi

echo "Kubernetes cluster is accessible."

# Create a namespace for our examples
echo "Creating kubernetes-studio namespace..."
kubectl create namespace kubernetes-studio --dry-run=client -o yaml | kubectl apply -f -

echo "Setup completed successfully!"
echo ""
echo "Next steps:"
echo "1. Explore the examples in the examples/ directory"
echo "2. Deploy examples using: kubectl apply -f examples/<filename>.yaml"
echo "3. Check deployed resources: kubectl get all -n kubernetes-studio"
echo ""
echo "Happy learning!"
