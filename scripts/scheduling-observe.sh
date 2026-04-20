#!/usr/bin/env bash

set -euo pipefail

namespace="${1:-apps}"

kubectl get pods -n "$namespace" -o wide || true