# Performance Tuning Guide

この資料は、Kubernetes 上の性能問題をどう切り分けるかの最小ガイドです。

## 基本の流れ

- metrics で異常検知
- logs / traces で文脈確認
- top / profiling で律速確認
- load test で再現と改善確認

## 実務で学ぶこと

- 平均値だけでなく tail latency と throttling を見る