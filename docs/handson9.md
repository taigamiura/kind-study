# Handson 9

## テーマ

Grafana と監視の基礎を学ぶ。

## 今回のゴール

- Grafana と Prometheus の役割分担を説明できる
- 最初に見るべきメトリクスを理解できる
- 監視が運用にどう効くか説明できる

## 推奨構成

- Prometheus
- Grafana
- kube-state-metrics
- node-exporter
- postgres-exporter

## 目的

- 動いているかどうかだけでなく、どのように壊れているかを見る

## 実務上のメリット

- 障害の初動を早くできる
- 負荷やエラーの傾向を継続的に見られる
- 改善施策の効果を比較できる

## 最初に見るべき指標

- Pod restart count
- CPU 使用率
- Memory 使用率
- API latency
- API error rate
- PostgreSQL connections

## 理解すべきこと

- Grafana は可視化担当
- Prometheus は収集と保存担当
- exporter があるから各種メトリクスを取れる

## この回の宿題

- なぜログだけでは不十分なのか説明する
- 監視がないと障害対応で何が困るか整理する

次は [handson10.md](handson10.md) で GitOps と障害訓練に進みます。