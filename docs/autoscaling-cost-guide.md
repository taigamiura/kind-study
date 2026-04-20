# Autoscaling Cost Guide

この資料は HPA、VPA、Cluster Autoscaler と cost 設計の関係を整理する最小ガイドです。

## 見るべき軸

- Pod を増やすか
- requests を見直すか
- Node を増やすか
- 余裕をどれだけ残すか

## 実務で学ぶこと

- 可用性とコストは同時に最適化する必要がある