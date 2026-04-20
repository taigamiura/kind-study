# Handson 7

## テーマ

web-app と API の分離構成を学ぶ。

## 今回のゴール

- フロントエンドと API を分ける理由を説明できる
- web-app を Ingress 配下で公開する流れを理解できる
- クライアントから API を呼ぶ経路を説明できる

## この回で先に押さえる用語

- Deployment: アプリの配備と更新を管理する仕組み
- Service: API や web-app への安定した接続先
- Ingress: 外部公開の入口
- Stateless Workload: Pod を入れ替えやすい workload

用語に迷ったら [glossary.md](glossary.md) の Deployment、Service、Ingress、Stateless Workload を先に確認してください。

## 推奨リソース

- Deployment
- Service
- Ingress

## 目的

- ブラウザ向けアプリを API と分離して運用する基本を学ぶ

## 実務上のメリット

- フロントと API のリリースを分けられる
- キャッシュや CDN の拡張がしやすい
- UI 改修と API 改修の責務を分けられる

## 観察ポイント

- ブラウザは Ingress を入口に使う
- web-app が API を呼ぶ経路が明確である
- フロントだけの再デプロイが可能である

対応 manifest:

- [manifests/base/web-app/configmap.yaml](../manifests/base/web-app/configmap.yaml)
- [manifests/base/web-app/deployment.yaml](../manifests/base/web-app/deployment.yaml)
- [manifests/base/web-app/service.yaml](../manifests/base/web-app/service.yaml)
- [manifests/base/ingress/web-app-ingress.yaml](../manifests/base/ingress/web-app-ingress.yaml)

## この回で実際にやること

1. web-app の ConfigMap を開いて、どんな HTML が配信されるか確認する
2. web-app の Deployment と Service を apply する
3. web-app 用 Ingress を apply する
4. ブラウザまたは curl でトップページへアクセスし、画面が返ることを確認する
5. web-app から /api/users と /api/items を呼ぶ構成になっていることを確認する

## 実行コマンド例

```bash
kubectl apply -k manifests/base/web-app
kubectl apply -f manifests/base/ingress/web-app-ingress.yaml
kubectl get deploy,po,svc -n apps
kubectl get ingress -n apps
kubectl describe deployment web-app -n apps
curl -I http://localhost/
curl http://localhost/
```

## 完了条件

- web-app Pod と Service が apps namespace に作成されている
- web-app Ingress が作成されている
- http://localhost/ へアクセスして HTML が返る
- HTML 内で /api/users と /api/items を呼んでいることを説明できる

## 実務で見る観点

- Web の配信と API の提供を分離することで、リリース戦略と障害対応がどう変わるか
- ブラウザから見える URL と、クラスタ内部の通信経路を別レイヤーで説明できるか

## よくある失敗

- web-app だけ公開して API 側 Ingress や Service の疎通確認をしない
- localhost の応答だけ見て、HTML 内の API 呼び出し失敗を見落とす
- ブラウザとクラスタ内部の通信経路を混同して CORS や認証の論点を整理できない

## 詰まったときの確認コマンド

```bash
kubectl get deploy,po,svc,ingress -n apps
kubectl describe deployment web-app -n apps
kubectl logs -l app.kubernetes.io/name=web-app -n apps
curl -I http://localhost/
curl http://localhost/ | head -n 40
curl http://localhost/api/users
curl http://localhost/api/items
```

## 障害シナリオと復旧の考え方

想定シナリオ:

- トップページは返るが API 呼び出し部分だけ表示が崩れる
- web-app の再デプロイ後に画面は出るが想定 API に到達していない
- Ingress 設定の不足でブラウザからの公開面だけが壊れる

復旧の考え方:

- まず HTML 配信と API 呼び出しの問題を分けて考える
- ブラウザ入口、Ingress、Service、API 応答を順に切り分ける
- 画面が出ることとシステム全体が正常であることを分けて判断する

## レビュー観点と運用判断ポイント

- Web と API を別々にリリースしても整合性が崩れにくいか
- フロントから見える URL と内部実装の結合度が高すぎないか
- 利用者向けエラー時の表示や切り分け導線を考えられているか

## 模擬インシデント演習

演習内容:

- トップページは表示されるが、画面内の user-service と item-service の表示だけ loading のままになる状況を想定する

考えること:

- HTML 配信、Ingress、API 応答のどこから調べるか
- curl でトップページと API を別々に叩く理由は何か

## レビューコメント例

- 「画面表示確認だけだと API 呼び出し失敗を見落とすので、/api/users と /api/items の疎通確認も完了条件に含めたいです。」
- 「フロントの公開面と内部 API 経路の説明が明確なので良いですが、失敗時の利用者向け見え方もレビュー観点に入るとより実務的です。」

## 深掘りポイント

- CSR と SSR の違い
- 環境変数注入とビルド時設定の違い
- CORS をどこで解決するか

## 学ぶポイントの解説

この回では、フロントエンドと API を分けて運用する意味を理解します。初学者は 1 つにまとめた方が簡単に見えるかもしれませんが、実務では UI の改善頻度と API の変更頻度は一致しないことが多く、両者を分けておく方が運用しやすくなります。責務の分離は、コードの美しさよりも変更のしやすさのためにあります。

web-app が Ingress 経由で公開され、そこから API にアクセスする構成は、利用者から見た入り口を単純にしつつ、内部実装の変更余地を残す設計です。ここでは、ブラウザがどの URL にアクセスし、その裏でどの Service にルーティングされるかを追ってください。ネットワーク経路を言葉で説明できるようになると、CORS や認証、キャッシュの話が理解しやすくなります。

また、フロントエンドは単に画面を出すだけではなく、公開面そのものです。配信方法、キャッシュ、環境変数の扱い、API 呼び出しの失敗時の見せ方など、利用者に近い問題を持ちます。この視点を持つと、Web を API のおまけとして扱わなくなります。

## この回の宿題

- Web と API を 1 つにまとめない理由を整理する
- フロントだけを先にリリースしたい場面を考える

## 宿題の考え方

Web と API を分ける理由を考えるときは、デプロイ単位、開発チーム、障害影響範囲、キャッシュ戦略の違いを思い浮かべてください。フロントだけ文言修正したい、API だけ仕様追加したい、という場面は実務で日常的に起こります。そのたびに両方まとめて再リリースするのは効率が悪く、事故も増えます。

フロントだけを先にリリースしたい場面としては、表示改善、文言修正、段階的な UI 公開、API 変更前の先行デプロイなどが考えられます。宿題では、単なる機能差ではなく、リリース戦略上なぜ分離が効くのかを意識して整理してください。

次は [handson8.md](handson8.md) で Ridgepole を扱います。