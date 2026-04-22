# Handson 72

## テーマ

Node、runtime、eviction、OOM の深掘りを学ぶ。

## 今回のゴール

- OOM kill、eviction、node pressure の違いを説明できる
- Node 障害時に Pod 設定だけでなく OS / runtime 側も疑える
- disk、inode、memory 圧迫の観点を持てる

## この回で先に押さえる用語

- OOM kill
- eviction
- node pressure
- inode exhaustion
- container runtime

## 対応ファイル

- [node-runtime-troubleshooting-guide.md](node-runtime-troubleshooting-guide.md)

## この回で実際にやること

1. [node-runtime-troubleshooting-guide.md](node-runtime-troubleshooting-guide.md) を読む
2. OOM と eviction の違いを表で整理する
3. `Pod 再起動`, `Pending`, `Evicted`, `DiskPressure` の切り分け順を決める
4. application、kubelet、kernel のどこを見るか整理する

## 確認するとしたらどこを見るか

- Node 問題では Pod 設定だけでなく OOM kill、eviction、disk pressure、inode 枯渇のどれかを見る
- `Pod が落ちた` を container 側だけの問題だと決めつけていないか確認する

## 完了条件

- OOM kill と eviction の違いを説明できる
- node pressure の主要パターンを説明できる
- Node 側調査の入口を説明できる

## 実務で見る観点

- Pod 設定だけ見て Node 原因を見落としていないか
- disk 容量だけでなく inode 枯渇を意識できるか
- kubelet / runtime / kernel の責務差を理解しているか


## 詰まったときの確認ポイント

- OOMKilled と Evicted を分けて説明できるか
- DiskPressure の原因が容量だけとは限らないと理解しているか
- kubelet と kernel のどちらを疑うか整理できているか

## この回の後に必ずやること

1. Node 障害時の調査順を時系列で書く
2. memory、disk、inode の圧迫パターンを整理する
3. [node-runtime-troubleshooting-guide.md](node-runtime-troubleshooting-guide.md) を見て Node 観点の不足を確認する

## この回の宿題

- Evicted と OOMKilled の違いを書く
- Node 調査で最初に見る項目を列挙する

## 学ぶポイント

- 実務では Node 側要因の障害を見抜けるかで調査速度が大きく変わる
- OOM kill と eviction は似て見えて対応方針が違う
- disk と inode、kubelet と kernel の切り分けができると強い

## 学ぶポイントの解説

Pod が落ちているからといって、原因が Deployment やアプリにあるとは限りません。Node 圧迫や runtime 側の不調、disk や inode 枯渇のような基盤問題は、manifest を見ているだけでは見抜きにくいです。

ここを学ぶと、`Kubernetes が悪い` とまとめてしまう雑な切り分けから抜けられます。これは実務で非常に差が出るポイントです。

次は [handson73.md](handson73.md) で監査とデータ保護を学びます。