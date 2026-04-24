# Handson 3

## テーマ

Namespace 設計と責務分離を学ぶ。

## 今回のゴール

- Namespace を分ける目的を説明できる
- この環境に適した Namespace 設計を理解できる
- 監視、基盤、アプリ、GitOps を論理分離する意味を理解できる

## この回で先に押さえる用語

- Namespace: リソースを論理的に分ける単位
- Resource: Kubernetes が管理する対象全般
- GitOps: Git を正として変更管理する運用
- Observability: システム状態を観測しやすくする考え方

用語に迷ったら [glossary.md](glossary.md) の Namespace、Resource、GitOps を先に確認してください。

## 推奨 Namespace

- infra
- apps
- observability
- gitops

## なぜこの 4 分割なのか

目的:

- リソースの責務境界を明確にする
- 後から RBAC や NetworkPolicy を足しやすくする

実務上のメリット:

- 運用担当とアプリ担当の分離に発展しやすい
- トラブル時に見る範囲をすぐ絞れる

## 作業イメージ

```bash
kubectl create namespace infra
kubectl create namespace apps
kubectl create namespace observability
kubectl create namespace gitops
kubectl get namespaces
```

対応 manifest:

- [manifests/base/namespaces/namespaces.yaml](../manifests/base/namespaces/namespaces.yaml)
- [manifests/base/namespaces/kustomization.yaml](../manifests/base/namespaces/kustomization.yaml)

## この回で実際にやること

1. Namespace 用 manifest の中身を開いて、どの namespace が作られるか確認する
2. Namespace をクラスタへ apply する
3. 作成された namespace を一覧で確認する
4. それぞれの namespace に何を置く予定かを言葉にする

## 実行コマンド例

```bash
kubectl apply -k manifests/base/namespaces
kubectl get namespaces
kubectl describe namespace apps
kubectl describe namespace infra
```

各コマンドの目的:

- `kubectl apply -k manifests/base/namespaces`: namespace 定義をまとめて作成する
- `kubectl get namespaces`: 期待した namespace が実際に作られたか一覧で確認する
- `kubectl describe namespace apps`: apps の用途や付与情報を個別に確認する
- `kubectl describe namespace infra`: infra の用途や付与情報を個別に確認する

このコマンドで確認するのはここ:

- `kubectl get namespaces`: `STATUS` が `Active` か、必要な namespace 名がそろっているかを見る
- `kubectl describe namespace apps`: `Labels`, `Annotations`, `Resource Quotas`, `Limit Ranges` の有無を見る
- `kubectl describe namespace infra`: apps と同様に namespace 単位の付与情報を見る

## この回だけで押さえる整理

Namespace 設計では、分けること自体が目的ではなく、責務と影響範囲を分けることが目的です。apps、infra、observability、gitops を分ける理由を `変更頻度`, `権限`, `障害時の見方` の 3 軸で説明できれば十分です。

## 完了条件

- apps、infra、observability、gitops、ingress-nginx が作成されている
- 自分の言葉で「どの namespace に何を置くか」を説明できる

## 実務で見る観点

- namespace が権限、監視、GitOps の管理単位になり得ると理解しているか
- 追加のサービスが来たときに、既存 namespace に入れるか新設するか判断できるか

## よくある失敗

この回の失敗は、`とりあえず動けばよい` で分割基準を後回しにしたときに起きやすいです。namespace は後から整理するほど移行コストが上がるので、最初に役割ベースで切る方が学習でも実務でも安定します。

- default namespace に一旦全部入れてから後で分けようとする
- 役割ではなくサービス名ベースで namespace を細かく分けすぎる

## 詰まったときの確認コマンド

```bash
kubectl get namespaces
kubectl describe namespace apps
kubectl api-resources --namespaced=true | head
```

## 障害シナリオと復旧の考え方

想定シナリオ:

- リソースは作られているが、どこにあるか分からず調査に時間がかかる
- 運用担当と開発担当で責任範囲が曖昧になり、変更の窓口が混乱する

復旧の考え方:

- namespace ごとに責務を明文化する
- 調査時は namespace 単位で対象を絞って確認する

## レビュー観点と運用判断ポイント

- namespace 分割は役割ベースになっているか
- RBAC や NetworkPolicy の追加を前提にしても破綻しないか
- 細かく分けすぎて運用負荷を上げていないか

## 模擬インシデント演習

演習内容:

- 新しい batch-job を追加したいが、どの namespace に置くべきかチームで意見が割れている状況を想定する

考えること:

- 責務、権限、監視、GitOps の同期単位の観点からどう判断するか

## レビューコメント例

- 「namespace の分割理由が役割ではなく機能名寄りに見えるので、責務単位で整理し直した方が RBAC と相性が良いです。」
- 「default namespace を避ける理由が弱いので、調査性と責任分界の観点を補足したいです。」

## 観察ポイント

- Namespace は物理分離ではなく論理分離であること
- 名前衝突の防止だけが目的ではないこと

## この回で理解すべきこと

- namespace default に全部置かない理由
- なぜ postgres は apps ではなく infra 側に置く設計が自然か

## 学ぶポイントの解説

Namespace は、Kubernetes の中で責務を分けて考えるための基本単位です。初学者は名前の衝突を防ぐための機能だと捉えがちですが、実務ではそれだけではありません。どのチームがどのリソースを責任持って管理するか、監視や権限をどこで分けるか、障害時にどこを見ればよいかを整理するための単位です。

この学習で infra、apps、observability、gitops に分けるのは、後で登場する RBAC、NetworkPolicy、Argo CD と自然につなげるためです。たとえば PostgreSQL を apps に置くと、アプリと基盤の責務が混ざります。DB はアプリが利用する重要な基盤なので、アプリケーションのリリースサイクルと切り離して考えた方が実務では安全です。

ここで覚えておきたいのは、Namespace を細かく切れば良いわけではないということです。初期設計では、責務が明確になり、運用が複雑になりすぎないバランスが大切です。Kubernetes では、分ける理由があるかを常に問い直す必要があります。

## この回の宿題

- user-service と item-service を別 namespace に分けない理由を考える
- 逆に本番で分けるなら、どんな条件があるか考える

## 宿題の考え方

この宿題では、分けるか分けないかを感覚で決めないことが重要です。user-service と item-service は機能としては別ですが、学習段階では同じアプリケーション群として扱う方が理解しやすく、運用も簡単です。監視、Ingress、Argo CD の管理単位も揃えやすいため、まずは apps にまとめるのが自然です。

一方で本番では、組織が別、権限管理を分けたい、機密性が違う、リリース頻度が大きく異なる、といった条件があるなら Namespace を分ける価値があります。宿題では、「機能が違うから分ける」ではなく、「運用上どんな差があると分ける必要が出るか」を基準に考えてください。

次は [handson4.md](handson4.md) で Ingress を学びます。