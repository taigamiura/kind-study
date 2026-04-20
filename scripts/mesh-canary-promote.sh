#!/usr/bin/env bash

set -euo pipefail

kubectl apply -f manifests/extensions/servicemesh-advanced/user-service-promote-canary-virtualservice.yaml

echo "Promoted canary routing to 100%."
