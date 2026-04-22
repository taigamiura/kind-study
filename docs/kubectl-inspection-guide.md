# kubectl 確認コマンドの見方ガイド

このガイドは、handson 全体で頻出する kubectl 確認コマンドを、`何のために打つか` と `どこを見ればよいか` の観点でまとめたものです。

初学者が詰まりやすいのは、コマンドを打てても `出力のどこが重要か` が分からないことです。そこでこのガイドでは、まず見る順番を固定し、その後に resource ごとの読み方を並べます。

## 最初に覚える確認順序

迷ったら、まず次の順番で確認します。

1. `kubectl get ...`
   何が存在していて、ざっくり正常そうかを見る
2. `kubectl describe ...`
   その resource の詳細設定、状態、イベントを見る
3. `kubectl logs ...`
   コンテナや controller が実際に何で失敗しているかを見る
4. `kubectl get events ...`
   直近に何が起きたかを時系列で見る

この順番にしている理由は、いきなり logs だけを見ると、`そもそも対象 resource が作られていない`, `selector がずれている`, `Ingress が無い` のような構成ミスを見落としやすいからです。

## まず何を見るか

### `kubectl get` の役割

`kubectl get` は、存在確認と全体俯瞰のために使います。

よく見る列:

- Pod: `READY`, `STATUS`, `RESTARTS`, `AGE`, `NODE`
- Deployment: `READY`, `UP-TO-DATE`, `AVAILABLE`
- Service: `TYPE`, `CLUSTER-IP`, `PORT(S)`
- Ingress: `CLASS`, `HOSTS`, `ADDRESS`, `PORTS`
- HPA: `TARGETS`, `MINPODS`, `MAXPODS`, `REPLICAS`

読み方の例:

- Pod の `READY` が `1/1` でない: sidecar 注入や probe 失敗を疑う
- Pod の `STATUS` が `CrashLoopBackOff`: まず logs と describe を見る
- Deployment の `AVAILABLE` が desired より少ない: Pod が Ready になれていない可能性がある
- Service はあるが通信できない: endpoints や selector 不一致を疑う
- Ingress はあるがブラウザで見えない: host、path、backend、controller の順で確認する

### `kubectl describe` の役割

`kubectl describe` は、resource ごとの設定内容と状態変化を確認するために使います。

大事なのは、上から全部読むのではなく、見る場所を決めることです。

基本的な見る順番:

1. `Labels` / `Annotations`
   selector や controller が拾う条件に関係する
2. `Spec`
   何を作るつもりか、どこへ流すつもりかを確認する
3. `Status` / `Conditions`
   今どういう判断状態かを確認する
4. `Events`
   直近に何で失敗したか、何が起きたかを確認する

## resource ごとの見方

### Pod を describe するとき

主に次を見ます。

- `Containers`
  image、port、env、probe の設定が期待どおりか
- `State` / `Last State`
  今失敗しているか、直前に落ちたか
- `Ready`
  Service に流してよい状態か
- `Events`
  ImagePullBackOff、probe failure、mount failure などの直接原因

見方のコツ:

- `CrashLoopBackOff`: まず `Last State` と `kubectl logs` を見る
- `Ready: False`: probe 失敗や依存先未起動を疑う
- volume mount 関連の event: Secret、ConfigMap、PVC の存在を確認する

### Deployment を describe するとき

主に次を見ます。

- `Replicas`
  desired と available の差があるか
- `Selector`
  Pod ラベルと一致しているか
- `Pod Template`
  実際にどういう Pod を作ろうとしているか
- `Conditions`
  rollout が進んでいるか、止まっているか
- `Events`
  ReplicaSet 作成や rollout 失敗理由

見方のコツ:

- Deployment はあるのに Pod が来ない: selector や image、admission を疑う
- desired はあるが available が増えない: Pod 側の Ready 失敗を疑う

### Service を見るとき

Service では `kubectl describe service` そのものより、`kubectl get endpoints` も合わせて見るのが重要です。

主に次を見ます。

- `Selector`
  どの Pod を後ろにぶら下げるつもりか
- `Port` / `TargetPort`
  どのポートへ流すつもりか
- Endpoints
  実際に Pod がぶら下がっているか

見方のコツ:

- Service があるのに届かない: selector 不一致で endpoints が空のことが多い
- endpoints が空: Pod ラベルか Ready 状態を確認する

### Ingress を describe するとき

主に次を見ます。

- `Ingress Class`
  controller が拾う設定か
- `Rules`
  host と path が期待どおりか
- `Backend`
  どの Service と port に流すか
- `Annotations`
  rewrite や ssl-redirect などの controller 依存設定
- `Events`
  controller が解釈できているか

見方のコツ:

- Ingress があるだけでは不十分で、controller がいるかも別に確認する
- host が違うとブラウザでは当たらない
- backend Service 名や port がずれると 404 / 503 になりやすい

### HPA を describe するとき

主に次を見ます。

- `Reference`
  どの Deployment を監視しているか
- `Metrics`
  current と target の差
- `Min replicas` / `Max replicas`
  制約条件
- `Conditions`
  今判断できているか、制約に当たっていないか
- `Events`
  metrics 取得失敗や計算失敗の履歴

Conditions の読み方:

- `AbleToScale`
  HPA がスケール判断できる状態か
- `ScalingActive`
  今メトリクスを取って計算できているか
- `ScalingLimited`
  minReplicas / maxReplicas の制約に引っかかっていないか

見方のコツ:

- Events は過去履歴、Conditions は今の状態として読む
- `ValidMetricFound` なら現在は復旧している可能性が高い
- `ScaleDownStabilized` なら急に縮めず様子見している

### NetworkPolicy を describe するとき

主に次を見ます。

- `PodSelector`
  どの Pod に policy が効くか
- `Policy Types`
  Ingress だけか、Egress も含むか
- `Ingress` / `Egress`
  どこから来てよいか、どこへ出てよいか

見方のコツ:

- Ingress は `その Pod に入ってくる通信`
- Egress は `その Pod から出ていく通信`
- どちらを制御しているかを混同しない

### Certificate を describe するとき

主に次を見ます。

- `Secret Name`
  どの Secret を作るか
- `Issuer Ref`
  どの発行元を使うか
- `Conditions`
  Ready かどうか
- `Events`
  発行失敗、Secret 未作成、参照先不整合

見方のコツ:

- `Ready=True` だけで安心せず、Secret ができているかも確認する
- host 名と SAN、Ingress の secretName も合わせて確認する

### Argo CD Application を describe するとき

主に次を見ます。

- `repoURL`, `targetRevision`, `path`
  何を正として見ているか
- `Destination`
  どこへ同期するか
- `Sync Policy`
  automated、selfHeal、prune の有無
- `Status`
  Synced / OutOfSync、Healthy / Degraded
- `Events`
  sync 失敗や path 間違い

見方のコツ:

- `OutOfSync` は Git とクラスタの差分
- `Healthy` は resource が概ね正常に動いているか
- `Synced` と `Healthy` は別物として読む

## logs を見るとき

`kubectl logs` は、`describe` で対象が正しいと分かってから読む方が効率的です。

主に見ること:

- 起動時に何で失敗したか
- probe 失敗の原因
- 接続先 URL や認証失敗
- migration や初期化失敗

見方のコツ:

- Pod が複数あるときは、どの Pod の logs か意識する
- sidecar があるときは container 名も意識する
- `kubectl logs` は症状、`describe` は構成とイベント、と分けて考える

## events を見るとき

`kubectl get events -A --sort-by=.lastTimestamp | tail -n 30` は、直近に何が起きたかを全体俯瞰するときに便利です。

主に見ること:

- いつから失敗し始めたか
- どの namespace で起きたか
- image pull、probe failure、mount failure、admission deny などの種別

見方のコツ:

- logs より前に events を見ると、失敗の種類をざっくり絞りやすい
- まず時系列をつかみ、その後に個別 resource を掘る

## 迷ったときの短い切り分け

### ブラウザから見えない

1. Pod は起動しているか
2. Service はあるか
3. Endpoints はあるか
4. Ingress はあるか
5. Ingress Controller は起動しているか

### Pod は Running だが通信できない

1. Service selector は合っているか
2. Endpoints は張られているか
3. readinessProbe に落ちていないか
4. Ingress / NetworkPolicy が止めていないか

### HPA が動かない

1. metrics-server はいるか
2. `kubectl top` は通るか
3. Deployment に requests はあるか
4. HPA の Conditions と Events はどうなっているか

## このガイドの使い方

- handson で `kubectl describe ...` が出てきたら、このガイドに戻って `Spec`, `Conditions`, `Events` のどこを見るかを確認する
- `kubectl get ...` の出力が多すぎるときは、`存在確認` と `状態確認` に分けて読む
- `何を見ればいいか分からない` と感じたら、まず `get -> describe -> logs -> events` の順に戻る

このガイドは、コマンドを増やすためではなく、出力の読み方を固定するための資料です。慣れてくると、同じ見方で Pod、Deployment、Ingress、HPA、Argo CD を読めるようになります。