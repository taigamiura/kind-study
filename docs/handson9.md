# Handson 9

## テーマ

Grafana と監視の基礎を学ぶ。

## 今回のゴール

- Grafana と Prometheus の役割分担を説明できる
- 最初に見るべきメトリクスを理解できる
- Grafana をブラウザで開き、dashboard 上で metrics を確認できる
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
- [grafana-canary-checklist.md](grafana-canary-checklist.md)
- [grafana-dashboard-guide.md](grafana-dashboard-guide.md)
- [release-decision-template.md](release-decision-template.md)
- [release-communication-template.md](release-communication-template.md)
- [release-followup-checklist.md](release-followup-checklist.md)
- [rollback-investigation-template.md](rollback-investigation-template.md)
- [preventive-action-template.md](preventive-action-template.md)
- [rerelease-readiness-checklist.md](rerelease-readiness-checklist.md)

## この回で実際にやること

1. kube-prometheus-stack を Helm でインストールする
2. postgres-exporter と ServiceMonitor を apply する
3. Prometheus が ServiceMonitor を拾える構成になっているか確認する
4. Grafana にアクセスできる状態を作る
5. ブラウザで Grafana を開き、login できることを確認する
6. Grafana で `apps` namespace の Pod 状態や CPU / Memory を確認する
7. PostgreSQL や exporter 系の metrics が見えることを確認する
8. 最初に見るべきメトリクスを一覧で言えるようにする
9. handson18 の canary 判断で何を見るかを整理する

## 実行コマンド例

```bash
bash scripts/install-monitoring.sh
kubectl apply -k manifests/base/monitoring
kubectl apply -f manifests/base/user-service/servicemonitor.yaml
kubectl apply -f manifests/base/item-service/servicemonitor.yaml
kubectl get pods -n observability
kubectl get servicemonitor -A
kubectl get ingress -n observability
```

ブラウザでは次を開きます。

```text
http://grafana.localtest.me
```

login 情報:

```text
user: admin
password: admin123
```

Grafana に入ったら、次の順で確認します。

1. Dashboards から `Kubernetes / Compute Resources / Namespace (Pods)` を開く
2. namespace filter を `apps` にする
3. `user-service` と `item-service` の Pod 数、CPU、Memory、restart を見る
4. 必要なら `Kubernetes / Compute Resources / Pod` を開き、Pod 単位で差を見る
5. `PostgreSQL` や `exporter` を含む dashboard を探し、postgres-exporter の metrics を見る

この順番にしている理由:

- 最初に namespace 単位で全体を見ると、`どこから深掘るべきか` を決めやすい
- 次に Pod 単位で見ると、`一部の Pod だけおかしいのか` を切り分けやすい
- 最後に PostgreSQL や exporter 系を見ると、`API の問題に見えて backend が原因` のケースを拾いやすい

Grafana は `全部の数字を覚えるための画面` ではありません。最初は次の 3 層で見られれば十分です。

1. namespace 全体の健康状態を見る
2. Pod 個別の偏りを見る
3. DB や exporter の backend 側を見る

最初に特に見る値:

- Pod 数
- CPU 使用量
- Memory 使用量
- restart 回数

この 4 つを見るだけでも、`落ちているのか`, `重いのか`, `一部だけ壊れているのか` をかなり早く切り分けられます。

画面上の数値変化を見たい場合は、別 terminal で API を数回叩きます。

```bash
for i in {1..20}; do curl -s http://localhost/api/users > /dev/null; curl -s http://localhost/api/items > /dev/null; done
```

`kubectl top` は metrics-server が必要なので、この回では必須ではありません。`Metrics API not available` が出ても、Grafana と Prometheus の確認ができていれば handson9 の失敗とは限りません。

## 完了条件

- observability namespace に監視系 Pod が起動している
- apps と observability に ServiceMonitor が作成されている
- Grafana を `http://grafana.localtest.me` で開ける
- Grafana に login し、`apps` namespace の Pod 状態や CPU / Memory を画面で確認できる
- postgres-exporter を含む監視対象が Grafana か Prometheus 上で見えていることを確認できる
- Grafana の入口と、見るべき最初のメトリクスを説明できる
- [grafana-dashboard-guide.md](grafana-dashboard-guide.md) を見ながら、最初に開く dashboard を 1 つ以上言える
- `namespace -> pod -> backend` の順で見る理由を説明できる
- handson18 で canary 判断に metrics がどうつながるかを説明できる

## 実務で見る観点

- メトリクスを「集める」「保存する」「見る」に分けて説明できるか
- CPU や Memory だけでなく、SLO に近い指標を追う必要性を意識できるか

## よくある失敗

- Grafana に入れば監視できていると思い、Prometheus や ServiceMonitor の状態を見ない
- exporter は動いているが、Prometheus 側で scrape できていないことを見落とす
- Grafana は開けたが、どの dashboard をどう絞るか分からず観測できない
- `kubectl top` が動かないことを monitoring 導入失敗だと誤解する
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

Grafana が開かない場合は、次も確認します。

```bash
kubectl get ingress -n observability
kubectl get svc -n observability
kubectl describe ingress kube-prometheus-stack-grafana -n observability
```

## 障害シナリオと復旧の考え方

想定シナリオ:

- Grafana は見えるが、見たいメトリクスが表示されない
- exporter は動いているのに Prometheus に取り込まれない
- Grafana には入れるが、dashboard のどこを見ればよいか分からない
- 監視はあるが、どこから見始めるべきか分からない

復旧の考え方:

- 表示の問題か、収集の問題か、公開の問題かを分けて考える
- ServiceMonitor、Service、exporter Pod、Prometheus 対象選択を順に確認する
- dashboard 名、namespace filter、panel 単位の見方を切り分ける
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

さらに実務寄りに進めるなら、[grafana-canary-checklist.md](grafana-canary-checklist.md) を見ながら「どのパネルを、どの順番で、何分見るか」を言えるようにしてください。

迷わず実画面を見たい場合は、[grafana-dashboard-guide.md](grafana-dashboard-guide.md) を見ながら dashboard 名と注目パネルを対応づけてください。

最終的な実務力としては、「見た」だけではなく「だから promote した / rollback した / hold した」を言語化できることが重要です。[release-decision-template.md](release-decision-template.md) を使って、判断根拠を短く記録する練習も入れてください。

さらにチーム運用まで含めるなら、その判断を他のメンバーへどう伝えるかも重要です。[release-communication-template.md](release-communication-template.md) を使って、開始、観測中、rollback、promote 完了の共有文も作れるようにしてください。

次は [handson10.md](handson10.md) で GitOps と障害訓練に進みます。