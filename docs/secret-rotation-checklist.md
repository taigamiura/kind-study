# Secret Rotation Checklist

このチェックリストは Secret や TLS 証明書を更新するときの最低限の確認項目です。

## Secret 更新前

- どの workload がその Secret を使うか分かっている
- 更新担当者と作業時間を決めている
- rollback 方法を決めている

## Secret 更新後

- 再起動が必要な Deployment を洗い出した
- rollout restart を実施した
- Pod の新旧が入れ替わったことを確認した
- エラー率や restart 増加がないことを確認した

## Certificate 更新時

- `bash scripts/cert-expiry-check.sh` を実施した
- Ready と残り期限を確認した
- Ingress の tls secret 名と一致している

## このチェックリストで学ぶこと

- 機密情報更新では値そのものより反映確認が重要なこと