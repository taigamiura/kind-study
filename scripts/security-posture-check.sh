#!/usr/bin/env bash

set -euo pipefail

namespace="${1:-apps}"

kubectl get ns "$namespace" --show-labels || true
echo
kubectl get deploy -n "$namespace" -o yaml | grep -E 'runAsNonRoot|readOnlyRootFilesystem|allowPrivilegeEscalation' || true