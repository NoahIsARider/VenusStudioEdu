#!/bin/bash

# Kubernetes Studio Cleanup Script
# This script helps clean up resources created during learning

set -e  # Exit on any error

echo "========================================="
echo "Kubernetes Studio Cleanup Script"
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

# Delete all resources in the kubernetes-studio namespace
echo "Deleting all resources in kubernetes-studio namespace..."
kubectl delete all --all -n kubernetes-studio

# Delete the namespace itself
echo "Deleting kubernetes-studio namespace..."
kubectl delete namespace kubernetes-studio

echo "Cleanup completed successfully!"
echo ""
echo "All resources created during the Kubernetes Studio exercises have been removed."
