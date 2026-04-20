# Handson 6

## テーマ

user-service と item-service を Kubernetes 上で動かす考え方を学ぶ。

## 今回のゴール

- Deployment と Service の基本責務を説明できる
- API を 2 つに分ける意味を理解できる
- readinessProbe と livenessProbe の役割を説明できる

## API の役割

- user-service: ユーザー登録、ユーザー取得
- item-service: 商品登録、商品一覧取得

## 推奨リソース

- Deployment
- Service
- ConfigMap
- Secret

## 目的

- stateless な API を小さく分けて運用する感覚を学ぶ

## 実務上のメリット

- 一部機能だけを更新できる
- 問題が起きたときに影響範囲を狭められる
- 負荷が高い API だけスケールしやすい

## 重要ポイント

- readinessProbe が失敗している Pod にトラフィックを送らない
- livenessProbe でハングを検知して再起動できる
- Service 名で user-service や item-service に到達できる

## 観察コマンド例

```bash
kubectl get deploy -n apps
kubectl get svc -n apps
kubectl describe pod -n apps
```

## この回の宿題

- なぜ API と DB を同じ Pod にしないのか説明する
- どちらか片方だけ replica を増やせるメリットを整理する

次は [handson7.md](handson7.md) で web-app を扱います。