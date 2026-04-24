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

## この回だけで押さえる整理

CRD は `Kubernetes に新しい API の型を増やす` 仕組みで、Operator は `その型を見て実際の状態へ近づける controller` です。つまり YAML を apply しただけでは終わらず、裏で reconcile loop が走って初めて desired state が実現されます。

ここで重要なのは、custom resource 自体は `宣言` に過ぎない点です。controller が止まれば、その宣言は置かれていても状態は更新されません。cert-manager、Argo CD、Istio を `Operator 的な仕組み` として見られるようになると、この回の理解が一気に深まります。

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

- CRD は型の追加、Operator はその型を実現する自動化であり、役割が違う
- custom resource は built-in resource より運用依存が強く、controller 停止の影響を受けやすい
- finalizer や ownerReference を理解すると、削除や従属関係の詰まり方が読める

## 学ぶポイントの解説

Deployment や Service は Kubernetes 本体が意味を知っている built-in resource ですが、custom resource はそうではありません。意味を与えるのは controller 側です。だから CRD を増やすということは、API surface を増やすだけでなく、新しい運用責務を増やすことでもあります。

また、finalizer は削除前に片付けたい外部処理があるときに使われます。そのため controller が止まると削除が詰まることがあります。ここまで理解できると、CRD を `便利そうな YAML` ではなく、実際に運用コストを持つ仕組みとして見られるようになります。


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