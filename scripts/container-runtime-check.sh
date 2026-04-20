#!/usr/bin/env bash

set -euo pipefail

namespace="${1:-apps}"

kubectl get pods -n "$namespace" -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{range .spec.containers[*]}{.name}{":"}{.image}{"\t"}{.securityContext.runAsNonRoot}{"\n"}{end}{end}' || true