#!/usr/bin/env bash

set -euo pipefail

namespace="${1:-apps}"

echo "== pods =="
kubectl get pods -n "$namespace" || true
echo
echo "== recent logs: user-service =="
kubectl logs -n "$namespace" -l app.kubernetes.io/name=user-service --tail=50 || true
echo
echo "== recent logs: item-service =="
kubectl logs -n "$namespace" -l app.kubernetes.io/name=item-service --tail=50 || true