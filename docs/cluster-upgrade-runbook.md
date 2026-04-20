# Cluster Upgrade Runbook

この runbook は cluster upgrade 前後に最低限確認する項目をまとめたものです。

## upgrade 前に見ること

- Node version
- addon 互換
- PDB と drain 可否
- deprecated API の有無

## 実務で学ぶこと

- cluster upgrade は workload deploy より広い影響を持つこと