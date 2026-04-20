#!/usr/bin/env bash

set -euo pipefail

namespace="${NAMESPACE:-apps}"

echo "== namespace labels =="
kubectl get ns "$namespace" --show-labels

echo
echo "== required pods =="
kubectl get pods -n "$namespace" -l 'app.kubernetes.io/name in (user-service,item-service,web-app,user-service-canary)' || true

echo
echo "== sleep pod =="
kubectl get pods -n "$namespace" -l app=sleep || true

echo
echo "== peer authentication =="
kubectl get peerauthentication -n "$namespace" || true

echo
echo "== virtual services =="
kubectl get virtualservice -n "$namespace" || true

echo
echo "== service monitors =="
kubectl get servicemonitor -A || true

echo
echo "== preflight reminders =="
echo "1. apps namespace に sidecar 注入ラベルがあるか確認する"
echo "2. user-service / user-service-canary / sleep が起動しているか確認する"
echo "3. PeerAuthentication と VirtualService が意図した状態か確認する"
echo "4. 監視対象が ServiceMonitor で拾われる構成か確認する"