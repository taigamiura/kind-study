# Storage Operations Guide

この資料は PVC、StorageClass、snapshot、論理 backup の違いを整理する最小ガイドです。

## 役割の違い

- PVC: 継続利用するストレージ
- StorageClass: ストレージの種類
- VolumeSnapshot: ある時点の切り出し
- backup / restore: 論理的な復旧手段

## 実務で学ぶこと

- stateful 運用は保存と復旧を別々に考える必要があること