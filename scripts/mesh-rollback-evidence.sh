#!/usr/bin/env bash

set -euo pipefail

namespace="${NAMESPACE:-apps}"
output_dir="${OUTPUT_DIR:-artifacts/mesh-rollback/$(date +%Y%m%d-%H%M%S)}"

mkdir -p "$output_dir"

echo "Saving rollback evidence to $output_dir"

kubectl get pods -n "$namespace" -o wide > "$output_dir/pods.txt" || true
kubectl get pods -n "$namespace" \
  -o custom-columns=NAME:.metadata.name,RESTARTS:.status.containerStatuses[*].restartCount,PHASE:.status.phase > "$output_dir/restarts.txt" || true
kubectl top pod -n "$namespace" > "$output_dir/top-pods.txt" || true
kubectl get virtualservice -n "$namespace" -o yaml > "$output_dir/virtualservices.yaml" || true
kubectl get peerauthentication -n "$namespace" -o yaml > "$output_dir/peerauthentication.yaml" || true
kubectl logs -l app.kubernetes.io/name=user-service-canary -n "$namespace" -c istio-proxy --tail=200 > "$output_dir/user-service-canary-istio-proxy.log" || true
kubectl logs -l app.kubernetes.io/name=user-service -n "$namespace" -c istio-proxy --tail=200 > "$output_dir/user-service-istio-proxy.log" || true

echo "Saved files:"
ls -1 "$output_dir"

echo
echo "Next: summarize the evidence in docs/rollback-investigation-template.md"