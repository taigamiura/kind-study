#!/usr/bin/env bash

set -euo pipefail

iterations="${1:-30}"

echo "== smoke test =="
bash scripts/mesh-canary-smoke-test.sh "$iterations"

echo
echo "== kubectl observe =="
bash scripts/mesh-release-observe.sh

echo
echo "== next checks =="
echo "1. docs/release-metrics.md を開き、CPU/Memory/restart の比較観点を確認する"
echo "2. docs/grafana-canary-checklist.md を開き、Grafana での確認順序に沿って見る"
echo "3. 異常があれば bash scripts/mesh-canary-rollback.sh を実行する"
echo "4. 問題がなければ bash scripts/mesh-canary-promote.sh を実行する"