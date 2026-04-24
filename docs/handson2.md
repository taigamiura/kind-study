# Handson 2

## テーマ

kind クラスタと Node の役割を理解する。

## 今回のゴール

- control plane と worker の違いを説明できる
- Pod が Node にどう配置されるか観察できる
- 1 台構成ではなく複数 Node を使う意味を理解する

## この回で先に押さえる用語

- Cluster: Kubernetes 全体の実行環境
- Node: Pod が動く実行基盤
- Pod: コンテナを実行する最小単位
- Control Plane: クラスタ全体を管理する側
- Worker: 実際に Pod を動かす側

用語に迷ったら [glossary.md](glossary.md) の Cluster、Node、Pod を先に確認してください。

## 事前確認

クラスタ設定は [kind-study.yaml](../kind-study.yaml) です。

Node 構成:

- control plane 1 台
- worker 3 台

## やること

```bash
kubectl get nodes -o wide
kubectl get pods -A -o wide
kubectl describe node study-k8s-worker
```

## この回だけで押さえる整理

この回では、Kubernetes を `1 台の Docker ホスト` と見ないことが最重要です。control plane と worker の役割差、Pod が Node に載ること、Node 障害がその上の Pod へ波及することを説明できれば、この回のゴールに届きます。

このコマンドで確認するのはここ:

- `kubectl get nodes -o wide`: `ROLES`, `STATUS`, `VERSION`, `INTERNAL-IP` を見て control plane と worker の役割を確認する
- `kubectl get pods -A -o wide`: `NAMESPACE`, `NAME`, `STATUS`, `NODE` を見て Pod がどの Node に載っているか確認する
- `kubectl describe node study-k8s-worker`: `Roles`, `Addresses`, `Capacity`, `Allocatable`, `Non-terminated Pods`, `Events` を見て Node の役割と状態を確認する

## 観察ポイント

- どの Node が control plane か
- 各 Pod がどの Node に乗っているか
- Node にどんな情報が載っているか

## 目的

- Kubernetes が複数 Node にまたがってスケジューリングする仕組みだと理解する

## 実務上のメリット

- 障害の切り分けがしやすくなる
- 今後のスケールや高可用性の考え方につながる

## この回で理解すべきこと

- Pod は Node 上で動く
- Service は Pod の前段に立つ抽象化である
- 将来 Node が増減しても Kubernetes が吸収しやすい

## 学ぶポイントの解説

この回では、Kubernetes が 1 台のマシンの上で Docker コンテナをまとめて動かしているだけの仕組みではないことを理解するのが重要です。Node は実際に Pod が動く実行基盤であり、control plane はクラスタ全体を管理する頭脳です。両者の役割が分かれることで、構成管理、スケジューリング、障害回復が可能になります。

Pod がどの Node に載っているかを観察する意味は、運用時の切り分けに直結します。ある API が落ちたとき、その Pod だけが悪いのか、Node 自体に問題があるのかで対応は変わります。Kubernetes を実務で使うなら、アプリの論理構成だけでなく、どこで動いているかという物理に近い視点も必要です。

Service が Pod の前段に立つ抽象化であることもここで意識してください。Pod は入れ替わる前提ですが、Service は安定した宛先を提供します。この考え方は、後で Ingress、監視、GitOps を理解する際の土台になります。

## 深掘りポイント

- taint と toleration
- scheduler の役割
- requests と limits が配置に与える影響

## この回の宿題

- なぜ worker を 3 台用意しているのか説明する
- もし 1 台しかなかったら何が学びにくくなるか整理する

## 実務で見る観点

- Pod が落ちたのか、Node が不安定なのかを分けて見られるか
- requests や limits が将来のスケジューリングに影響することを意識できるか

## よくある失敗

- control plane と worker の役割差を見ないままアプリだけを追う
- Pod が起動していない原因を Deployment だけで見て、Node 状態を確認しない

## 詰まったときの確認コマンド

```bash
kubectl get nodes -o wide
kubectl describe node study-k8s-worker
kubectl get pods -A -o wide
kubectl describe pod <pod-name> -n <namespace>
```

## 障害シナリオと復旧の考え方

想定シナリオ:

- Pod が Pending のままで起動しない
- 特定 Node にだけ Pod が偏り、挙動が不安定になる

復旧の考え方:

- Pod ではなく Node 側の状態とイベントを確認する
- スケジューリング条件、リソース不足、taint の有無を順に確認する

## レビュー観点と運用判断ポイント

- requests と limits はスケジューリング前提で妥当か
- 特定 Node 障害時にどこまで影響が広がるか説明できるか
- Node 数と役割が学習用途に対して過不足ないか

## 模擬インシデント演習

演習内容:

- Pod が Pending のままで動かないという報告を受けた前提で、Pod 側だけでなく Node 側も調べる

考えること:

- describe pod と describe node のどちらで何が分かるか
- スケジューリング失敗とアプリ起動失敗をどう分けるか

## レビューコメント例

- 「Pod 状態の確認だけで終わっているので、Node 側のイベントも見る手順を入れた方が実務に近いです。」
- 「requests と limits が無いと HPA やスケジューリングの説明につながりにくいので、Node 観察の段階で触れておくと理解が深まります。」

## 宿題の考え方

worker を 3 台にする意味は、高可用性を完全に再現することではなく、分散配置という考え方を観察しやすくすることにあります。複数台あることで、Pod がどこに載るか、Node 障害やリソース不足のときに何が起きるかを想像しやすくなります。実務ではこの「分散前提の考え方」が非常に重要です。

逆に 1 台しかない場合は、Kubernetes の価値が見えにくくなります。Node をまたいだスケジューリング、将来のスケール、障害時の逃がし先といった要素が観察しづらくなるからです。宿題では、単に数が多い方が良いと答えるのではなく、何を学ぶために複数台が必要なのかを言語化してください。

次は [handson3.md](handson3.md) で Namespace を設計します。