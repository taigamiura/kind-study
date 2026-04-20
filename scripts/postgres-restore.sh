#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <dump-file>" >&2
  exit 1
fi

dump_file="$1"
namespace="${NAMESPACE:-infra}"
pod_name="${POSTGRES_POD:-postgres-0}"

if [[ ! -f "$dump_file" ]]; then
  echo "dump file not found: $dump_file" >&2
  exit 1
fi

cat "$dump_file" | kubectl exec -i -n "$namespace" "$pod_name" -- sh -c 'PGPASSWORD="$POSTGRES_PASSWORD" psql -U "$POSTGRES_USER" "$POSTGRES_DB"'

echo "Restore completed from $dump_file"