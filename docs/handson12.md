# Handson 12

## テーマ

Kustomize で base と overlay を使い分ける。

## 今回のゴール

- base と overlay の責務を説明できる
- ローカル学習用の overlay をどう組むか理解できる
- GitOps で Kustomize が相性良い理由を説明できる

## この回で先に押さえる用語

- Kustomize: YAML を組み立てる仕組み
- base: 共通設定の土台
- overlay: 環境差分をのせる層
- Manifest: Kubernetes resource を宣言する YAML

用語に迷ったら [glossary.md](glossary.md) の Kustomize、Manifest を先に確認してください。

## この回の前提

- `kubectl kustomize` は `最終的にどんな YAML になるかを見る` コマンドで、まだ apply はしない
- `kubectl apply -k` は Kustomize の結果をそのままクラスタへ適用するコマンドである
- 初学者は `いきなり apply -k` する前に、先に `kubectl kustomize` で build 結果を見る癖を付けた方が安全

この回は `Kustomize を使えるようになる` だけでなく、`apply 前に build を読む` 流れを身につける回です。

## このリポジトリの構成

- [manifests/base/namespaces/kustomization.yaml](../manifests/base/namespaces/kustomization.yaml)
- [manifests/base/postgres/kustomization.yaml](../manifests/base/postgres/kustomization.yaml)
- [manifests/base/user-service/kustomization.yaml](../manifests/base/user-service/kustomization.yaml)
- [manifests/base/item-service/kustomization.yaml](../manifests/base/item-service/kustomization.yaml)
- [manifests/base/web-app/kustomization.yaml](../manifests/base/web-app/kustomization.yaml)
- [manifests/overlays/local/kustomization.yaml](../manifests/overlays/local/kustomization.yaml)
- [manifests/overlays/local/infra/kustomization.yaml](../manifests/overlays/local/infra/kustomization.yaml)
- [manifests/overlays/local/apps/kustomization.yaml](../manifests/overlays/local/apps/kustomization.yaml)
- [manifests/overlays/local/observability/kustomization.yaml](../manifests/overlays/local/observability/kustomization.yaml)

## この回で実際にやること

1. base と overlays/local の kustomization.yaml を順に開く
2. local overlay がどの base をまとめているか確認する
3. local overlay を build して、最終的にどんな YAML になるかを見る
4. `kubectl kustomize` と `kubectl apply -k` の役割の違いを整理する
5. どの設定が base にあり、どの設定が overlay にあるかを分類する

## 実行コマンド例

```bash
kubectl kustomize manifests/overlays/local
kubectl kustomize manifests/overlays/local/infra
kubectl kustomize manifests/overlays/local/apps
kubectl kustomize manifests/overlays/local/observability
kubectl apply -k manifests/overlays/local/apps
```

各コマンドの目的:

- `kubectl kustomize manifests/overlays/local`: local 全体の最終 YAML を組み立てて確認する
- `kubectl kustomize manifests/overlays/local/infra`: infra 側だけの build 結果を確認する
- `kubectl kustomize manifests/overlays/local/apps`: apps 側だけの build 結果を確認する
- `kubectl kustomize manifests/overlays/local/observability`: observability 側だけの build 結果を確認する
- `kubectl apply -k manifests/overlays/local/apps`: build 結果をそのまま apps 側へ反映する

このコマンドで確認するのはここ:

- `kubectl kustomize ...`: `kind`, `metadata.name`, `namespace`, image, replicas などが期待どおりに展開されているかを見る
- `kubectl apply -k manifests/overlays/local/apps`: apply 後に apps 側 resource が増える前提で使う。反映後は `kubectl get ...` で結果を見る

読み分けの目安:

- `kubectl kustomize ...`: 適用前に最終 YAML を見る
- `kubectl diff -k ...`: 今のクラスタとの差分を見る
- `kubectl apply -k ...`: build した結果をクラスタへ反映する

## 完了条件

- local overlay が base を束ねた最終構成だと理解できる
- どの差分を overlay に置くべきか説明できる
- kustomize build の結果を読み、適用前に内容確認できる
- `kubectl kustomize` と `kubectl apply -k` の違いを説明できる

## 実務で見る観点

- 環境差分をファイルのコピーではなく宣言的な overlay として管理できるか
- どの差分が環境依存で、どの差分がアプリ本質かを切り分けられるか

## よくある失敗

Kustomize では `組み立てた` と `反映した` を分けて考えないと学習が崩れます。まず build で中身を読み、その後に diff や apply へ進む順番を守ると、想定外の変更を入れにくくなります。

- `kubectl kustomize` したので apply も終わったと思い込む
- base を直接書き換えて環境差分とアプリ本体の責務を混ぜる
- overlay を増やしたのに build 結果を見ず、想定外の YAML を apply する
- Helm と Kustomize の役割分担が曖昧で構成が二重管理になる

## 詰まったときの確認コマンド

```bash
kubectl kustomize manifests/overlays/local | head -n 80
kubectl kustomize manifests/overlays/local/apps | head -n 80
kubectl kustomize manifests/overlays/local/infra | head -n 80
kubectl diff -k manifests/overlays/local
```

## 障害シナリオと復旧の考え方

想定シナリオ:

- local では動くが production overlay だけ設定がずれて壊れる
- base を直接修正して複数環境に思わぬ差分が出る

復旧の考え方:

- まず overlay の build 結果を比較する
- 問題が base にあるか overlay にあるかを切り分ける
- 環境差分を base に戻していないか確認する

## レビュー観点と運用判断ポイント

- 差分の責務が base と overlay で明確に分かれているか
- build 結果をレビュー対象に含めても理解できる構成か
- 環境追加時にコピペではなく再利用できる形か

## 模擬インシデント演習

演習内容:

- production overlay だけ replica 数や image tag がずれて障害になった状況を想定する

考えること:

- 問題が base にあるのか overlay にあるのかをどう切り分けるか
- build 結果比較をどの段階で使うか

## レビューコメント例

- 「環境差分が base 側に混ざっているので、後から overlay を増やすと保守が厳しくなります。差分責務を分けたいです。」
- 「apply 前に build 結果を確認する流れが入っているのは実務的です。review でも最終 YAML を意識しやすくなります。」

## 目的

- 共通部分は base、環境差分は overlay に寄せる

## 実務上のメリット

- ステージングと本番の差分を追いやすい
- Argo CD と組み合わせやすい
- 小さな差分だけレビューすればよくなる

## 学ぶポイント

- image や replica 数だけ違うなら overlay で吸収する
- アプリそのものの責務は base に残す
- namespace をまたいでも整理できる

## 学ぶポイントの解説

Kustomize の価値は、同じアプリを複数環境で運用するときに差分だけを管理できることです。base にはアプリの本質的な構成を置き、local や production のような環境ごとの差だけを overlay に置きます。これにより、同じ YAML をコピペして増殖させる状態を避けられます。

ここで重要なのは、「何が本質で、何が環境差分か」を見極めることです。アプリ名、ポート、基本的なコンテナ構成は base に残し、replica 数、image tag、ノード配置など環境依存の要素を overlay に寄せるのが自然です。この切り分けが曖昧だと、Kustomize を使っていても構成は散らかります。

もう 1 つ重要なのは、`build と apply を分けて考える` ことです。`kubectl kustomize` は最終 YAML の確認で、`kubectl apply -k` はその結果をクラスタに反映する操作です。この差を曖昧にしたまま進むと、`見ただけなのか、反映したのか` が自分でも分からなくなります。初学者ほど、まず build、次に diff、最後に apply の順で確認する方が事故が減ります。

Argo CD と相性が良い理由もここにあります。Git 上の overlay は、その環境に適用すべき最終的な構成を宣言できます。実務では、「何を共通化し、何を環境ごとに変えるか」を明確にできる人ほど、構成管理が安定します。

## この回の宿題

- local overlay に何を置き、本番 overlay では何を変えるか考える
- Helm と Kustomize をどう併用するか整理する

## 宿題の考え方

local overlay と本番 overlay の違いを考えるときは、可用性、コスト、接続先、公開方法の差を思い浮かべてください。ローカルでは replica 数を少なくし、公開方法も簡素化できますが、本番ではより厳密なリソース制御や監視設定が必要になるはずです。宿題では、その差を列挙するだけでなく、なぜ差が必要なのかを説明してみてください。

Helm と Kustomize の併用は、競合ではなく役割分担で考えると整理しやすいです。一般に OSS アドオンは Helm、自作アプリは Kustomize という分け方が自然です。宿題では、自分たちのシステム全体を見たときに、どこをどちらで管理すると保守しやすいかを考えてください。

次は [handson13.md](handson13.md) で HPA を学びます。