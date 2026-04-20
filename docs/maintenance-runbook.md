# Maintenance Runbook

この runbook は node drain や planned maintenance の前に確認する最小手順です。

## 実施前チェック

- PDB があるか
- replica 数に余裕があるか
- readiness が正常か
- 高負荷時間帯でないか

## 実務で学ぶこと

- maintenance は障害でなくても可用性設計が必要なこと