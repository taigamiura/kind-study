# Handson 16

## テーマ

HTTPS 化と TLS 証明書運用を学ぶ。

## 今回のゴール

- Kubernetes で HTTPS を有効化する流れを説明できる
- cert-manager、Issuer、Certificate、Ingress の役割分担を理解できる
- TLS 終端とアプリ本体の責務を分けて説明できる

## この回で先に押さえる用語

- HTTPS: TLS で保護された HTTP 通信
- TLS: 通信を暗号化する仕組み
- cert-manager: 証明書発行と更新を管理するコンポーネント
- Issuer: どこから証明書を発行するかを定義する resource
- Certificate: 欲しい証明書の内容を定義する resource
- Ingress: HTTPS の入口になる resource

用語に迷ったら [glossary.md](glossary.md) の Ingress、Secret、mTLS ではなくまず TLS 周辺の説明を確認してください。

## 対応ファイル

- [manifests/helm/cert-manager-values.yaml](../manifests/helm/cert-manager-values.yaml)
- [scripts/install-cert-manager.sh](../scripts/install-cert-manager.sh)
- [manifests/extensions/https/apps-selfsigned-issuer.yaml](../manifests/extensions/https/apps-selfsigned-issuer.yaml)
- [manifests/extensions/https/apps-certificate.yaml](../manifests/extensions/https/apps-certificate.yaml)
- [manifests/extensions/https/secure-ingress.yaml](../manifests/extensions/https/secure-ingress.yaml)

## この回で実際にやること

1. cert-manager を Helm でインストールする
2. Issuer と Certificate の manifest を読み、秘密鍵と証明書がどう管理されるか理解する
3. HTTPS 用 Ingress を apply する
4. app.localtest.me で HTTPS アクセスを試す
5. HTTP から HTTPS へ誘導する理由を整理する

## 実行コマンド例

```bash
bash scripts/install-cert-manager.sh
kubectl apply -k manifests/extensions/https
kubectl get pods -n cert-manager
kubectl get issuer,certificate -n apps
kubectl get secret apps-local-tls -n apps
kubectl describe certificate apps-local-tls -n apps
curl -kI https://app.localtest.me/
curl -k https://app.localtest.me/
```

各コマンドの目的:

- `bash scripts/install-cert-manager.sh`: 証明書発行を担う cert-manager を導入する
- `kubectl apply -k manifests/extensions/https`: Issuer、Certificate、HTTPS Ingress などを反映する
- `kubectl get pods -n cert-manager`: cert-manager 本体が起動しているか確認する
- `kubectl get issuer,certificate -n apps`: 証明書発行関連 resource が作成されたか確認する
- `kubectl get secret apps-local-tls -n apps`: 発行済み証明書 Secret が生成されたか確認する
- `kubectl describe certificate apps-local-tls -n apps`: 証明書の Ready 状態やイベントを確認する
- `curl -kI https://app.localtest.me/`: HTTPS 入口が応答しているかヘッダだけ確認する
- `curl -k https://app.localtest.me/`: HTTPS 経由で本文が返るか確認する

このコマンドで確認するのはここ:

- `kubectl get pods -n cert-manager`: `READY`, `STATUS`, `RESTARTS` を見る
- `kubectl get issuer,certificate -n apps`: `READY` と resource 名を見る
- `kubectl get secret apps-local-tls -n apps`: Secret が実際に生成されたかを見る
- `kubectl describe certificate apps-local-tls -n apps`: `Secret Name`, `Conditions`, `Events` を見る
- `curl -kI https://app.localtest.me/`: HTTP ステータスと応答有無を見る
- `curl -k https://app.localtest.me/`: 画面本文が返るかを見る

## 完了条件

- cert-manager の Pod が起動している
- apps namespace に Issuer と Certificate が作成されている
- apps-local-tls Secret が作成されている
- https://app.localtest.me/ で画面へアクセスできる

## 実務で見る観点

- TLS 証明書の発行、更新、利用をアプリ本体から切り離して考えられるか
- HTTPS 化を Ingress 層で扱うことで、アプリ変更を最小化できるか

## よくある失敗

HTTPS 化では、証明書、Secret、Ingress の 3 つがそろって初めて動きます。どれか 1 つだけ見て安心すると、発行済みなのに参照先が違う、といった事故を見落としやすいです。

- cert-manager 本体を入れずに Certificate だけ apply して待ち続ける
- host 名と証明書 SAN が一致せず、ブラウザ警告や接続失敗になる
- Ingress に TLS 設定を入れたが secretName が一致していない

## 詰まったときの確認コマンド

```bash
kubectl get pods -n cert-manager
kubectl get issuer,certificate -n apps
kubectl describe certificate apps-local-tls -n apps
kubectl describe ingress app-secure -n apps
kubectl get secret apps-local-tls -n apps -o yaml
```

## 障害シナリオと復旧の考え方

想定シナリオ:

- HTTP はつながるが HTTPS だけ失敗する
- Certificate はあるが Secret が作られない
- 証明書はあるが Ingress が正しい Secret を参照していない

復旧の考え方:

- まず cert-manager、Issuer、Certificate、Secret、Ingress の順で状態を確認する
- TLS 証明書の問題とアプリ疎通の問題を分けて考える

## レビュー観点と運用判断ポイント

- TLS 設定がアプリ側に埋め込まれず、Ingress で完結しているか
- 証明書発行元と利用先の責務が分かれているか
- 将来 ACME や社内 CA に差し替えやすい構成か

## 模擬インシデント演習

演習内容:

- http://app.localtest.me は見えるが https://app.localtest.me が 404 か証明書エラーになる状況を想定する

考えること:

- Ingress、Certificate、secretName のどこから確認するか
- アプリ疎通と TLS 設定の問題をどう切り分けるか

## レビューコメント例

- 「HTTPS 化の手順はありますが、Secret 作成確認を完了条件に含めると証明書発行の責務が見えやすくなります。」
- 「TLS を Ingress 層で扱っているのは良いです。アプリ側に証明書配置を持ち込まないため、保守性が高いです。」

## 学ぶポイント

- HTTPS はアプリ本体ではなく入口層で扱うことが多い
- TLS 証明書は Secret としてクラスタ内で参照される
- 証明書発行と証明書利用は別の責務である

## 学ぶポイントの解説

実務で HTTPS は必須に近い要件です。重要なのは、アプリの中で個別に TLS を実装するのではなく、Ingress やロードバランサで終端する構成を理解することです。そうすることで、アプリは通常の HTTP を話すだけでよくなり、証明書更新や暗号設定を入口で集中管理できます。

cert-manager を学ぶ価値は、証明書を手で配る運用から離れられることにあります。Issuer が「どこから証明書を出すか」、Certificate が「どんな証明書が欲しいか」を宣言し、最終的に Secret として利用できる形にする、という責務分離を理解してください。

## この回の宿題

- なぜ TLS はアプリ本体ではなく Ingress で終端することが多いのか整理する
- self-signed 証明書と公開 CA の違いを、学習環境と本番環境の観点から説明する

## 宿題の考え方

TLS 終端を Ingress で行う理由は、証明書更新、暗号設定、複数アプリへの適用を集中管理しやすいからです。宿題では、アプリごとに証明書を持たせた場合の運用負荷と比較して考えてください。

self-signed と公開 CA の違いは、信頼の配布方法にあります。学習環境では self-signed で十分ですが、本番では利用者のブラウザが自動で信頼できる公開 CA が通常必要です。

次は [handson17.md](handson17.md) でサービスメッシュを学びます。