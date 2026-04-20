#!/usr/bin/env bash

set -euo pipefail

namespace="${1:-apps}"

kubectl get deploy -n "$namespace" -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{range .spec.template.spec.containers[*]}{.image}{"\n"}{end}{end}' || true