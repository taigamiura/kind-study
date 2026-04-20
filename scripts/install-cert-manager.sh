#!/usr/bin/env bash

set -euo pipefail

helm repo add jetstack https://charts.jetstack.io
helm repo update

helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  -f manifests/helm/cert-manager-values.yaml
