# Handson 3

## テーマ

Namespace 設計と責務分離を学ぶ。

## 今回のゴール

- Namespace を分ける目的を説明できる
- この環境に適した Namespace 設計を理解できる
- 監視、基盤、アプリ、GitOps を論理分離する意味を理解できる

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

## 観察ポイント

- Namespace は物理分離ではなく論理分離であること
- 名前衝突の防止だけが目的ではないこと

## この回で理解すべきこと

- namespace default に全部置かない理由
- なぜ postgres は apps ではなく infra 側に置く設計が自然か

## この回の宿題

- user-service と item-service を別 namespace に分けない理由を考える
- 逆に本番で分けるなら、どんな条件があるか考える

次は [handson4.md](handson4.md) で Ingress を学びます。