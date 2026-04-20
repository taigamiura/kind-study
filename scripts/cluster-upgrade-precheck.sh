#!/usr/bin/env bash

set -euo pipefail

echo "== nodes =="
kubectl get nodes -o wide || true
echo
echo "== pdb =="
kubectl get pdb -A || true
echo
echo "== non-ready pods =="
kubectl get pods -A --field-selector=status.phase!=Running || true