#!/usr/bin/env bash

set -euo pipefail

namespace="${1:-apps}"

kubectl get deploy -n "$namespace" -o yaml | grep -E 'image:|requests:|limits:|runAsNonRoot|allowPrivilegeEscalation' || true