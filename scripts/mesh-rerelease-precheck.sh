#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
namespace="${NAMESPACE:-apps}"

echo "== re-release precheck =="

if [[ -x "$script_dir/mesh-release-preflight.sh" ]]; then
  "$script_dir/mesh-release-preflight.sh"
else
  echo "mesh-release-preflight.sh not found or not executable"
fi

echo
echo "== current routing =="
kubectl get virtualservice -n "$namespace" || true

echo
echo "== app pods =="
kubectl get pods -n "$namespace" -l 'app.kubernetes.io/name in (user-service,user-service-canary)' -o wide || true

echo
echo "== restart summary =="
kubectl get pods -n "$namespace" -l 'app.kubernetes.io/name in (user-service,user-service-canary)' \
  -o custom-columns=NAME:.metadata.name,RESTARTS:.status.containerStatuses[*].restartCount,PHASE:.status.phase || true

echo
echo "== re-release reminders =="
echo "1. preventive-action-template.md の 再リリース前に必須な対策 が完了しているか確認する"
echo "2. 前回の rollback 条件を今回の team 共有文へ反映する"
echo "3. 観測時間と Hold 条件を前回より具体化する"