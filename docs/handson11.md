# Handson 11

## テーマ

Helm でアドオンを安全に導入する。

## 今回のゴール

- Helm の役割を説明できる
- 生 YAML と Helm の使い分けを理解できる
- values ファイルで環境差分を管理する感覚をつかむ

## この回で先に押さえる用語

- Helm: Kubernetes 向けパッケージ管理ツール
- Chart: Helm で配布される `ひとまとまりのアプリ定義`。Deployment、Service、Ingress など複数 resource の設計図一式
- Release: その Chart を自分のクラスタへ 1 回インストールした実体
- values: Helm chart に渡す設定値
- Manifest: Kubernetes resource を宣言する YAML
- Upgrade: 既存リリースを更新する操作

用語に迷ったら [glossary.md](glossary.md) の Helm、Manifest を先に確認してください。

## 最初に理解したいこと

初学者が一番混乱しやすいのは、`Chart`、`Release`、`values` が全部似たものに見えることです。ここは次の 3 つに分けると整理しやすいです。

- Chart: OSS アドオンの設計図や部品セット
- values: その設計図に渡す設定
- Release: 設計図と設定を使って、実際に自分のクラスタへ作られた 1 回分の導入結果

たとえばこのリポジトリの ingress-nginx は、`ingress-nginx/ingress-nginx` という Chart を、`manifests/helm/ingress-nginx-values.yaml` という values で設定して、`ingress-nginx` という Release 名でクラスタへ入れています。

この文が `どこのファイルの何を指しているか` を対応付けると、次のようになります。

- Chart の指定場所: [scripts/install-ingress-nginx.sh](../scripts/install-ingress-nginx.sh)
	`helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx ...` の `ingress-nginx/ingress-nginx` の部分
- values ファイルの実体: [manifests/helm/ingress-nginx-values.yaml](../manifests/helm/ingress-nginx-values.yaml)
	ここに `controller.kind`, `hostPort.enabled`, `watchIngressWithoutClass` など、この教材で ingress-nginx に渡したい設定が書かれている
- Release 名の指定場所: [scripts/install-ingress-nginx.sh](../scripts/install-ingress-nginx.sh)
	`helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx ...` の最初の `ingress-nginx` の部分

つまり、この教材では 1 つの install script の中で、`どの Chart を使うか`, `どの values を渡すか`, `その結果をどの Release 名で管理するか` をまとめて指定しています。

つまり、次のように考えると理解しやすいです。

- Chart は `商品そのもの`
- values は `注文時のオプション`
- Release は `自分の環境に届いた実物`

この例をファイルに対応付けると、次の見方になります。

- Chart は [scripts/install-ingress-nginx.sh](../scripts/install-ingress-nginx.sh) の `ingress-nginx/ingress-nginx`
- values は [manifests/helm/ingress-nginx-values.yaml](../manifests/helm/ingress-nginx-values.yaml)
- Release は [scripts/install-ingress-nginx.sh](../scripts/install-ingress-nginx.sh) の最初の `ingress-nginx` で、導入後は `helm list -A` で確認する対象

比較できるように、Argo CD も同じ形で並べると次のようになります。

| 対象 | Chart の指定場所 | values ファイル | Release 名の指定場所 |
| --- | --- | --- | --- |
| ingress-nginx | [scripts/install-ingress-nginx.sh](../scripts/install-ingress-nginx.sh) の `ingress-nginx/ingress-nginx` | [manifests/helm/ingress-nginx-values.yaml](../manifests/helm/ingress-nginx-values.yaml) | [scripts/install-ingress-nginx.sh](../scripts/install-ingress-nginx.sh) の最初の `ingress-nginx` |
| Argo CD | [scripts/install-argocd.sh](../scripts/install-argocd.sh) の `argo/argo-cd` | [manifests/helm/argocd-values.yaml](../manifests/helm/argocd-values.yaml) | [scripts/install-argocd.sh](../scripts/install-argocd.sh) の最初の `argocd` |

この比較を入れる学習上のメリットは、`Helm の共通構造は同じで、中身の Chart と values だけが変わる` と分かりやすくなることです。1 個だけだと丸暗記になりやすいですが、2 例並ぶと共通パターンを見つけやすくなります。

この回は `Helm コマンドを打てるようになる` だけでなく、`今見ているのが Chart なのか Release なのか` を区別できるようになることが重要です。

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
- 最初は 1 つの Chart だけ追えば十分である

この回は `Helm をどう使うか` を学ぶ回なので、まず 1 つのアドオンだけを選んで観察すれば十分です。初学者は ingress-nginx か monitoring のどちらか 1 つに絞る方が理解しやすいです。

特に最初は ingress-nginx をおすすめします。理由は、script が短く、作られる namespace や release 名も分かりやすく、後続 handson でも登場回数が多いからです。

## この回で実際にやること

1. values ファイルを開いて、何を上書きしているか確認する
2. ingress-nginx、monitoring、argocd、metrics-server のインストールスクリプトを読む
3. script の中の `helm upgrade --install` の各引数が何を意味するか読む
4. まず 1 つだけ Helm で導入し、values の反映結果を確認する
5. Helm がどの namespace に何を作るかを観察する

おすすめの進め方:

1. `bash scripts/install-ingress-nginx.sh` を実行する
2. `helm list -A` で `ingress-nginx` release を見る
3. `helm get values ingress-nginx -n ingress-nginx` で values の反映結果を見る
4. `helm get manifest ingress-nginx -n ingress-nginx | head -n 80` で Chart から展開された manifest の一部を見る

`bash scripts/install-monitoring.sh` など他のスクリプトは、次の handson で必要になったときに追加で実行すれば十分です。

## install script の読み方

たとえば [scripts/install-ingress-nginx.sh](../scripts/install-ingress-nginx.sh) の中心は次の 1 行です。

```bash
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
	--namespace ingress-nginx \
	--create-namespace \
	-f manifests/helm/ingress-nginx-values.yaml
```

この 1 行を分解すると、次の意味になります。

- `helm upgrade --install`: すでにあれば更新し、無ければ新規 install する
- 最初の `ingress-nginx`: Release 名
- 次の `ingress-nginx/ingress-nginx`: Chart 名
- `--namespace ingress-nginx`: この Release を主に配置する namespace
- `--create-namespace`: namespace が無ければ作る
- `-f manifests/helm/ingress-nginx-values.yaml`: Chart に渡す設定ファイル

ここで大事なのは、同じ `ingress-nginx` という文字が 2 回出てきても役割が違うことです。最初は Release 名、後ろは `repo/chart` 形式の Chart 指定です。

初学者向けに言い換えると、`どの商品を、どの名前で、自分のクラスタに、どんな設定で入れるか` を 1 行で書いているのが Helm コマンドです。

## 実行コマンド例

```bash
helm repo list
bash scripts/install-ingress-nginx.sh
helm list -A
helm show values ingress-nginx/ingress-nginx | head -n 80
kubectl get pods -n ingress-nginx
helm get values ingress-nginx -n ingress-nginx
```

各コマンドの目的:

- `helm repo list`: 参照できる Helm repository を確認する
- `bash scripts/install-ingress-nginx.sh`: ingress-nginx Chart を install または upgrade する
- `helm list -A`: 作成された Release 名と namespace を確認する
- `helm show values ingress-nginx/ingress-nginx | head -n 80`: Chart の標準 values を確認する
- `kubectl get pods -n ingress-nginx`: Release によって実際の Pod が作られたか確認する
- `helm get values ingress-nginx -n ingress-nginx`: Release に適用された自分の values を確認する

このコマンドで確認するのはここ:

- `helm repo list`: ingress-nginx などの repo が登録済みかを見る
- `helm list -A`: `NAME`, `NAMESPACE`, `REVISION`, `STATUS`, `CHART` を見る
- `helm show values ingress-nginx/ingress-nginx | head -n 80`: chart の標準設定キーがどんな構造かを見る
- `kubectl get pods -n ingress-nginx`: 実際に release から Pod が作られたかを見る
- `helm get values ingress-nginx -n ingress-nginx`: 自分が override した値だけが出ているかを見る

出力で最低限見ること:

- `helm list -A` に release 名が出る
- namespace が想定どおりである
- `helm show values` で Chart が元々どんな設定項目を持つか分かる
- `helm get values` に自分が values ファイルで変えた設定が反映されている

`helm show values` と `helm get values` は似ていますが、見ている対象が違います。

- `helm show values`: Chart の標準設定を見る
- `helm get values`: 自分の Release に渡した設定を見る

ここを区別できると、`Chart 側のデフォルトが悪いのか`, `自分の values 上書きが悪いのか` を切り分けやすくなります。

## この回だけで押さえる整理

Helm で重要なのは、Chart、Release、values の 3 つを混ぜないことです。` upstream の複雑なアドオンを、values で上書きしながら再現可能に入れる仕組み ` として説明できるようになることが、この回のポイントです。

## 完了条件

- Chart、values、Release の違いを説明できる
- values ファイルで何を変更しているか説明できる
- Helm で導入したリソースがどこに作られたか確認できる
- Helm を使う対象と使わない対象の違いを言葉にできる

この回では `すべてのアドオンを入れ終える` 必要はありません。1 つの chart について `install script -> helm release -> 作成 resource` のつながりを追えれば十分です。

## 実務で見る観点

- 自作アプリと OSS アドオンで、管理方法を分ける判断ができるか
- Chart の upgrade 追従を考えて values の上書きを最小化できるか

## よくある失敗

Helm では `Chart の情報を見ているのか`, `Release の結果を見ているのか` を混同すると理解が崩れやすいです。show 系は設計図、get 系は自分の導入結果、と分けて読むと迷いにくくなります。

- Chart 名と Release 名を同じものだと思い込む
- `helm show values` と `helm get values` の違いが分からないまま読む
- values で過剰に上書きして将来の chart upgrade を難しくする
- 4 つの install script を全部同時に実行して、どの結果がどの chart 由来か分からなくなる
- helm install だけ成功して満足し、実際に何が作られたか見ない
- 生 YAML の方が読みやすい対象まで Helm 化してしまう

## 詰まったときの確認コマンド

```bash
helm list -A
helm show values ingress-nginx/ingress-nginx | head -n 80
helm get values ingress-nginx -n ingress-nginx
helm get manifest ingress-nginx -n ingress-nginx | head -n 80
kubectl get all -n ingress-nginx
```

読み方の目安:

- `helm show values`: Chart の標準設定を確認する
- `helm get values`: 自分が override した設定を確認する
- `helm get manifest`: その Release が最終的にどんな manifest を作ったか確認する

この 3 つを順に見ると、`元の設計図`, `自分の設定`, `最終結果` を切り分けられます。

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

Chart をもう少し具体的に言うと、Deployment、Service、ServiceAccount、Role、Ingress のような複数の manifest テンプレートをまとめた配布単位です。ingress-nginx や Argo CD のような OSS は、単一 YAML ではなく関連 resource 一式で動くことが多いため、Chart という形でまとめられています。初学者は `Chart = たくさんの YAML を安全に配るための箱` と理解すれば十分です。

一方で、自作アプリまで何でも Helm に載せればよいわけではありません。自作部分は構成が小さく、変更意図も明確にしたいので、生 YAML や Kustomize の方が読みやすいことが多いです。つまり、Helm は万能ではなく、複雑な既製品を扱うための道具として捉えるのが実務的です。

values で変える範囲を絞るのが重要なのは、上書き箇所が増えるほど Chart のアップグレードが難しくなるからです。必要最低限の差分に留めることで、将来の保守コストを抑えられます。ここには「今の便利さ」と「将来の保守」のトレードオフがあります。

このリポジトリで言うと、[scripts/install-argocd.sh](../scripts/install-argocd.sh) は `argo/argo-cd` という Chart を、[manifests/helm/argocd-values.yaml](../manifests/helm/argocd-values.yaml) で少しだけ上書きして使っています。ここでやっているのは、Argo CD を 0 から自作しているのではなく、既製品の Chart に対して `この環境では domain をこうしたい`, `Ingress は有効にしたい` という注文を渡しているだけです。この視点で script と values を見ると、Helm の役割がかなり掴みやすくなります。

## 初学者が最初につまずきやすいポイント

- Chart は `1 ファイル` ではなく、複数 manifest テンプレートのまとまりである
- Release は Chart そのものではなく、Chart を自分のクラスタへ展開した結果である
- values は最終 manifest ではなく、Chart に渡す入力値である
- `helm repo add` はまだ install ではなく、Chart の配布元を登録しているだけである

ここが曖昧だと、`values を見ているつもりで Release の状態を見ていた`, `Chart の default と自分の override を混同していた` という状態になりやすいです。

## Helm で管理する、しないの判断基準

`技術的に Helm Chart に載せられるか` と `運用上 Helm で管理すべきか` は別です。この回では、後者の判断ができることを重視します。

このリポジトリでは、次のように分けています。

- Helm で管理する例: ingress-nginx、Argo CD、kube-prometheus-stack、metrics-server
- Helm で管理しない例: web-app、user-service、item-service、postgres、各種 extension manifest

判断するときの軸は次の 5 つです。

1. 既製品か、自作か
既製品の OSS アドオンは Helm と相性が良いです。自作アプリは、生 YAML や Kustomize の方が構成意図を直接読みやすいことが多いです。

2. 関連 resource が多く、依存関係が複雑か
ServiceAccount、Role、Webhook、Ingress、Config など一式が必要な大きなアドオンは Helm の恩恵が大きくなります。Deployment と Service が数個の自作構成では Helm の必要性は下がります。

3. upstream Chart の upgrade に追従したいか
upstream が chart を整備している OSS は、その流れに乗る方が保守しやすいです。逆に、自作アプリを Helm 化すると、自分で chart 保守まで抱えることになります。

4. values の上書きで足りるか
少数の設定変更で済むなら Helm 向きです。テンプレート自体を大きく変え続けるなら、Helm の恩恵よりも保守コストが上回ることがあります。

5. 学習対象やレビュー対象として、resource をそのまま読みたいか
この教材ではここが重要です。web-app や user-service などの主役部分は、何が作られているかを直接読める方が学習効果が高いので Helm に寄せていません。

このリポジトリの実例に落とすと、[scripts/install-ingress-nginx.sh](../scripts/install-ingress-nginx.sh)、[scripts/install-monitoring.sh](../scripts/install-monitoring.sh)、[scripts/install-argocd.sh](../scripts/install-argocd.sh)、[scripts/install-metrics-server.sh](../scripts/install-metrics-server.sh) で入れているものは、`既製品で複雑で upstream Chart が強い` ので Helm 管理にしています。

一方で、[manifests/base/web-app](../manifests/base/web-app)、[manifests/base/user-service](../manifests/base/user-service)、[manifests/base/item-service](../manifests/base/item-service)、[manifests/base/postgres](../manifests/base/postgres) は、この教材で中身を理解してほしい対象なので、生 YAML と Kustomize を中心に管理しています。

1 行でまとめると、`既製品で複雑で upstream Chart が強いものは Helm、自作で読みやすさと差分意図が重要なものは生 YAML か Kustomize` と判断すると整理しやすいです。

## この回の宿題

- どこまで values で上書きし、どこから fork すべきか整理する
- Helm を使う対象と使わない対象を分ける基準を考える

## 宿題の考え方

values で上書きするか fork するかは、変更頻度と変更量を軸に考えると整理しやすいです。少数の設定変更で済むなら values で十分ですが、テンプレートそのものを大きく変え続けるなら fork の方が現実的な場合があります。ただし fork は将来の追従コストを増やすので、軽く決めてはいけません。

Helm を使う対象と使わない対象を分ける基準としては、既製品か、自作か、リソース数は多いか、アップグレードパスは整っているかを見るとよいです。宿題では、技術的に使えるかではなく、運用上どちらが長期的に楽かを基準に考えてください。

次は [handson12.md](handson12.md) で Kustomize を学びます。