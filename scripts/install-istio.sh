#!/usr/bin/env bash

set -euo pipefail

helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

helm upgrade --install istio-base istio/base \
  --namespace istio-system \
  --create-namespace \
  -f manifests/helm/istio-base-values.yaml

helm upgrade --install istiod istio/istiod \
  --namespace istio-system \
  -f manifests/helm/istiod-values.yaml
