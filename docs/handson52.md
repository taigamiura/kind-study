# Handson 52

## テーマ

CRD と Operator の仕組みを学ぶ。

## 今回のゴール

- CRD が `Kubernetes に新しい型を追加する` 仕組みだと説明できる
- controller / reconcile の考え方を説明できる
- cert-manager や Argo CD、Istio などを `Operator 的な世界` として見られる

## この回で先に押さえる用語

- CRD
- Operator
- Reconcile
- Finalizer
- OwnerReference

## 対応ファイル

- [crd-operator-guide.md](crd-operator-guide.md)
- [manifests/extensions/operator/widget-crd.yaml](../manifests/extensions/operator/widget-crd.yaml)
- [manifests/extensions/operator/widget-sample.yaml](../manifests/extensions/operator/widget-sample.yaml)
- [scripts/crd-observe.sh](../scripts/crd-observe.sh)

## この回で実際にやること

1. [crd-operator-guide.md](crd-operator-guide.md) を読む
2. sample CRD と custom resource を読む
3. `bash scripts/crd-observe.sh` を実行してクラスタ内の CRD を観察する
4. `desired state を誰が実現するか` を既存 add-on に当てはめる

## このコマンドで確認するのはここ

- `bash scripts/crd-observe.sh`: CRD 一覧、custom resource の種類、controller が管理していそうな resource 名を見る
- operator 観点では: CRD だけでなく、それを reconcile する controller が存在するかを確認する

## 完了条件

- CRD と built-in resource の違いを説明できる
- reconcile loop を説明できる
- finalizer が必要な理由を説明できる

## 実務で見る観点

- CRD 導入で API surface が増えることを理解しているか
- Operator 障害が add-on 障害に直結することを理解しているか
- custom resource の upgrade 互換を意識できるか

## よくある失敗

この回の失敗は、CRD や Operator を便利な自動化としてだけ見ると起きやすいです。箇条書きは別々に見えても、背景には `どこまでを宣言し, どこからを controller が補うか` の理解不足があります。

- CRD をただの YAML 追加だと思う
- controller がいない custom resource を apply して終わる
- finalizer で削除詰まりが起こる意味を理解しない

## 学ぶポイント


## 詰まったときの確認ポイント

- built-in resource と custom resource の差を説明できるか
- desired state を誰が実現するか言えるか
- finalizer や ownerReference の意味を説明できるか

## この回の後に必ずやること

1. この repo の CRD ベース add-on を書き出す
2. controller が止まったとき何が起きるか考える
3. [crd-operator-guide.md](crd-operator-guide.md) を読み直して reconcile を言語化する

## この回の宿題

- この repo で CRD ベースの add-on を 3 つ挙げる
- custom resource の運用リスクを 2 つ書く

次は [handson53.md](handson53.md) で autoscaling と cost を学びます。