# Handson 6

## テーマ

user-service と item-service を Kubernetes 上で動かす考え方を学ぶ。

## 今回のゴール

- Deployment と Service の基本責務を説明できる
- API を 2 つに分ける意味を理解できる
- readinessProbe と livenessProbe の役割を説明できる

## この回で先に押さえる用語

- Deployment: stateless なアプリを更新、増減させる仕組み
- Service: Pod の前段に置く安定した接続先
- ConfigMap: 機密でない設定値
- Secret: 機密情報
- readinessProbe: 配信してよい状態かを見る probe
- livenessProbe: 再起動すべき状態かを見る probe

用語に迷ったら [glossary.md](glossary.md) の Deployment、Service、ConfigMap、Probe を先に確認してください。

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

## 学ぶポイントの解説

この回では、Kubernetes 上で stateless な API をどう扱うかを学びます。Deployment は「望ましい Pod 数を維持する」役割を持ち、Service は「その API に対する安定した入口」を提供します。実務ではこの 2 つを正しく分けて理解できているかで、トラブル時の切り分け速度が大きく変わります。

API を 2 つに分ける意味は、技術的に分けられるからではなく、変更や障害の単位を小さくできるからです。user-service だけ直したい、item-service だけスケールしたい、という要求は現場で頻繁に出ます。マイクロサービスは流行語ではなく、変更の境界を明確にするための設計手法だと捉えると理解しやすくなります。

readinessProbe と livenessProbe の違いも必ず言葉で説明できるようにしてください。起動済みかどうかと、正常にトラフィックを受けられるかどうかは別問題です。ここを曖昧にすると、起動直後のエラーやハング時の振る舞いを誤解しやすくなります。

## 観察コマンド例

```bash
kubectl get deploy -n apps
kubectl get svc -n apps
kubectl describe pod -n apps
```

対応 manifest:

- [manifests/base/user-service/configmap.yaml](../manifests/base/user-service/configmap.yaml)
- [manifests/base/user-service/deployment.yaml](../manifests/base/user-service/deployment.yaml)
- [manifests/base/user-service/service.yaml](../manifests/base/user-service/service.yaml)
- [manifests/base/item-service/configmap.yaml](../manifests/base/item-service/configmap.yaml)
- [manifests/base/item-service/deployment.yaml](../manifests/base/item-service/deployment.yaml)
- [manifests/base/item-service/service.yaml](../manifests/base/item-service/service.yaml)

## この回で実際にやること

1. user-service と item-service の ConfigMap、Deployment、Service を読む
2. 2 つの API を apply する
3. Deployment、Pod、Service が作成されていることを確認する
4. readinessProbe と livenessProbe の設定箇所を確認する
5. Service 名で到達できる内部 DNS 名を言えるようにする

## 実行コマンド例

```bash
kubectl apply -k manifests/base/user-service
kubectl apply -k manifests/base/item-service
kubectl get deploy,po,svc -n apps
kubectl describe deployment user-service -n apps
kubectl describe deployment item-service -n apps
kubectl get endpoints -n apps
```

各コマンドの目的:

- `kubectl apply -k manifests/base/user-service`: user-service の manifest を反映する
- `kubectl apply -k manifests/base/item-service`: item-service の manifest を反映する
- `kubectl get deploy,po,svc -n apps`: Deployment、Pod、Service がそろって作成されたか確認する
- `kubectl describe deployment user-service -n apps`: user-service の probe や rollout 状態を確認する
- `kubectl describe deployment item-service -n apps`: item-service の probe や rollout 状態を確認する
- `kubectl get endpoints -n apps`: Service selector が Pod に一致して endpoints が張られているか確認する

このコマンドで確認するのはここ:

- `kubectl get deploy,po,svc -n apps`: Deployment と Pod の `READY/AVAILABLE`、Service の存在を見る
- `kubectl describe deployment ...`: `Replicas`, `Selector`, `Pod Template`, `Conditions`, `Events` を見る
- `kubectl get endpoints -n apps`: user-service と item-service に実際の Pod IP がぶら下がっているかを見る

## 完了条件

- user-service と item-service の Pod が Running になっている
- apps namespace に 2 つの Service が作成されている
- probe の役割と Service の名前解決先を説明できる

## 実務で見る観点

- API 単位でスケール、更新、障害切り分けができる設計になっているか
- readinessProbe と livenessProbe の設計が、実アプリの起動特性に合っているか

## よくある失敗

この回では `Pod が Running` でも `Service で届く` とは限らない点が重要です。特に endpoints が空のときは、アプリ故障ではなく selector や Ready 判定の問題であることが多いです。

- readinessProbe と livenessProbe を同じ意味で使ってしまう
- Service があるのに selector 不一致で endpoints が空になる
- ConfigMap や Secret の値を変えても Pod 再起動が必要なことを見落とす

## 詰まったときの確認コマンド

```bash
kubectl get deploy,po,svc,endpoints -n apps
kubectl describe deployment user-service -n apps
kubectl describe deployment item-service -n apps
kubectl describe pod <pod-name> -n apps
kubectl logs <pod-name> -n apps
```

## 障害シナリオと復旧の考え方

想定シナリオ:

- Pod は Running だが Service 経由でアクセスできない
- readinessProbe 失敗でトラフィックが流れない
- ConfigMap 更新後も挙動が変わらない

復旧の考え方:

- Service selector と endpoints を確認する
- probe の失敗理由を describe と logs で追う
- 設定変更後に Pod 再作成が必要か判断する

## レビュー観点と運用判断ポイント

- Deployment と Service の責務分離が崩れていないか
- probe はアプリの実態に合った閾値か
- ConfigMap と Secret の使い分けが適切か

## 模擬インシデント演習

演習内容:

- user-service の Pod は Running だが、Service 経由でアクセスできない状況を想定する

考えること:

- selector、endpoints、probe、logs のどこから確認するか
- Running と Ready の違いをどう説明するか

## レビューコメント例

- 「Pod が立つことだけでなく endpoints が張られることまで完了条件に含めると、Service の理解が一段深まります。」
- 「probe 設定があるのは良いですが、なぜこの path と初期待機時間なのか補足があるとレビューしやすいです。」

## この回の宿題

- なぜ API と DB を同じ Pod にしないのか説明する
- どちらか片方だけ replica を増やせるメリットを整理する

## 宿題の考え方

API と DB を同じ Pod にしない理由を考えるときは、障害の独立性、スケールの独立性、更新の独立性を軸に整理してください。API は増やしたいが DB はむやみに増やしたくない、API は頻繁に更新するが DB は慎重に扱いたい、といった要件が両者にはあります。これが同居すると、設計が窮屈になります。

片方だけ replica を増やせるメリットについては、負荷がどこに集中するかを想像すると分かりやすいです。ユーザー参照だけ急増することもあれば、商品一覧だけ重いこともあります。実務では「全部まとめて増やす」のではなく、「必要な場所だけ増やす」ことでコストもリスクも抑えます。

次は [handson7.md](handson7.md) で web-app を扱います。