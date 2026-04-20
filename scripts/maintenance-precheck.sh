#!/usr/bin/env bash

set -euo pipefail

namespace="${1:-apps}"

echo "== pods =="
kubectl get pods -n "$namespace" -o wide || true
echo
echo "== pdb =="
kubectl get pdb -n "$namespace" || true
echo
echo "== nodes =="
kubectl get nodes || true