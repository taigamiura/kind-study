# Container Linux Guide

この資料は、Kubernetes を理解する前提になる container と Linux の基礎を実務寄りに整理したものです。

## 最初に押さえること

- container は VM ではない
- Linux namespace と cgroup の上で動く
- PID 1 の挙動が signal 処理に影響する
- non-root と read-only filesystem は本番で重要である

## 実務で見る観点

- image が大きすぎないか
- shell 依存や root 依存がないか
- debug 性と攻撃面削減のバランスを取れているか