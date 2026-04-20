#!/usr/bin/env bash

set -euo pipefail

output_dir="${OUTPUT_DIR:-artifacts/cluster-snapshots/$(date +%Y%m%d-%H%M%S)}"
mkdir -p "$output_dir"

kubectl get pods -A -o wide > "$output_dir/pods.txt" || true
kubectl get events -A --sort-by=.lastTimestamp > "$output_dir/events.txt" || true
kubectl top pod -A > "$output_dir/top-pods.txt" || true
kubectl get virtualservice,destinationrule,peerauthentication -A > "$output_dir/mesh.txt" || true

echo "Saved cluster snapshot to $output_dir"
ls -1 "$output_dir"