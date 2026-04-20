#!/usr/bin/env bash

set -euo pipefail

kubectl config current-context || true
echo
kubectl auth can-i get pods -n apps || true
echo
kubectl auth can-i patch deployments -n apps || true