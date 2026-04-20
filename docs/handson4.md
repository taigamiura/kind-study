# Handson 4

## テーマ

Ingress と入口設計を学ぶ。

## 今回のゴール

- Ingress の役割を説明できる
- web-app と API の入口をどう統一するか理解できる
- localhost へのポートマッピングが何のためか説明できる

## この回で先に押さえる用語

- Service: Pod への安定した接続先
- Ingress: HTTP/HTTPS の入口
- Ingress Controller: Ingress を実際の通信制御に変換する本体
- North-South Traffic: 利用者とクラスタ間の通信

用語に迷ったら [glossary.md](glossary.md) の Service、Ingress、Ingress Controller を先に確認してください。

## 今回の構成

- / -> web-app
- /api/users -> user-service
- /api/items -> item-service

## 目的

- ブラウザやクライアントがアクセスする入口を 1 つにまとめる

## 実務上のメリット

- パスやドメインでルーティングを集中管理できる
- TLS 終端や認証連携の拡張先になる

## 学ぶポイント

- Pod を直接公開しない理由
- Service と Ingress の役割分担
- kind の extraPortMappings がローカル学習で重要な理由

## 学ぶポイントの解説

Ingress を学ぶときにまず押さえるべきなのは、外部からの入口と、クラスタ内部の到達先は分けて考えるという原則です。Pod は不安定で直接公開に向きませんし、Service は内部向けの安定した宛先ですが、URL パスやドメイン単位の制御は苦手です。そこで Ingress が、外部向けの入口としてルーティングを担います。

この役割分担を理解すると、なぜ web-app は /、API は /api/users や /api/items に振り分けるのかが見えてきます。利用者やブラウザから見ると入口は 1 つですが、裏側では適切な Service に振り分けられています。これは本番のロードバランサや API ゲートウェイの設計と発想が同じです。

kind の extraPortMappings が重要なのは、ローカル PC の 80 番や 443 番を kind クラスタの中の Ingress Controller に渡すためです。これがあることで、localhost 経由で本番に近い流れを再現できます。ローカル学習でも入口設計を省略しないことが、後で実務に入るときの理解差になります。

対応ファイル:

- [manifests/helm/ingress-nginx-values.yaml](../manifests/helm/ingress-nginx-values.yaml)
- [manifests/base/ingress/web-app-ingress.yaml](../manifests/base/ingress/web-app-ingress.yaml)
- [manifests/base/ingress/user-service-ingress.yaml](../manifests/base/ingress/user-service-ingress.yaml)
- [manifests/base/ingress/item-service-ingress.yaml](../manifests/base/ingress/item-service-ingress.yaml)
- [scripts/install-ingress-nginx.sh](../scripts/install-ingress-nginx.sh)

## この回で実際にやること

1. ingress-nginx を Helm でインストールする
2. web-app、user-service、item-service 用 Ingress 定義を読む
3. Ingress manifest を apply する
4. どの path がどの Service に流れるかを確認する

## 実行コマンド例

```bash
bash scripts/install-ingress-nginx.sh
kubectl apply -k manifests/base/ingress
kubectl get pods -n ingress-nginx
kubectl get ingress -n apps
kubectl describe ingress web-app -n apps
kubectl describe ingress user-service -n apps
kubectl describe ingress item-service -n apps
```

## 完了条件

- ingress-nginx namespace で controller Pod が起動している
- apps namespace に 3 つの Ingress が作成されている
- /、/api/users、/api/items の振り分け先を説明できる

## 実務で見る観点

- 外部入口の変更を Ingress に集約すると、アプリ側変更を減らせるか
- パス設計が増えたときも保守しやすい URL ルールになっているか

## よくある失敗

- Ingress Controller を入れずに Ingress manifest だけ apply して動かないと悩む
- path の rewrite や ingressClassName を見落として想定外の宛先に流す
- localhost にアクセスできず、kind の port mapping を確認しない

## 詰まったときの確認コマンド

```bash
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx
kubectl get ingress -n apps
kubectl describe ingress web-app -n apps
kubectl logs -n ingress-nginx -l app.kubernetes.io/component=controller --tail=100
```

## 障害シナリオと復旧の考え方

想定シナリオ:

- http://localhost にアクセスしても 404 や 503 が返る
- 一部パスだけ別 Service に流れず、API 呼び出しが失敗する

復旧の考え方:

- Ingress Controller が動いているかを確認する
- Ingress の path 設定、rewrite、backend Service、endpoints を順に確認する

## レビュー観点と運用判断ポイント

- path 設計は将来 API が増えても整理しやすいか
- ingressClassName や annotations が環境に依存しすぎていないか
- 外部入口の変更を Ingress に集約できているか

## 模擬インシデント演習

演習内容:

- /api/items だけ 404 になる状況を想定し、Ingress、Service、backend のどこで壊れているか切り分ける

考えること:

- path 定義、rewrite、Service 名、port のどれを優先して確認するか

## レビューコメント例

- 「Ingress 自体はありますが、rewrite の意図が読みにくいので、どの path がどの backend に流れるか明示した方が保守しやすいです。」
- 「Controller 導入前提が手順に埋もれているので、manifest apply だけでは動かない点を先に強調した方が初学者が詰まりにくいです。」

## 観察コマンド例

```bash
kubectl get svc -A
kubectl get ingress -A
kubectl describe ingress -n apps
```

## この回で理解すべきこと

- Service は内部向けの安定した宛先
- Ingress は外部入口のルーティング定義

## この回の宿題

- もし Ingress がなければ、どんな URL 設計になるか考える
- API が増えたときに入口を 1 つにまとめる価値を説明する

## 宿題の考え方

Ingress がない場合を考えると、各 Service を NodePort や LoadBalancer 相当で個別公開する発想になります。その場合、クライアント側は複数の URL やポートを意識する必要があり、運用も煩雑になります。宿題では、URL が増えること自体よりも、証明書管理、認証、ルーティング変更の集中管理が難しくなる点に注目してください。

API が増えたときに入口を 1 つにまとめる価値は、利用者に見せる面を単純にしつつ、裏側の構成を柔軟に変えられることです。クライアントに余計な内部構成を見せずに済むため、サービス追加や構成変更がやりやすくなります。これは実務で非常に大きなメリットです。

次は [handson5.md](handson5.md) で PostgreSQL を永続化します。