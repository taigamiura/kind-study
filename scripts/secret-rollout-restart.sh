#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: $0 <namespace> <deployment> [deployment...]" >&2
  exit 1
fi

namespace="$1"
shift

for deployment in "$@"; do
  kubectl rollout restart "deployment/$deployment" -n "$namespace"
  kubectl rollout status "deployment/$deployment" -n "$namespace"
done