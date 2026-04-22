# Handson 11

## テーマ

Helm でアドオンを安全に導入する。

## 今回のゴール

- Helm の役割を説明できる
- 生 YAML と Helm の使い分けを理解できる
- values ファイルで環境差分を管理する感覚をつかむ

## この回で先に押さえる用語

- Helm: Kubernetes 向けパッケージ管理ツール
- values: Helm chart に渡す設定値
- Manifest: Kubernetes resource を宣言する YAML
- Upgrade: 既存リリースを更新する操作

用語に迷ったら [glossary.md](glossary.md) の Helm、Manifest を先に確認してください。

## なぜ Helm を学ぶのか

目的:

- ingress-nginx、Argo CD、kube-prometheus-stack のような大きなアドオンを、安全に導入する

実務上のメリット:

- 巨大な manifest を手書きせずに済む
- values だけレビューすれば差分の意図を追いやすい
- アップグレード時の運用が楽になる

## このリポジトリで使う values

- [manifests/helm/ingress-nginx-values.yaml](../manifests/helm/ingress-nginx-values.yaml)
- [manifests/helm/kube-prometheus-stack-values.yaml](../manifests/helm/kube-prometheus-stack-values.yaml)
- [manifests/helm/argocd-values.yaml](../manifests/helm/argocd-values.yaml)
- [manifests/helm/metrics-server-values.yaml](../manifests/helm/metrics-server-values.yaml)

## 実行スクリプト

- [scripts/install-ingress-nginx.sh](../scripts/install-ingress-nginx.sh)
- [scripts/install-monitoring.sh](../scripts/install-monitoring.sh)
- [scripts/install-argocd.sh](../scripts/install-argocd.sh)
- [scripts/install-metrics-server.sh](../scripts/install-metrics-server.sh)

## この回の前提

- `helm` コマンドがローカルに入っている
- すべてのスクリプトを一度に実行する必要はない

この回は `Helm をどう使うか` を学ぶ回なので、まず 1 つのアドオンだけを選んで観察すれば十分です。初学者は ingress-nginx か monitoring のどちらか 1 つに絞る方が理解しやすいです。

## この回で実際にやること

1. values ファイルを開いて、何を上書きしているか確認する
2. ingress-nginx、monitoring、argocd、metrics-server のインストールスクリプトを読む
3. まず 1 つだけ Helm で導入し、values の反映結果を確認する
4. Helm がどの namespace に何を作るかを観察する

おすすめの進め方:

1. `bash scripts/install-ingress-nginx.sh` を実行する
2. `helm list -A` で `ingress-nginx` release を見る
3. `helm get values ingress-nginx -n ingress-nginx` で values の反映結果を見る

`bash scripts/install-monitoring.sh` など他のスクリプトは、次の handson で必要になったときに追加で実行すれば十分です。

## 実行コマンド例

```bash
helm repo list
bash scripts/install-ingress-nginx.sh
helm list -A
kubectl get pods -n ingress-nginx
helm get values ingress-nginx -n ingress-nginx
```

出力で最低限見ること:

- `helm list -A` に release 名が出る
- namespace が想定どおりである
- `helm get values` に自分が values ファイルで変えた設定が反映されている

## 完了条件

- values ファイルで何を変更しているか説明できる
- Helm で導入したリソースがどこに作られたか確認できる
- Helm を使う対象と使わない対象の違いを言葉にできる

この回では `すべてのアドオンを入れ終える` 必要はありません。1 つの chart について `install script -> helm release -> 作成 resource` のつながりを追えれば十分です。

## 実務で見る観点

- 自作アプリと OSS アドオンで、管理方法を分ける判断ができるか
- Chart の upgrade 追従を考えて values の上書きを最小化できるか

## よくある失敗

- values で過剰に上書きして将来の chart upgrade を難しくする
- 4 つの install script を全部同時に実行して、どの結果がどの chart 由来か分からなくなる
- helm install だけ成功して満足し、実際に何が作られたか見ない
- 生 YAML の方が読みやすい対象まで Helm 化してしまう

## 詰まったときの確認コマンド

```bash
helm list -A
helm get values ingress-nginx -n ingress-nginx
helm get manifest ingress-nginx -n ingress-nginx | head -n 80
kubectl get all -n ingress-nginx
```

## 障害シナリオと復旧の考え方

想定シナリオ:

- Helm install は成功したが、values の上書きが期待どおり反映されない
- chart upgrade 後に以前のカスタマイズが壊れる

復旧の考え方:

- 実際に適用された values と manifest を確認する
- 上書き量が多すぎる場合は values と fork の境界を見直す

## レビュー観点と運用判断ポイント

- values の変更量は最小限か
- chart upgrade に追従しやすい構成か
- 自作アプリまで Helm に寄せていないか

## 模擬インシデント演習

演習内容:

- chart upgrade 後に ingress-nginx の挙動が変わり、values の上書きが効かなくなった状況を想定する

考えること:

- 実適用 values と manifest をどう比較するか
- values で持つべき差分と fork すべき差分をどう見極めるか

## レビューコメント例

- 「values の上書き範囲が広いので、将来の upgrade 追従を考えると必要最小限に絞った方が安全です。」
- 「OSS アドオンを Helm で扱い、自作アプリを別手段にする方針は長期保守の観点で妥当です。」

## 学ぶポイント

- 自作アプリは生 YAML や Kustomize で管理しやすい
- OSS アドオンは Helm の方が保守しやすい
- values で変える範囲を絞るのが重要

## 学ぶポイントの解説

Helm は Kubernetes のパッケージ管理に近い存在です。大きな OSS アドオンは関連リソースが多く、依存関係や設定項目も複雑です。それを全部手書きで持つのは保守が重くなりやすいため、よく整備された Chart を使い、必要な差分だけ values で管理する方が現実的です。

一方で、自作アプリまで何でも Helm に載せればよいわけではありません。自作部分は構成が小さく、変更意図も明確にしたいので、生 YAML や Kustomize の方が読みやすいことが多いです。つまり、Helm は万能ではなく、複雑な既製品を扱うための道具として捉えるのが実務的です。

values で変える範囲を絞るのが重要なのは、上書き箇所が増えるほど Chart のアップグレードが難しくなるからです。必要最低限の差分に留めることで、将来の保守コストを抑えられます。ここには「今の便利さ」と「将来の保守」のトレードオフがあります。

## この回の宿題

- どこまで values で上書きし、どこから fork すべきか整理する
- Helm を使う対象と使わない対象を分ける基準を考える

## 宿題の考え方

values で上書きするか fork するかは、変更頻度と変更量を軸に考えると整理しやすいです。少数の設定変更で済むなら values で十分ですが、テンプレートそのものを大きく変え続けるなら fork の方が現実的な場合があります。ただし fork は将来の追従コストを増やすので、軽く決めてはいけません。

Helm を使う対象と使わない対象を分ける基準としては、既製品か、自作か、リソース数は多いか、アップグレードパスは整っているかを見るとよいです。宿題では、技術的に使えるかではなく、運用上どちらが長期的に楽かを基準に考えてください。

次は [handson12.md](handson12.md) で Kustomize を学びます。