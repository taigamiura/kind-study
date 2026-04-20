# Quota Governance Guide

この資料は、shared cluster で ResourceQuota と LimitRange をどう使うかの最小ガイドです。

## 役割の違い

- LimitRange: container ごとの既定値や最小値をそろえる
- ResourceQuota: namespace 全体の使いすぎを防ぐ

## 設計の観点

- HPA と矛盾しない上限にする
- deploy が詰まりすぎないように余白を持たせる
- namespace の責務と予算に応じて差をつける