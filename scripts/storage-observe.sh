#!/usr/bin/env bash

set -euo pipefail

echo "== storageclass =="
kubectl get storageclass || true
echo
echo "== pvc =="
kubectl get pvc -A || true
echo
echo "== pv =="
kubectl get pv || true