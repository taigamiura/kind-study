# Handson 49

## テーマ

Authentication、SSO、Audit の実務を学ぶ。

## 今回のゴール

- 認証と認可の違いを説明できる
- RBAC だけでなく `誰として入るか` の設計が必要だと理解する
- 監査ログがセキュリティだけでなく事故調査にも必要だと説明できる

## この回で先に押さえる用語

- Authentication
- Authorization
- OIDC
- Group Mapping
- Audit Log

## 対応ファイル

- [authentication-audit-guide.md](authentication-audit-guide.md)
- [manifests/extensions/auth/group-readonly-rolebinding.yaml](../manifests/extensions/auth/group-readonly-rolebinding.yaml)
- [scripts/auth-audit-check.sh](../scripts/auth-audit-check.sh)

## この回で実際にやること

1. [authentication-audit-guide.md](authentication-audit-guide.md) を読み、RBAC と認証の関係を整理する
2. group 単位の RoleBinding 例を読む
3. `bash scripts/auth-audit-check.sh` を実行して現在の context と auth can-i の観察ポイントを確認する
4. `個人ユーザー`, `CI`, `Argo CD`, `運用 bot` をどう分けるべきか整理する

## このコマンドで確認するのはここ

- `bash scripts/auth-audit-check.sh`: 現在の kube context、`auth can-i` の許可/拒否、誰として操作している前提かを見る
- audit 観点では: 誰の操作か後から追える主体分離になっているか確認する

## 完了条件

- Authentication と Authorization の違いを説明できる
- group ベース運用が必要な理由を説明できる
- audit log の用途を 2 つ以上説明できる

## 実務で見る観点

- 個人アカウント直結の強権限運用になっていないか
- group 単位で権限が整理されているか
- 監査ログの保存場所と保持期間が決まっているか

## よくある失敗

この回の失敗は、認証・認可・監査を 1 つの塊として捉えると起きやすいです。箇条書きは別々に見えても、背景には `誰が入るか`, `何ができるか`, `後から追えるか` を分けて見ていないことがあります。

- RBAC を設定すれば認証も終わったと思う
- 個人 cert や固定 token を放置する
- 誰が本番を触ったか追えない

## 学ぶポイント


## 詰まったときの確認ポイント

- 認証と認可を混同していないか
- 個人、CI、GitOps controller が同じ主体になっていないか
- 誰が本番を触ったか後から追えるか

## この回の後に必ずやること

1. 本番操作主体を `人`, `CI`, `controller`, `bot` に分けて書く
2. group ベースで整理できていない権限がないか確認する
3. audit log に残したい項目を最小 5 つ書く

## この回の宿題

- 開発者、運用者、CI、Argo CD の認証主体を整理する
- 本番 kubectl 利用で最低限残したい監査項目を挙げる

次は [handson50.md](handson50.md) で Policy as Code を学びます。