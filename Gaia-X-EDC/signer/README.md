# Helm Chart for Signer

This directory contains the Helm chart for deploying the Signer application to Kubernetes.

## Quick Start

```bash
# Install the chart
helm install signer . --namespace your-namespace

# Upgrade the chart
helm upgrade signer . --namespace your-namespace
```

## Chart Structure

```
charts/
├── Chart.yaml          # Chart metadata
├── values.yaml         # Default configuration values
└── templates/
    ├── deployment.yaml
    ├── hpa.yaml
    ├── ingress.yaml
    ├── service.yaml
    └── serviceAccount.yaml
```

## Configuration

The chart can be configured by modifying `values.yaml` or by providing custom values during installation.

Key configuration options:
- Application image and tag
- Service configuration
- Resource limits and requests
- Vault integration settings
- Ingress settings


## For Complete Deployment Instructions

**See [Deployment Guide](../documents/deployment-guide.md)** for:
- Prerequisites and dependencies
- Vault configuration
- Environment setup
- Step-by-step deployment process
- Verification and troubleshooting

## Chart Development

```bash
# Validate chart syntax
helm lint .

# Render templates locally
helm template . --debug

# Test installation (dry-run)
helm install --dry-run --debug signer .
```
