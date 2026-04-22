# Handson 38

## テーマ

RBAC と ServiceAccount で最小権限を設計する。

## 今回のゴール

- `人の権限` と `Pod の権限` を分けて考えられる
- ServiceAccount、Role、RoleBinding の関係を説明できる
- `動くから cluster-admin` を避ける発想を身につける

## この回で先に押さえる用語

- ServiceAccount: Pod の実行主体
- RBAC: 権限制御の仕組み
- Role: namespace 内の権限セット
- RoleBinding: Role と主体の結び付け
- Least Privilege: 必要最小限の権限

## 対応ファイル

- [rbac-design-guide.md](rbac-design-guide.md)
- [manifests/extensions/rbac/serviceaccount-app-reader.yaml](../manifests/extensions/rbac/serviceaccount-app-reader.yaml)
- [manifests/extensions/rbac/role-app-reader.yaml](../manifests/extensions/rbac/role-app-reader.yaml)
- [manifests/extensions/rbac/rolebinding-app-reader.yaml](../manifests/extensions/rbac/rolebinding-app-reader.yaml)
- [manifests/extensions/rbac/serviceaccount-app-deployer.yaml](../manifests/extensions/rbac/serviceaccount-app-deployer.yaml)
- [manifests/extensions/rbac/role-app-deployer.yaml](../manifests/extensions/rbac/role-app-deployer.yaml)
- [manifests/extensions/rbac/rolebinding-app-deployer.yaml](../manifests/extensions/rbac/rolebinding-app-deployer.yaml)
- [scripts/rbac-access-check.sh](../scripts/rbac-access-check.sh)

## この回で実際にやること

1. [rbac-design-guide.md](rbac-design-guide.md) を読み、`読むだけ`, `deploy できる`, `管理者` の違いを整理する
2. app-reader と app-deployer の ServiceAccount / Role / RoleBinding を読む
3. `bash scripts/rbac-access-check.sh apps app-reader get pods` で権限確認を行う
4. `必要な権限だけを付ける` と `困ったら広げる` の順番を理解する

## 完了条件

- ServiceAccount と人の kubectl 操作の違いを説明できる
- app-reader と app-deployer の権限差を説明できる
- cluster-admin を安易に使わない理由を説明できる

## 実務で見る観点

- CI、Argo CD、運用 Job に専用 ServiceAccount があるか
- namespace ごとに最小権限で閉じているか
- `書き込み権限が本当に必要か` を review できるか

## よくある失敗

この回の失敗は、権限を `とりあえず困らないように広く付ける` と起きやすいです。箇条書きは別々に見えても、背景には `本当に必要な権限は何か` を resource 単位で整理していないことがあります。

- 動かないから cluster-admin を付けて終わる
- 人の権限と Pod の権限が混ざる
- 読み取り専用で十分なのに update / patch を許可してしまう

## 学ぶポイント

- RBAC はセキュリティだけでなく事故防止にも効く
- ServiceAccount は workload ごとに分ける方が実務では安全である
- 最小権限は最初から完璧でなくても、広げすぎない設計が重要である

## 学ぶポイントの解説

実務クラスタでは、誰でも何でもできる状態が最も危険です。悪意がなくても、誤操作や誤実装で大きな影響が出ます。RBAC は攻撃対策だけでなく、日常運用の事故を減らすための設計です。

特に開発エンジニアは `とりあえず動かしたい` 気持ちから強い権限を付けがちですが、本番運用では逆です。必要最小限で始め、足りないなら狭く追加する方が安全です。

## この回の宿題

- user-service が Kubernetes API を触る場合に本当に必要な権限を考える
- `読み取りだけでよい処理` と `書き込みが必要な処理` を 3 つずつ挙げる

次は [handson39.md](handson39.md) で ResourceQuota と LimitRange を学びます。