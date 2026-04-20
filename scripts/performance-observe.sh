#!/usr/bin/env bash

set -euo pipefail

namespace="${1:-apps}"

kubectl top pods -n "$namespace" || true
echo
kubectl describe deploy -n "$namespace" user-service || true