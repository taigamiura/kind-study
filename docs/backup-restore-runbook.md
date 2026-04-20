# Backup Restore Runbook

この runbook は PostgreSQL の論理バックアップと復旧演習の最小手順です。目的は、`バックアップはある` を `復旧できる` に変えることです。

## 使う対象

- [scripts/postgres-backup.sh](../scripts/postgres-backup.sh)
- [scripts/postgres-restore.sh](../scripts/postgres-restore.sh)
- [manifests/base/postgres/statefulset.yaml](../manifests/base/postgres/statefulset.yaml)

## 手順

1. PostgreSQL Pod の状態確認
2. backup 実行
3. dump 保存先と取得時刻の確認
4. restore 実行
5. アプリ疎通確認

## 実行例

```bash
kubectl get pods -n infra -l app.kubernetes.io/name=postgres
bash scripts/postgres-backup.sh
bash scripts/postgres-restore.sh artifacts/postgres-backups/latest.sql
```

## 確認すること

- dump ファイル名に時刻が入っているか
- restore 後に PostgreSQL Pod が正常か
- user-service / item-service が DB へ接続できるか

## この runbook で学ぶこと

- DB 運用では restore 訓練が必須なこと
- RPO / RTO を意識して backup / restore を見ること