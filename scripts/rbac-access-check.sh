#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 4 ]]; then
  echo "usage: $0 <namespace> <serviceaccount> <verb> <resource>" >&2
  exit 1
fi

namespace="$1"
serviceaccount="$2"
verb="$3"
resource="$4"

kubectl auth can-i "$verb" "$resource" \
  --as="system:serviceaccount:${namespace}:${serviceaccount}" \
  -n "$namespace"