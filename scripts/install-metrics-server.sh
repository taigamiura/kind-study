#!/usr/bin/env bash

set -euo pipefail

helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update

helm upgrade --install metrics-server metrics-server/metrics-server \
  --namespace kube-system \
  -f manifests/helm/metrics-server-values.yaml