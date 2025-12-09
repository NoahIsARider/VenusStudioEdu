# Kubernetes Studio Scripts

This directory contains helper scripts to set up, test, and clean up your Kubernetes learning environment.

## Scripts Overview

### setup.sh
Sets up the Kubernetes learning environment:
- Verifies kubectl installation and cluster connectivity
- Creates a dedicated namespace for examples

Usage:
```bash
./setup.sh
```

### test-environment.sh
Verifies that your Kubernetes environment is properly configured:
- Checks kubectl installation
- Verifies cluster connectivity
- Lists cluster nodes
- Checks for optional components (metrics server, Helm)

Usage:
```bash
./test-environment.sh
```

### cleanup.sh
Removes all resources created during learning:
- Deletes all resources in the kubernetes-studio namespace
- Removes the namespace itself

Usage:
```bash
./cleanup.sh
```

## Running the Scripts

Make sure the scripts have execute permissions:
```bash
chmod +x *.sh
```

Then run any script with:
```bash
./script-name.sh
```

## Safety Notes

- These scripts are designed for learning environments only
- The cleanup script will remove all resources in the kubernetes-studio namespace
- Always review scripts before running them in production environments
