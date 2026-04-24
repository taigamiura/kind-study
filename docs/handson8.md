# Handson 8

## テーマ

Ridgepole による DB スキーマ運用を学ぶ。

## 今回のゴール

- スキーマをコード管理する意味を説明できる
- Ridgepole を Job または CI で流す考え方を理解できる
- アプリのデプロイとスキーマ変更の関係を整理できる

## この回で先に押さえる用語

- Schema Migration: DB スキーマ変更を安全に進める考え方
- Ridgepole: schema-as-code のためのツール
- Job: 一度実行して完了する処理向け resource
- CI: 変更を継続的に検証する仕組み

用語に迷ったら [glossary.md](glossary.md) の Schema Migration、Ridgepole、Manifest を先に確認してください。

## この回の前提

- PostgreSQL の Pod が起動していて、`postgres-secret` が参照できる状態である
- Ridgepole Job は `1 回実行して終わる Job` なので、Completed 後に同じ manifest をもう一度 apply しても自動では再実行されない
- そのため `再実行したいときは Job を消してから apply し直す` という操作が必要になる

この回は `apply したのに何も起きない` で詰まりやすいです。特に 2 回目以降は、Job がすでに Completed だから動かないだけ、ということがあります。

## 目的

- 手動 SQL ではなく、再現性のある DB 変更フローを学ぶ

## 実務上のメリット

- 環境差分事故を減らせる
- DB 変更もレビュー対象にできる
- アプリ配備とスキーマ配備の依存関係を整理できる

## 学ぶポイント

- Schemafile を Git で管理する
- 適用は Job または CI から行う
- rollback はアプリより慎重に考える必要がある

## 最初に理解したいこと

- migration をアプリ起動時に自動実行するか
- schema apply を手動または CI に分けるか
- 破壊的変更は 1 回で出さない方が安全なこと

対応 manifest:

- [manifests/base/ridgepole/configmap.yaml](../manifests/base/ridgepole/configmap.yaml)
- [manifests/base/ridgepole/job.yaml](../manifests/base/ridgepole/job.yaml)

## この回で実際にやること

1. PostgreSQL Pod と Secret が先にそろっているか確認する
2. Ridgepole 用 ConfigMap を開いて Schemafile の内容を読む
3. Job manifest を開いて、どの image と command で schema apply しているか確認する
4. Ridgepole Job を apply する
5. Job の完了とログを確認する
6. PostgreSQL にテーブルが作られた想定で、スキーマ変更をコード管理する意味を整理する

## 実行コマンド例

```bash
kubectl get pods -n infra
kubectl get secret postgres-secret -n infra
kubectl apply -k manifests/base/ridgepole
kubectl get job -n infra
kubectl logs job/ridgepole-apply -n infra
kubectl describe job ridgepole-apply -n infra
```

各コマンドの目的:

- `kubectl get pods -n infra`: PostgreSQL 側が先に起動しているか確認する
- `kubectl get secret postgres-secret -n infra`: Ridgepole Job が参照する接続情報 Secret の存在を確認する
- `kubectl apply -k manifests/base/ridgepole`: Schemafile を適用する Job を作成する
- `kubectl get job -n infra`: Job が作成されて進行しているか確認する
- `kubectl logs job/ridgepole-apply -n infra`: schema apply の成否をログで確認する
- `kubectl describe job ridgepole-apply -n infra`: Job のイベントや失敗理由を確認する

このコマンドで確認するのはここ:

- `kubectl get pods -n infra`: postgres Pod が `Running` かを見る
- `kubectl get secret postgres-secret -n infra`: Secret 名が存在するかだけでなく、参照先が合っている前提を確認する
- `kubectl get job -n infra`: `COMPLETIONS`, `DURATION`, `AGE` を見る
- `kubectl describe job ridgepole-apply -n infra`: `Pods Status`, `Events` を見て失敗原因を確認する

もう一度試したいときは次を使います。

```bash
kubectl delete job ridgepole-apply -n infra
kubectl apply -k manifests/base/ridgepole
```

再実行コマンドの目的:

- `kubectl delete job ridgepole-apply -n infra`: Completed 済み Job をいったん消して再実行可能にする
- `kubectl apply -k manifests/base/ridgepole`: Job を作り直して再度 schema apply を試す

## この回だけで押さえる整理

Ridgepole の学習ポイントは、DB スキーマ変更を手作業でなく再現可能な手順として扱うことです。アプリ deploy と schema apply を分け、何を Job で一度だけ走らせるのかを説明できれば、この回の目的は達成です。

## 完了条件

- ridgepole-apply Job が Completed になっている
- logs から schema apply が実行されたことを確認できる
- Schemafile を変更すると DB 構造も変わる、という流れを説明できる
- `Completed の Job は apply だけでは再実行されない` と説明できる

## 実務で見る観点

- DB スキーマ変更をアプリ配備と同じ pull request の文脈で管理できるか
- 変更の安全性、適用タイミング、rollback しづらさを別々に考えられるか

## よくある失敗

Job は Deployment と違って `完了したら終わり` です。そのため、`apply したのに何も起きない` と感じたときは、失敗より先に `そもそも再実行されていないのでは` を疑うと切り分けが速くなります。

- Completed 済み Job に対して再度 `kubectl apply -k` すればもう一度走ると思い込む
- DB スキーマ変更をアプリの再デプロイと同じ感覚で戻せると思い込む
- Job の失敗ログを見ずに、DB 側の接続情報や権限ミスを見落とす
- 破壊的変更を 1 回で入れようとして互換性を壊す

## 詰まったときの確認コマンド

```bash
kubectl get jobs -n infra
kubectl get pods -n infra
kubectl describe job ridgepole-apply -n infra
kubectl logs job/ridgepole-apply -n infra
kubectl get secret postgres-secret -n infra -o yaml
kubectl get configmap ridgepole-files -n infra -o yaml
```

`kubectl get job -n infra` で `Completed` のまま変化がない場合は、`失敗していない` のではなく `新しく実行されていない` 可能性があります。Job は Deployment と違って、同じ manifest を apply しただけでは毎回走るわけではありません。

## 障害シナリオと復旧の考え方

想定シナリオ:

- Ridgepole Job が失敗し、スキーマ変更が途中で止まる
- アプリは新仕様前提なのに DB スキーマが追いついていない
- 破壊的変更後に古いアプリが動かなくなる

復旧の考え方:

- まず Job のログで失敗箇所を特定する
- アプリ配備順と schema apply 順の依存関係を見直す
- 破壊的変更は段階適用に分解できないか検討する

## レビュー観点と運用判断ポイント

- スキーマ変更はレビュー可能な形で Git 管理されているか
- backward compatibility を意識した変更手順になっているか
- Job 実行タイミングと責任主体が明確か

## 模擬インシデント演習

演習内容:

- Ridgepole Job が失敗し、アプリだけ新しいコードが先に出てしまった状況を想定する

考えること:

- どの順番で復旧するか
- アプリ rollback と schema apply retry のどちらを優先するか

## レビューコメント例

- 「Schemafile 管理は良いですが、破壊的変更を一度に入れると rollback が厳しいので、段階移行前提の記述を足したいです。」
- 「Job 実行の責任主体が曖昧なので、CI か手動かを運用ルールとして明示するとレビューしやすくなります。」

## 学ぶポイントの解説

この回の中心は、DB スキーマ変更を人の手順書ではなく、レビュー可能なコードとして扱うことです。アプリのソースコードを Git で管理するのに、DB だけ手作業で変えると、環境差分や変更漏れが起きやすくなります。Ridgepole はその問題を減らし、スキーマ変更を再現可能にするための道具です。

ただし、アプリのデプロイと DB スキーマ変更は同じではありません。アプリは古いバージョンに戻しやすい場合がありますが、DB の破壊的変更は簡単に戻せないことがあります。だからこそ、追加変更と削除変更を分ける、先に互換性のある変更を入れる、といった慎重な設計が必要です。

Job で流すか CI で流すかは、誰がいつ適用責任を持つかという運用設計の話でもあります。手元から直接 DB を変えるのではなく、仕組みの中で再現可能に適用するという考え方が重要です。実務では、技術選定そのものよりも、その運用ルールの方が事故防止に効きます。

もう 1 つ大事なのは、Job の性質を Deployment と混同しないことです。Deployment は desired replicas を保ち続けますが、Job は `完了したら終わり` です。そのため、Ridgepole のような一回処理は Job と相性が良い一方で、再試行のやり方を知らないと `apply したのに変化しない` と感じやすくなります。ここを理解しておくと、migration 系運用の事故が減ります。

## この回の宿題

- なぜ DB スキーマ変更はアプリと同じ感覚で rollback しづらいのか考える
- Ridgepole を Job で流す構成と CI で流す構成の違いを整理する

## 宿題の考え方

DB スキーマ変更が rollback しづらい理由を考えるときは、「データはすでに新しい形に変わっているかもしれない」という点を出発点にしてください。アプリのバイナリは差し替えられても、削除したカラムや変換したデータは元に戻せないことがあります。ここに、アプリ変更より慎重な設計が必要になる理由があります。

Job と CI の違いは、適用の責任とタイミングに注目すると整理しやすいです。Job はクラスタ内から明示的に実行しやすく、CI は pull request や merge と紐付けやすいです。どちらが優れているかではなく、自分たちの運用でどこに統制を置きたいかで選ぶと考えてください。

次は [handson9.md](handson9.md) で Grafana と監視を学びます。