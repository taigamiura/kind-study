# Handson 5

## テーマ

PostgreSQL の永続化を学ぶ。

## 今回のゴール

- StatefulSet を使う理由を説明できる
- PVC とデータ永続化の関係を理解できる
- Secret に認証情報を置く理由を説明できる

## 推奨リソース

- StatefulSet
- PersistentVolumeClaim
- Service
- Secret

## なぜ Deployment ではなく StatefulSet なのか

目的:

- Pod 名やストレージの対応関係を安定させる

実務上のメリット:

- 再起動や再配置が発生しても、永続データを扱いやすい
- DB のような stateful workload を安全に設計しやすい

## この回で観察したいこと

- Pod を消しても DB データが残るか
- PVC が作成されているか
- Service 名で DB に到達できるか

## 学ぶポイント

- stateful workload と stateless workload の違い
- Secret と ConfigMap の使い分け
- バックアップと復旧は別のテーマであること

## 実務上の注意

- 本番ではマネージド DB や Operator を使うことも多い
- ただし学習では StatefulSet を知る価値が大きい

## この回の宿題

- Pod が消えてもデータが残る設計を言葉で説明する
- DB 用 Secret を漏らしたときの影響を整理する

次は [handson6.md](handson6.md) で API を配置します。