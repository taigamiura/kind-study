#!/usr/bin/env bash

set -euo pipefail

iterations="${1:-30}"
namespace="${NAMESPACE:-apps}"
sleep_target="${SLEEP_TARGET:-deploy/sleep}"
service_url="${SERVICE_URL:-http://user-service:9898/env}"
canary_message="${CANARY_MESSAGE:-user-service canary is running}"

if ! [[ "$iterations" =~ ^[0-9]+$ ]]; then
  echo "iterations must be an integer" >&2
  exit 1
fi

canary_hits=0
stable_hits=0

for _ in $(seq 1 "$iterations"); do
  response="$(kubectl exec -n "$namespace" "$sleep_target" -c sleep -- curl -fsS "$service_url")"
  if grep -q "$canary_message" <<<"$response"; then
    canary_hits=$((canary_hits + 1))
  else
    stable_hits=$((stable_hits + 1))
  fi
done

echo "namespace: $namespace"
echo "iterations: $iterations"
echo "canary_hits: $canary_hits"
echo "stable_hits: $stable_hits"
echo "canary_ratio_percent: $((canary_hits * 100 / iterations))"
