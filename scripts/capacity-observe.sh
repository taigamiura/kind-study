#!/usr/bin/env bash

set -euo pipefail

namespace="${1:-apps}"

kubectl top pods -n "$namespace" || true
echo
kubectl top nodes || true
echo
kubectl get deploy -n "$namespace" -o yaml | grep -E 'name:|requests:|limits:' || true