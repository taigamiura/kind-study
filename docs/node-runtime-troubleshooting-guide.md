# Node Runtime Troubleshooting Guide

この資料は、Pod 設定ではなく Node 側に原因がある障害を切り分けるための最小ガイドです。

## 主な観点

- OOM kill と eviction の違い
- memory、disk、inode pressure
- kubelet と runtime の責務差
- kernel 視点の確認項目