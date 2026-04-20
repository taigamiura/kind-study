# Handson 9

## テーマ

Grafana と監視の基礎を学ぶ。

## 今回のゴール

- Grafana と Prometheus の役割分担を説明できる
- 最初に見るべきメトリクスを理解できる
- 監視が運用にどう効くか説明できる

## この回で先に押さえる用語

- Metrics: 数値で継続観測する情報
- Prometheus: metrics を収集、保存する基盤
- Grafana: metrics を可視化するツール
- ServiceMonitor: metrics 収集対象を定義する resource
- Observability: システム状態を見えるようにする考え方

用語に迷ったら [glossary.md](glossary.md) の Metrics、Prometheus、Grafana、ServiceMonitor を先に確認してください。

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

## 学ぶポイントの解説

監視は「問題が起きたらログを見る」だけでは不十分です。ログは個別の出来事を詳しく追うのに向いていますが、どのくらい遅くなっているか、再起動が増えているか、負荷が上がっているかといった傾向を見るにはメトリクスが必要です。この回では、システムの状態を数値で捉える考え方を学びます。

Prometheus と Grafana の役割を分けて理解することも重要です。Prometheus はデータを集めて保存し、Grafana はそれを見やすく可視化します。つまり、Grafana だけ入れても監視は成立しません。この分業を理解すると、監視基盤を構成要素ごとに捉えられるようになります。

また、何を計測するかは技術というより運用設計の問題です。CPU 使用率だけ見ても、利用者が遅いと感じている理由は分からないかもしれません。Pod 再起動回数、API レイテンシ、エラー率、DB 接続数などを組み合わせることで、初めて「どう壊れているか」を判断できるようになります。

実務では、監視はダッシュボードを見るためのものではなく、リリース判断を支えるためのものです。後半の handson18 では canary を昇格するか切り戻すかを決めますが、その判断材料はこの回で学ぶ metrics です。つまり、monitoring は変更を安全に進める前提条件です。

対応ファイル:

- [manifests/helm/kube-prometheus-stack-values.yaml](../manifests/helm/kube-prometheus-stack-values.yaml)
- [manifests/base/user-service/servicemonitor.yaml](../manifests/base/user-service/servicemonitor.yaml)
- [manifests/base/item-service/servicemonitor.yaml](../manifests/base/item-service/servicemonitor.yaml)
- [manifests/base/monitoring/postgres-exporter-deployment.yaml](../manifests/base/monitoring/postgres-exporter-deployment.yaml)
- [manifests/base/monitoring/postgres-exporter-servicemonitor.yaml](../manifests/base/monitoring/postgres-exporter-servicemonitor.yaml)
- [scripts/install-monitoring.sh](../scripts/install-monitoring.sh)
- [release-metrics.md](release-metrics.md)

## この回で実際にやること

1. kube-prometheus-stack を Helm でインストールする
2. postgres-exporter と ServiceMonitor を apply する
3. Prometheus が ServiceMonitor を拾える構成になっているか確認する
4. Grafana にアクセスできる状態を作る
5. 最初に見るべきメトリクスを一覧で言えるようにする
6. handson18 の canary 判断で何を見るかを整理する

## 実行コマンド例

```bash
bash scripts/install-monitoring.sh
kubectl apply -k manifests/base/monitoring
kubectl apply -f manifests/base/user-service/servicemonitor.yaml
kubectl apply -f manifests/base/item-service/servicemonitor.yaml
kubectl get pods -n observability
kubectl get servicemonitor -A
kubectl get ingress -n observability
kubectl top pod -n apps
```

## 完了条件

- observability namespace に監視系 Pod が起動している
- apps と observability に ServiceMonitor が作成されている
- Grafana の入口と、見るべき最初のメトリクスを説明できる
- canary 判断で最低限見る指標を [release-metrics.md](release-metrics.md) と結びつけて説明できる

## 実務で見る観点

- メトリクスを「集める」「保存する」「見る」に分けて説明できるか
- CPU や Memory だけでなく、SLO に近い指標を追う必要性を意識できるか

## よくある失敗

- Grafana に入れば監視できていると思い、Prometheus や ServiceMonitor の状態を見ない
- exporter は動いているが、Prometheus 側で scrape できていないことを見落とす
- ダッシュボードを見るだけで、異常時にどの指標から見るか決めていない

## 詰まったときの確認コマンド

```bash
kubectl get pods -n observability
kubectl get svc,ingress -n observability
kubectl get servicemonitor -A
kubectl describe servicemonitor user-service -n apps
kubectl describe servicemonitor postgres-exporter -n observability
kubectl logs -n observability -l app.kubernetes.io/name=postgres-exporter --tail=100
```

## 障害シナリオと復旧の考え方

想定シナリオ:

- Grafana は見えるが、見たいメトリクスが表示されない
- exporter は動いているのに Prometheus に取り込まれない
- 監視はあるが、どこから見始めるべきか分からない

復旧の考え方:

- 表示の問題か、収集の問題か、公開の問題かを分けて考える
- ServiceMonitor、Service、exporter Pod、Prometheus 対象選択を順に確認する
- まず restart、latency、error rate など影響が大きい指標から見る

## レビュー観点と運用判断ポイント

- 可視化対象は利用者影響と結びついているか
- exporter 追加時のラベルや ServiceMonitor 設計は一貫しているか
- ダッシュボードだけでなく、何を見て判断するかまで定義できているか

## 模擬インシデント演習

演習内容:

- Grafana は開くが、user-service のメトリクスが表示されない状況を想定する

考えること:

- ServiceMonitor、Service ラベル、Prometheus の対象選択のどこに問題があり得るか

## レビューコメント例

- 「Grafana 導入手順はありますが、Prometheus に取り込まれている確認が弱いので ServiceMonitor の確認をもう少し前面に出したいです。」
- 「CPU と Memory だけでなく、利用者影響に近い latency と error rate を最初の確認対象にしている点は実務的です。」

## この回の宿題

- なぜログだけでは不十分なのか説明する
- 監視がないと障害対応で何が困るか整理する

## 宿題の考え方

ログだけでは不十分な理由を考えるときは、時系列での変化や全体傾向を追えるかどうかに注目してください。たとえば、エラーが少しずつ増えている、レイテンシが毎日悪化している、といった兆候は、ログだけでは見落としやすいです。ログは掘るもの、メトリクスは見張るもの、と整理すると分かりやすくなります。

監視がないと困ることは、単に気づくのが遅れるだけではありません。障害の影響範囲が分からない、改善前後を比較できない、復旧したか判断できない、といった問題も起きます。宿題では、検知、切り分け、復旧確認の 3 段階で何が困るかを考えると整理しやすいです。

次に handson18 へ進むときは、[release-runbook.md](release-runbook.md) と [release-metrics.md](release-metrics.md) を一緒に読むと、Grafana や Prometheus を何のために見るのかがつながりやすくなります。

次は [handson10.md](handson10.md) で GitOps と障害訓練に進みます。