# Handson 21

## テーマ

SLO、Alert、運用閾値の作り方を学ぶ。

## 今回のゴール

- 監視を `見るもの` から `判断の基準` へ進められる
- レイテンシ、エラー率、可用性に対して最小の SLO を置ける
- Alert を増やすより、意味のある閾値を絞る発想を持てる

## この回の前提

- `kubectl top` を使うなら [handson13.md](handson13.md) の metrics-server 導入まで終わっている
- まだ metrics-server を入れていない場合は、Grafana や Pod 状態確認を主に使って考えてよい

この回の本質は `CPU 数値を取ること` ではなく、`何を Alert にし、何を dashboard 観測に留めるか` を考えることです。

## この回で先に押さえる用語

- SLI: 測りたい指標
- SLO: 守る目標値
- Error Budget: 許容できる失敗の余地
- Alert: すぐ人が対応すべき通知
- Noise: 多すぎて価値が下がる通知

## 対応ファイル

- [slo-alert-template.md](slo-alert-template.md)
- [release-metrics.md](release-metrics.md)
- [grafana-canary-checklist.md](grafana-canary-checklist.md)
- [grafana-dashboard-guide.md](grafana-dashboard-guide.md)

## この回で実際にやること

1. user-service で `成功率`, `レイテンシ`, `再起動` の 3 つを候補にする
2. [slo-alert-template.md](slo-alert-template.md) を埋める
3. `誰が起きるべき Alert か` を基準に通知条件を絞る
4. `Dashboard で見る値` と `Pager を鳴らす値` を分ける

## 実行コマンド例

```bash
kubectl top pod -n apps
kubectl get pods -n apps
kubectl get events -A --sort-by=.lastTimestamp | tail -n 20
```

`kubectl top` が `Metrics API not available` になる場合は、metrics-server 未導入の可能性が高いです。その場合はこの回の失敗ではなく前提不足なので、[handson13.md](handson13.md) を先に完了するか、Grafana と `kubectl get pods` を使って判断練習を進めてください。

## 完了条件

- 1 つ以上の SLO を文章で書ける
- `可視化用メトリクス` と `Alert 用メトリクス` を分けて説明できる
- 監視対象を増やすより、重要な失敗条件を絞る説明ができる

## 実務で見る観点

- Alert が多すぎて無視される状態になっていないか
- Error Budget を使って変更速度と安定性のバランスを取れているか
- SLO が利用者影響に近い指標で作られているか

## よくある失敗

- CPU 高騰を全部 Alert にしてしまう
- 成功率やレイテンシよりインフラ内部値ばかり見てしまう
- しきい値の根拠がなく、誰も納得していない

## 学ぶポイント

- 監視は `たくさん取る` より `判断に使える形にする` 方が重要である
- SLO は利用者影響に近い指標から置くとぶれにくい
- Alert は人を起こす価値があるものに絞るべきである

## 学ぶポイントの解説

Grafana を見られるだけでは、実務ではまだ弱いです。重要なのは、`ここを超えたら危険`, `ここなら様子見`, `ここは Pager を鳴らす` と判断を分けられることです。SLO はその基準をチームで共有するための最小単位です。

Alert も同様で、すべてを通知すると運用が壊れます。まずは user-service の成功率、レイテンシ、再起動回数のような、利用者影響につながるものから優先順位を付けます。

## この回の宿題

- user-service に対して `絶対に落としてはいけない時間帯` を仮定して SLO を 1 つ作る
- `通知するが即対応は不要`, `即対応が必要` の境界を 1 つ定義する

次は [handson22.md](handson22.md) で障害初動とポストモーテムを学びます。