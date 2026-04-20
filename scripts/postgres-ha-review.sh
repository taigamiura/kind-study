#!/usr/bin/env bash

set -euo pipefail

kubectl get statefulset -A || true
echo
kubectl get pvc -A | grep postgres || true
echo
kubectl get svc -A | grep postgres || true