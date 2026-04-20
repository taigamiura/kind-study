#!/usr/bin/env bash

set -euo pipefail

namespace="${1:-apps}"

kubectl get resourcequota -n "$namespace" || true
echo
kubectl get limitrange -n "$namespace" || true
echo
kubectl describe resourcequota -n "$namespace" || true