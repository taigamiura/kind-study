# Policy As Code Guide

この資料は、レビューだけで守れない安全基準を自動化するための最小ガイドです。

## 代表例

- requests / limits 必須
- privileged 禁止
- latest tag 禁止
- non-root 必須

## 実務で学ぶこと

- rule だけでなく例外申請と期限管理が必要である