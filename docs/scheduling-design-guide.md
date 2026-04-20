# Scheduling Design Guide

この資料は、Pod を `置ける` から `適切に置く` へ進むための最小ガイドです。

## 使い分け

- nodeSelector: 単純な固定条件
- affinity: 寄せたい
- anti-affinity: 離したい
- topology spread: 偏りすぎを防ぎたい

## 実務で学ぶこと

- replica 数だけでは可用性は決まらないこと