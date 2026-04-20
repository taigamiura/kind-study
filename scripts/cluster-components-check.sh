#!/usr/bin/env bash

set -euo pipefail

kubectl get pods -n kube-system -o wide || true
echo
kubectl get componentstatuses 2>/dev/null || true