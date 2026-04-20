#!/usr/bin/env bash

set -euo pipefail

namespace="${NAMESPACE:-apps}"
label_selector="${LABEL_SELECTOR:-app.kubernetes.io/name in (user-service,user-service-canary)}"

echo "== pods =="
kubectl get pods -n "$namespace" -l "$label_selector" -o wide

echo
echo "== restart counts =="
kubectl get pods -n "$namespace" -l "$label_selector" \
  -o custom-columns=NAME:.metadata.name,READY:.status.containerStatuses[*].ready,RESTARTS:.status.containerStatuses[*].restartCount,PHASE:.status.phase

echo
echo "== resource usage =="
kubectl top pod -n "$namespace" | grep -E 'user-service|user-service-canary' || true

echo
echo "== recent istio-proxy logs for canary =="
kubectl logs -l app.kubernetes.io/name=user-service-canary -n "$namespace" -c istio-proxy --tail=30 || true