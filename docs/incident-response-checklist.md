# Incident Response Checklist

このチェックリストは、障害を検知した最初の 10 分で行う最低限の確認です。

## 最初の 3 分

- 利用者影響があるかを確認する
- 影響範囲を 1 行で言う
- rollback や mitigation が必要か判断する

## 次の 5 分

- `bash scripts/cluster-ops-snapshot.sh` を実行する
- Pod、Event、restart、resource 使用量を見る
- team へ現状共有する

## 10 分以内に決めること

- すぐ戻すか
- Hold して観測を増やすか
- 誰が深掘りするか

## このチェックリストで学ぶこと

- 初動は順番が重要なこと