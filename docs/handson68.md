# Handson 68

## テーマ

Terraform と基盤 IaC を学ぶ。

## 今回のゴール

- manifest 管理と基盤 IaC の違いを説明できる
- plan、apply、state の意味を説明できる
- cluster と周辺資源をコードで管理する価値を理解できる

## この回で先に押さえる用語

- Terraform
- state file
- plan
- apply
- drift

## 対応ファイル

- [terraform-iac-guide.md](terraform-iac-guide.md)
- [infra/terraform/aws-eks-sample/main.tf](../infra/terraform/aws-eks-sample/main.tf)

## この回で実際にやること

1. [terraform-iac-guide.md](terraform-iac-guide.md) を読む
2. sample Terraform を見て VPC、IAM、EKS の依存関係を確認する
	sample は学習用の最小骨格なので、そのまま apply する前に subnet や IAM policy を実環境に合わせて補う前提で読む
3. GitOps と Terraform の役割差を整理する
4. state 管理と plan review の重要性を書き出す

## この回だけで押さえる整理

Terraform の本質は apply の手軽さではなく、差分を説明しながら基盤変更を再現できることにあります。この回では、manifest と IaC の責務差、state の危険性、plan review の重要性を 1 本で説明できるようになることがポイントです。

## 確認するとしたらどこを見るか

- Terraform では plan に何が作成・変更・削除されるか、state が何を真実として持つかを見る
- apply 前に差分が想定どおりか、意図しない destroy が含まれていないか確認する

## 完了条件

- Kubernetes manifest と Terraform の責務差を説明できる
- state file の重要性を説明できる
- plan review が必要な理由を説明できる

## 実務で見る観点

- cluster の外側を手作業で変更していないか
- state 管理が安全か
- plan を review せず apply していないか

## よくある失敗

この回の失敗は、IaC を `コードで apply できること` だけで捉えると起きやすいです。背景には `state と差分 review が Terraform の信頼性を支えている` という理解不足があります。

- plan を読まずに apply する
- state file を単なる作業ファイルとして雑に扱う
- GitOps と Terraform の責務を混同する


## 詰まったときの確認ポイント

- manifest と IaC の責務を混同していないか
- state file の危険性を理解しているか
- plan review を省略してよい理由が本当にあるか

## この回の後に必ずやること

1. Terraform で管理すべき対象と GitOps で管理すべき対象を分ける
2. state 管理の保護策を整理する
3. [terraform-iac-guide.md](terraform-iac-guide.md) と sample Terraform を見て差分 review 観点を補う

## この回の宿題

- Terraform で管理すべき対象を 10 個書く
- state file が危険になる条件を整理する

## 学ぶポイント

- GitOps だけでは基盤全体は再現できない
- Terraform は変更速度より変更の再現性と追跡性に効く
- state を軽く扱うと IaC 全体の信頼性が崩れる

## 学ぶポイントの解説

manifest を Git 管理していても、VPC や IAM や DNS が手作業なら、本番環境は完全には再現できません。実務では `どこまでを Kubernetes が管理し、どこからを IaC が管理するか` を切り分けることが重要です。

また Terraform は apply の便利さより、plan をレビューして差分を説明できることに価値があります。ここを理解しておくと、基盤変更の事故をかなり減らせます。

次は [handson69.md](handson69.md) で build engineering を学びます。