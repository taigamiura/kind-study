#!/usr/bin/env bash

set -euo pipefail

namespace="${NAMESPACE:-apps}"

echo "== postcheck pods =="
kubectl get pods -n "$namespace" -l 'app.kubernetes.io/name in (user-service,user-service-canary)' -o wide || true

echo
echo "== postcheck restarts =="
kubectl get pods -n "$namespace" -l 'app.kubernetes.io/name in (user-service,user-service-canary)' \
  -o custom-columns=NAME:.metadata.name,RESTARTS:.status.containerStatuses[*].restartCount,PHASE:.status.phase || true

echo
echo "== postcheck resources =="
kubectl top pod -n "$namespace" | grep -E 'user-service|user-service-canary' || true

echo
echo "== postcheck reminders =="
echo "1. promote 後なら 5-10 分の継続監視を行う"
echo "2. rollback 後なら 5xx 収束と stable 側安定化を確認する"
echo "3. hold 後なら再判断時刻を team へ共有する"