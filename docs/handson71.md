# Handson 71

## テーマ

Kubernetes 前提のアプリ実装規約を学ぶ。

## 今回のゴール

- graceful shutdown、readiness、idempotency、connection draining の重要性を説明できる
- schema change と rollout の整合を説明できる
- platform 側設定だけでは救えないアプリ実装論点を理解する

## この回で先に押さえる用語

- graceful shutdown
- idempotency
- connection draining
- backward compatible change
- feature flag

## 対応ファイル

- [app-design-for-kubernetes-guide.md](app-design-for-kubernetes-guide.md)

## この回で実際にやること

1. [app-design-for-kubernetes-guide.md](app-design-for-kubernetes-guide.md) を読む
2. readiness / liveness と graceful shutdown の関係を整理する
3. rollout と schema migration の安全条件を書く
4. `再実行しても壊れにくい API` の条件を言語化する

## 完了条件

- graceful shutdown の必要性を説明できる
- backward compatible change の意味を説明できる
- idempotency が重要な場面を説明できる

## 実務で見る観点

- Pod 停止時にリクエストを壊していないか
- migration が新旧共存を壊していないか
- retry で二重処理が起きないか


## 詰まったときの確認ポイント

- readiness が通っていることと安全に停止できることを混同していないか
- schema change が新旧共存を壊さないか
- retry 時の idempotency を設計できているか

## この回の後に必ずやること

1. graceful shutdown を壊す実装例を 3 つ書く
2. backward compatible でない変更を洗い出す
3. [app-design-for-kubernetes-guide.md](app-design-for-kubernetes-guide.md) を見てアプリ実装側の不足を確認する

## この回の宿題

- readiness が通っていても安全ではない例を書く
- 互換性を壊す schema change の例を挙げる

## 学ぶポイント

- Kubernetes 運用の安全性はアプリ実装に強く依存する
- readiness や rollout はアプリが前提を守って初めて機能する
- retry 前提の世界では idempotency が運用品質を左右する

## 学ぶポイントの解説

運用側でどれだけ readiness や rollout を整えても、アプリが graceful shutdown できなければ停止時に取りこぼしが出ます。schema change も同様で、新旧共存を壊す変更は canary や rollback を難しくします。

そのため実務では、Kubernetes の知識だけでなく、Kubernetes で壊れにくいアプリをどう書くかまで理解している人の方が強いです。

次は [handson72.md](handson72.md) で node 深掘りを学びます。