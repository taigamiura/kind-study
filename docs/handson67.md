# Handson 67

## テーマ

Managed Kubernetes とクラウド周辺設計を学ぶ。

## 今回のゴール

- kind と managed Kubernetes の違いを説明できる
- Kubernetes の外側にある VPC、IAM、LB、NAT、private network の重要性を理解する
- `クラスタを作る` と `本番で安全に置く` の差を説明できる

## この回で先に押さえる用語

- Managed Kubernetes
- VPC
- IAM
- private cluster
- egress

## 対応ファイル

- [managed-kubernetes-guide.md](managed-kubernetes-guide.md)
- [infra/terraform/aws-eks-sample/main.tf](../infra/terraform/aws-eks-sample/main.tf)

## この回で実際にやること

1. [managed-kubernetes-guide.md](managed-kubernetes-guide.md) を読む
2. sample Terraform を見て cluster の外に必要な資源を確認する
3. kind と EKS / GKE / AKS の責務差を整理する
4. `network`, `identity`, `ingress`, `egress`, `audit` の観点で本番要件を洗い出す

## この回だけで押さえる整理

managed Kubernetes を実務で使うときは、cluster の内側より先に周辺クラウド資源を見ます。この回では、kind では見えなかった VPC、IAM、LB、NAT、DNS、監査境界が本番設計の主要論点になると説明できれば十分です。

## 確認するとしたらどこを見るか

- managed Kubernetes では cluster 内より先に VPC、IAM、LB、NAT、DNS など周辺資源を見る
- private 化した場合に運用経路、監査経路、egress 経路が成立するか確認する

## 完了条件

- managed Kubernetes でクラウド側へ依存する要素を説明できる
- VPC と IAM の重要性を説明できる
- private cluster の利点と難しさを説明できる

## 実務で見る観点

- cluster の外側にあるセキュリティ境界を理解しているか
- LB、NAT、WAF、DNS を Kubernetes だけの問題だと思っていないか
- IAM と ServiceAccount 連携を分けて考えられるか

## よくある失敗

この回の失敗は、managed Kubernetes を `control plane の運用が不要になる仕組み` とだけ捉えると起きやすいです。背景には `周辺ネットワークと権限設計こそ実務の主要論点` という視点の不足があります。

- cluster さえ作れば本番要件の大半を満たせると思う
- private cluster 化した後の運用経路や監査経路を考えない
- IAM と Kubernetes RBAC の責務を混同する


## 詰まったときの確認ポイント

- Kubernetes の責務とクラウドの責務を分けられているか
- network と identity を manifest だけで解決できると思っていないか
- private cluster にしたときの運用影響を考えられているか

## この回の後に必ずやること

1. kind では見えなかったクラウド依存を列挙する
2. 本番に必要な周辺資源を `network`, `identity`, `edge`, `audit` に分ける
3. [managed-kubernetes-guide.md](managed-kubernetes-guide.md) を見て抜けている境界条件を補う

## この回の宿題

- kind と managed Kubernetes の責務差を表で整理する
- 本番で cluster 以外に必要なクラウド資源を列挙する

## 学ぶポイント

- 実務では Kubernetes そのものより周辺クラウド設計で詰まりやすい
- managed Kubernetes は運用負荷を減らすが、責務が消えるわけではない
- network と identity を先に整理できると本番事故を減らしやすい

## 学ぶポイントの解説

kind では cluster の中に意識が集中しますが、本番では VPC、IAM、LB、DNS、egress の設計が同じくらい重要です。ここを曖昧にすると、アプリが正しくても通信できない、監査に耐えない、権限が強すぎるといった問題が起きます。

managed Kubernetes は control plane の運用を軽くしてくれますが、責務の中心が `クラスタ内部` から `周辺設計をどう安全に整えるか` へ移るだけです。この視点を持てると、ローカル学習から実務への段差がかなり小さくなります。

次は [handson68.md](handson68.md) で Terraform を学びます。