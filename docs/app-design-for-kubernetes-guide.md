# App Design For Kubernetes Guide

この資料は、Kubernetes 上で壊れにくく動くアプリ実装の最小ガイドです。

## 主な論点

- graceful shutdown
- readiness と connection draining
- idempotency
- backward compatible schema change
- retry と二重実行対策