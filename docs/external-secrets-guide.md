# External Secrets Guide

この資料は、外部 Secret Manager と Kubernetes の役割分担を理解する最小ガイドです。

## まず分けること

- Secret の原本をどこに置くか
- どう同期するか
- どう暗号化するか
- どう rotation するか

## 実務で学ぶこと

- Secret は保管、同期、利用の 3 段に分けて考えると整理しやすい