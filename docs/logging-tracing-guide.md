# Logging Tracing Guide

この資料は metrics、logs、traces をどう使い分けるかの最小ガイドです。

## 役割分担

- metrics: 異常検知
- logs: 事実確認
- traces: 依存関係の深掘り

## 実務で学ぶこと

- observability は 1 つの道具だけでは成立しないこと