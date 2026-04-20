# Authentication Audit Guide

この資料は、本番 Kubernetes で誰として入り、何を記録するかを整理する最小ガイドです。

## 基本の分け方

- Authentication: 誰かを確かめる
- Authorization: 何ができるか決める
- Audit: 実際に何をしたか残す

## 実務で学ぶこと

- 個人、CI、bot、GitOps controller は分けて運用する