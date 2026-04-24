# Handson 13

## テーマ

HPA で自動スケールを学ぶ。

## 今回のゴール

- HPA が何を見てスケールするか説明できる
- metrics-server が必要な理由を理解できる
- 手動スケールと自動スケールの違いを説明できる

## この回の前提

- `kubectl top` は Prometheus や Grafana ではなく metrics-server に依存する
- [handson9.md](handson9.md) で monitoring を入れていても、それだけでは `kubectl top` は動かない

ここを混同すると、`Metrics API not available` を monitoring 導入失敗だと誤解しやすいです。この回では、その誤解を解消することも重要な学習ポイントです。

## この回で先に押さえる用語

- HPA: metrics を見て Pod 数を自動調整する仕組み
- metrics-server: Kubernetes の基本 metrics を提供するコンポーネント
- Replica: 同じ Pod の複製数
- Scale Out: Pod 数を増やすこと

用語に迷ったら [glossary.md](glossary.md) の Metrics、Manifest を先に確認してください。

## 対応ファイル

- [manifests/extensions/hpa/user-service-hpa.yaml](../manifests/extensions/hpa/user-service-hpa.yaml)
- [manifests/extensions/hpa/item-service-hpa.yaml](../manifests/extensions/hpa/item-service-hpa.yaml)
- [manifests/helm/metrics-server-values.yaml](../manifests/helm/metrics-server-values.yaml)
- [scripts/install-metrics-server.sh](../scripts/install-metrics-server.sh)

## この回で実際にやること

1. metrics-server を Helm でインストールする
2. HPA manifest を apply する
3. HPA がどの Deployment を監視しているか確認する
4. CPU 指標が見える状態か確認する
5. HPA が増減させる対象と限界値を読み取る

手順の意味:

- 1 の前は `kubectl top` が失敗しても不自然ではない
- 1 の後に metrics-server Pod が起動してから `kubectl top` を試す
- そのあとで HPA の状態を読むと、依存関係が理解しやすい

## 実行コマンド例

```bash
bash scripts/install-metrics-server.sh
kubectl apply -k manifests/extensions/hpa
kubectl top pods -n apps
kubectl get hpa -n apps
kubectl describe hpa user-service -n apps
kubectl describe hpa item-service -n apps
```

各コマンドの目的:

- `bash scripts/install-metrics-server.sh`: Metrics API を提供する metrics-server を導入する
- `kubectl apply -k manifests/extensions/hpa`: HPA 定義を apps namespace に反映する
- `kubectl top pods -n apps`: CPU 指標が取得できているか確認する
- `kubectl get hpa -n apps`: HPA が作成されているか一覧で確認する
- `kubectl describe hpa user-service -n apps`: user-service の target や現在値を確認する
- `kubectl describe hpa item-service -n apps`: item-service の target や現在値を確認する

このコマンドで確認するのはここ:

- `kubectl top pods -n apps`: `CPU(cores)` と `MEMORY(bytes)` を見て、そもそも Metrics API から値が返るか確認する
- `kubectl get hpa -n apps`: `TARGETS` が `現在値 / 目標値` で出ているか、`REPLICAS` が min/max の範囲でどうなっているかを見る
- `kubectl describe hpa user-service -n apps`: `Metrics` で current/target、`Conditions` で `ScalingActive` と `AbleToScale`、`Events` で metrics 取得失敗履歴がないかを見る
- `kubectl describe hpa item-service -n apps`: user-service と同じく `Metrics`、`Conditions`、`Events` を見る

最初の 2 つの確認ポイント:

```bash
kubectl get pods -n kube-system | grep metrics-server
kubectl top pods -n apps
```

最初の 2 つの確認コマンドの目的:

- `kubectl get pods -n kube-system | grep metrics-server`: metrics-server Pod が起動済みか確認する
- `kubectl top pods -n apps`: HPA が参照する CPU 指標が取得できるか確認する

このコマンドで確認するのはここ:

- `kubectl get pods -n kube-system | grep metrics-server`: `Running` か、`RESTARTS` が増え続けていないかを見る
- `kubectl top pods -n apps`: エラーではなく数値が返るかを見る。ここが失敗するなら HPA の前提がまだ整っていない

ここで `kubectl top` が通って初めて、HPA が CPU 指標を参照できる前提が整ったと考えます。

## この回だけで押さえる整理

HPA では `CPU が高いから増える` という単純化で止まらず、requests、metrics-server、target 値、現在値、条件の関係まで見る必要があります。スケール判断がどの前提で成立するかを説明できれば、この回のゴールに届きます。

## 完了条件

- metrics-server が動作している
- apps namespace に HPA が作成されている
- `kubectl top pods -n apps` が通る
- minReplicas、maxReplicas、target CPU utilization を説明できる

## 実務で見る観点

- HPA の値を、アプリ都合だけでなく DB や外部依存の制約込みで決められるか
- 自動スケールの前提として requests が重要だと理解しているか

## よくある失敗

HPA では `設定を書いた` ことより `指標が取れている` ことの方が先です。metrics-server、requests、target の 3 つがそろって初めて意味が出るので、まず前提条件から確認するのが重要です。

- metrics-server 未導入のまま HPA を apply して動かない
- handson9 で Grafana を見られたので `kubectl top` も使えるはずだと誤解する
- requests 未設定や不適切設定で HPA 判断が不安定になる
- maxReplicas を大きくしただけで性能問題が解決すると考える

## 詰まったときの確認コマンド

```bash
kubectl get pods -n kube-system | grep metrics-server
kubectl top pods -n apps
kubectl get hpa -n apps
kubectl describe hpa user-service -n apps
kubectl describe deployment user-service -n apps
```

## 障害シナリオと復旧の考え方

想定シナリオ:

- HPA を入れたのに Pod 数が変わらない
- 自動スケールしたが、DB や外部依存が先に詰まる

復旧の考え方:

- metrics-server、requests、HPA target を順に確認する
- スケール対象以外のボトルネックがないか全体を見る

## レビュー観点と運用判断ポイント

- maxReplicas はシステム全体の制約を踏まえているか
- requests が HPA 判定前提として妥当か
- 自動化の挙動をチームが説明できるか

## 模擬インシデント演習

演習内容:

- HPA は動いて Pod が増えたが、レスポンスは改善せず DB 接続だけが増えて悪化した状況を想定する

考えること:

- ボトルネックが API Pod 数ではないとき、何を見るべきか
- HPA 設計と DB 制約をどう結びつけるか

## レビューコメント例

- 「HPA の target はありますが、requests の妥当性が見えないので自動スケールの前提が弱いです。」
- 「maxReplicas を大きくする前に DB や外部依存の制約も確認したいです。スケール先のボトルネックが見えていません。」

## 目的

- 負荷に応じて API Pod 数を自動調整する仕組みを理解する

## 実務上のメリット

- トラフィック増減に追従しやすい
- 無駄な常時スケールアウトを抑えやすい

## 学ぶポイント

- HPA は requests を基準に CPU 使用率を判断する
- metrics-server が無いと CPU 指標を取れない
- 反応速度と安定性のトレードオフがある

## 学ぶポイントの解説

HPA は「負荷が上がったら自動で Pod を増やす」仕組みですが、何を基準に増減するかを理解しないと、期待通りに動きません。Kubernetes では CPU 使用率の判定に requests が使われるため、requests を適当に入れているとスケール判断も不安定になります。自動化ほど、前提の設計が重要です。

metrics-server が必要なのは、HPA が Pod の CPU やメモリの情報を参照するためです。つまり HPA は単独では成立せず、観測基盤の一部に依存しています。この構造を理解しておくと、監視とスケーリングが別々の話ではないことが分かります。

また、自動スケールには反応速度と安定性のトレードオフがあります。早く反応させると増減が激しくなり、遅くすると負荷ピークに追いつけないかもしれません。実務では、HPA を入れること自体よりも、どのような挙動を期待するかを設計することが重要です。

## この回の宿題

- maxReplicas をどう決めるか考える
- HPA だけでなく VPA や Cluster Autoscaler が必要になる場面を整理する

## 宿題の考え方

maxReplicas を決めるときは、無限に増やせば安心という発想を避けてください。DB 接続数、外部 API の制約、コスト、Node 数の上限など、増やしても吸収できないボトルネックがあります。宿題では、アプリ単体ではなくシステム全体の制約を見て考えるのがポイントです。

HPA、VPA、Cluster Autoscaler の違いは、何を増やす仕組みなのかを軸に整理すると分かりやすいです。HPA は Pod 数、VPA は Pod サイズ、Cluster Autoscaler は Node 数を主に扱います。どのボトルネックに対処したいのかを意識すると、どれが必要か判断しやすくなります。

次は [handson14.md](handson14.md) で NetworkPolicy を学びます。