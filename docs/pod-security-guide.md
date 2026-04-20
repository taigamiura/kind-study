# Pod Security Guide

この資料は Pod Security Standards と securityContext を restricted 寄りに考えるための最小ガイドです。

## 最低限見る項目

- runAsNonRoot
- readOnlyRootFilesystem
- allowPrivilegeEscalation: false
- capabilities drop

## 実務で学ぶこと

- 本番運用では `動く` だけでなく `安全に動く` が必要なこと