#!/usr/bin/env bash

set -euo pipefail

namespace="${NAMESPACE:-infra}"
pod_name="${POSTGRES_POD:-postgres-0}"
output_dir="${OUTPUT_DIR:-artifacts/postgres-backups}"
timestamp="$(date +%Y%m%d-%H%M%S)"
dump_file="$output_dir/postgres-$timestamp.sql"
latest_file="$output_dir/latest.sql"

mkdir -p "$output_dir"

kubectl exec -n "$namespace" "$pod_name" -- sh -c 'PGPASSWORD="$POSTGRES_PASSWORD" pg_dump -U "$POSTGRES_USER" "$POSTGRES_DB"' > "$dump_file"
cp "$dump_file" "$latest_file"

echo "Saved backup to $dump_file"
echo "Updated latest backup to $latest_file"