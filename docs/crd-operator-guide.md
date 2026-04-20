# CRD Operator Guide

この資料は、CRD と controller の基本を理解するための最小ガイドです。

## 主な考え方

- CRD は Kubernetes API の拡張
- Operator は独自 resource を運用する controller
- reconcile は実状態を desired state へ近づける反復処理

## 実務で学ぶこと

- add-on の多くは CRD と controller の組み合わせで動く