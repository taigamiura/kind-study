# Kubernetes Internals Guide

この資料は、kubectl apply から Pod 実行までの control plane の流れを追うための最小ガイドです。

## 主な役割

- apiserver: 入口
- etcd: 状態保存
- scheduler: Node 選択
- controller-manager: desired state の維持
- kubelet: Node 上の実行担当

## 実務で学ぶこと

- 症状が出たレイヤと壊れているレイヤは同じとは限らない