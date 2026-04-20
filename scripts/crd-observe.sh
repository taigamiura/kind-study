#!/usr/bin/env bash

set -euo pipefail

kubectl get crd || true
echo
kubectl api-resources | grep -E 'argoproj|cert-manager|istio|external-secrets|example.com' || true