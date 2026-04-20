#!/usr/bin/env bash

set -euo pipefail

namespace="${NAMESPACE:-apps}"

kubectl get certificate -n "$namespace" || true
echo
kubectl describe certificate apps-local-tls -n "$namespace" || true