#!/usr/bin/env bash

set -euo pipefail

kubectl apply -f manifests/extensions/servicemesh-advanced/user-service-stable-only-virtualservice.yaml

echo "Rolled back canary routing to stable 100%."
