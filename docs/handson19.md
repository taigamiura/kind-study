# Handson 19

## テーマ

PostgreSQL のバックアップ、復旧、DR の基本を学ぶ。

## 今回のゴール

- バックアップを取る理由を `障害時の最後の保険` として説明できる
- kind 上でも論理バックアップと復旧演習ができる
- `バックアップがある` と `復旧できる` は別だと理解できる

## この回で先に押さえる用語

- Backup: データの退避
- Restore: 退避データから戻すこと
- RPO: どこまでのデータ損失を許容するか
- RTO: どのくらいで復旧すべきか
- DR: Disaster Recovery の略。大きな障害から戻す考え方

用語に迷ったら [glossary.md](glossary.md) を見ながら、特に StatefulSet、PVC、Backup、Restore を整理してください。

## 対応ファイル

- [backup-restore-runbook.md](backup-restore-runbook.md)
- [manifests/base/postgres/statefulset.yaml](../manifests/base/postgres/statefulset.yaml)
- [manifests/base/postgres/service.yaml](../manifests/base/postgres/service.yaml)
- [manifests/base/postgres/secret.yaml](../manifests/base/postgres/secret.yaml)
- [scripts/postgres-backup.sh](../scripts/postgres-backup.sh)
- [scripts/postgres-restore.sh](../scripts/postgres-restore.sh)

## この回で実際にやること

1. PostgreSQL Pod の状態と接続方法を確認する
2. `bash scripts/postgres-backup.sh` で論理バックアップを取得する
3. 取得した dump を手元に残し、いつ取ったものか確認する
4. `bash scripts/postgres-restore.sh <dump-file>` で復旧演習を行う
5. どのくらいの時間で戻せたかを測り、RTO を意識する

## 実行コマンド例

```bash
kubectl get pods -n infra -l app.kubernetes.io/name=postgres
bash scripts/postgres-backup.sh
ls -1 artifacts/postgres-backups
bash scripts/postgres-restore.sh artifacts/postgres-backups/latest.sql
```

## 完了条件

- dump ファイルが artifacts 配下へ保存されている
- 復旧コマンドが通ることを確認した
- `バックアップ取得手順` と `復旧手順` を別々に説明できる
- 障害時に `最後の正常 dump はどこか` を探せる状態になっている

## 実務で見る観点

- backup の取得頻度が業務の RPO に合っているか
- restore 演習を定期的にやっているか
- backup ファイルの保存先と保持期間が決まっているか

## よくある失敗

- backup を取っただけで安心し、restore を試していない
- dump の保存先や取得時刻が曖昧で、障害時に使えない
- アプリ停止なしで戻せると思い込んで整合性を崩す

## 詰まったときの確認コマンド

```bash
kubectl get pods -n infra -l app.kubernetes.io/name=postgres
kubectl exec -n infra statefulset/postgres -- printenv | grep POSTGRES
ls -R artifacts/postgres-backups
```

## 障害シナリオと復旧の考え方

想定シナリオ:

- 誤った migration で一部データを壊した
- PostgreSQL Pod は動いているが、データ内容が壊れている

復旧の考え方:

- まず PVC 障害と論理データ破損を分けて考える
- 直近 backup の時刻を確認し、失ってよいデータ量を把握する
- restore 後にアプリ接続確認までやって初めて復旧完了とする

## 学ぶポイント

- stateful workload は `再起動できる` だけでは運用できない
- backup は取得手順より restore 手順の方が重要である
- DR は大規模な仕組みより、まず `戻せる` 実感から始まる

## 学ぶポイントの解説

PostgreSQL を Kubernetes 上で動かしても、データ運用の本質は変わりません。PVC があることで Pod の再作成には耐えやすくなりますが、論理的にデータを壊した場合は PVC だけでは救えません。そのため、実務では `ストレージが残ること` と `データを戻せること` を分けて考えます。

backup の取得は比較的簡単ですが、restore は事前準備がないと失敗しやすいです。誰が、どの dump を、どの順番で戻し、戻したあとに何を確認するかまで決まって初めて運用になります。この回ではそこまでを練習します。

## この回の宿題

- 自分のシステムで許容できる RPO / RTO を 1 つ決める
- backup ファイルの保存先、保持期間、復旧担当を紙に書き出す

次は [handson20.md](handson20.md) で Secret と TLS 証明書の更新運用を学びます。