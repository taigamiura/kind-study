#!/usr/bin/env bash

set -euo pipefail

namespace="${1:-apps}"

kubectl get secret -n "$namespace" || true
echo
kubectl get externalsecret -A 2>/dev/null || true