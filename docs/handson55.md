# Handson 55

## テーマ

Stateful HA、replication、DB 運用判断を学ぶ。

## 今回のゴール

- StatefulSet があるだけで HA にならない理由を説明できる
- replication、failover、managed DB の違いを説明できる
- DB を Kubernetes 内で持つか外へ出すかの判断軸を説明できる

## この回で先に押さえる用語

- replication
- failover
- primary / replica
- managed database
- split brain

## 対応ファイル

- [stateful-ha-guide.md](stateful-ha-guide.md)
- [scripts/postgres-ha-review.sh](../scripts/postgres-ha-review.sh)

## この回で実際にやること

1. [stateful-ha-guide.md](stateful-ha-guide.md) を読む
2. `bash scripts/postgres-ha-review.sh` を実行して current PostgreSQL 構成を整理する
3. `単一 StatefulSet`, `replication 構成`, `managed DB` の違いを比較する
4. DB migration rollback が難しい理由を説明する

## 完了条件

- StatefulSet と HA の違いを説明できる
- replication と backup の役割差を説明できる
- managed DB を選ぶ理由を説明できる

## 実務で見る観点

- DB 障害時の復旧責任をどこまで自分たちが持つか
- failover の自動化と検証があるか
- スキーマ変更の rollback 方針があるか

## よくある失敗

この回の失敗は、HA を構成要素の数だけで判断すると起きやすいです。箇条書きは別々に見えても、背景には `切り替え条件`, `データ整合性`, `運用負荷` を一緒に見ていないことがあります。

- PVC があるから安全だと思い込む
- replication があるから backup 不要だと思う
- DB の運用負荷を見積もらず self-managed を選ぶ

## 学ぶポイント

- stateful workload の難しさは `保存` より `切り替え` と `整合性` にある
- backup、replication、failover は互いに代替ではない
- 実務では managed DB を選ぶ判断も技術力の一部である

## 詰まったときの確認ポイント

- StatefulSet と HA を同一視していないか
- replication と backup の役割を混同していないか
- failover 後の整合性をどう見るか考えられているか

## この回の後に必ずやること

1. 単一 StatefulSet で起こる弱点を 3 つ書く
2. self-managed と managed DB の判断軸を表で比較する
3. [stateful-ha-guide.md](stateful-ha-guide.md) を見て復旧責任の持ち方を整理する

## この回の宿題

- self-managed DB と managed DB の判断軸を整理する
- replication だけでは防げない障害を挙げる

次は [handson56.md](handson56.md) で multi-cluster と DR を学びます。