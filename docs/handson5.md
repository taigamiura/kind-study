# Handson 5

## テーマ

PostgreSQL の永続化を学ぶ。

## 今回のゴール

- StatefulSet を使う理由を説明できる
- PVC とデータ永続化の関係を理解できる
- Secret に認証情報を置く理由を説明できる

## この回で先に押さえる用語

- StatefulSet: stateful workload を管理する仕組み
- PersistentVolumeClaim: 永続ストレージ要求
- PersistentVolume: 実体となるストレージ
- Secret: 機密情報を扱う resource
- Stateful Workload: データや識別子を持つ workload

用語に迷ったら [glossary.md](glossary.md) の StatefulSet、PersistentVolumeClaim、Secret を先に確認してください。

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

対応 manifest:

- [manifests/base/postgres/secret.yaml](../manifests/base/postgres/secret.yaml)
- [manifests/base/postgres/service.yaml](../manifests/base/postgres/service.yaml)
- [manifests/base/postgres/statefulset.yaml](../manifests/base/postgres/statefulset.yaml)

## この回で実際にやること

1. Secret、Service、StatefulSet の 3 つの manifest を順番に読む
2. PostgreSQL を apply する
3. Pod、Service、PVC の状態を確認する
4. PostgreSQL Pod を消して、再作成後も PVC が残ることを確認する

## 実行コマンド例

```bash
kubectl apply -k manifests/base/postgres
kubectl get all -n infra
kubectl get pvc -n infra
kubectl describe statefulset postgres -n infra
kubectl delete pod postgres-0 -n infra
kubectl get pod -w -n infra
kubectl get pvc -n infra
```

## 完了条件

- infra namespace に postgres-0 が Running になっている
- postgres-data の PVC が Bound になっている
- Pod を再作成しても PVC が残ることを確認できた

## 実務で見る観点

- DB の再起動とデータ消失を同じ問題として扱わないようにできるか
- 認証情報、永続化、可用性を別の論点として切り分けて考えられるか

## よくある失敗

- Deployment と StatefulSet の違いを理解しないまま DB を配置する
- PVC の状態を見ずに Pod が起動しない原因をコンテナ側だけで探す
- Secret を更新しただけで既存 Pod に即反映されると誤解する

## 詰まったときの確認コマンド

```bash
kubectl get pods -n infra
kubectl get pvc -n infra
kubectl describe pvc postgres-data-postgres-0 -n infra
kubectl describe statefulset postgres -n infra
kubectl logs postgres-0 -n infra
```

## 障害シナリオと復旧の考え方

想定シナリオ:

- PostgreSQL Pod が再起動後に起動しない
- PVC が Pending のままで DB が立ち上がらない
- Secret の値不整合で接続失敗する

復旧の考え方:

- Pod の状態より先に PVC、StatefulSet、Secret を確認する
- データ永続化とコンテナ起動失敗を分けて切り分ける

## レビュー観点と運用判断ポイント

- DB 認証情報は Secret に切り出されているか
- 永続化の責務がコンテナ本体に埋め込まれていないか
- バックアップや復旧は別途必要だと理解できる構成か

## 模擬インシデント演習

演習内容:

- PostgreSQL Pod を削除した後に「DB が消えたのでは」と問い合わせが来た状況を想定する

考えること:

- 何を見ればデータ消失ではなく Pod 再作成だと説明できるか
- PVC と Pod をどう切り分けて説明するか

## レビューコメント例

- 「StatefulSet を使っている意図は良いですが、PVC を確認する手順が弱いので、永続化の確認観点をもう少し前に出したいです。」
- 「Secret の扱いは分かれていますが、更新後に Pod 再起動が必要な点まで触れると実運用に近づきます。」

## 学ぶポイント

- stateful workload と stateless workload の違い
- Secret と ConfigMap の使い分け
- バックアップと復旧は別のテーマであること

## 学ぶポイントの解説

この回では、Kubernetes 上で最も誤解されやすい「コンテナは消えてもよいが、データは消えてはいけない」という前提を学びます。Web や API は Pod を消して作り直しても元に戻りやすいですが、DB はそこに保存されたデータ自体がシステムの価値です。だからこそ、DB は stateless なアプリと同じ作り方をしてはいけません。

StatefulSet を使う理由は、単に DB だからという暗記ではなく、安定した識別子とストレージのひも付けが必要だからです。Pod が再作成されても、同じデータ領域を持って戻ってくることが期待されます。ここで PVC が、その永続データを担う中心的な役割を果たします。

Secret と ConfigMap の違いも実務では重要です。設定値のうち、漏えいすると危険なものは Secret に、漏えても即重大事故になりにくい一般設定は ConfigMap に分けます。また、バックアップと復旧は PVC があれば自動で解決する話ではありません。永続化とバックアップは別レイヤーの課題だと理解してください。

## 実務上の注意

- 本番ではマネージド DB や Operator を使うことも多い
- ただし学習では StatefulSet を知る価値が大きい

## この回の宿題

- Pod が消えてもデータが残る設計を言葉で説明する
- DB 用 Secret を漏らしたときの影響を整理する

## 宿題の考え方

Pod が消えてもデータが残る設計を説明するときは、「コンテナのライフサイクル」と「データのライフサイクル」を分けて話すのがポイントです。Pod は入れ替わる前提ですが、PVC はその外側にあり、再作成された Pod が同じデータに再接続します。ここを切り分けて言語化できると、stateful workload の理解がかなり深まります。

Secret 漏えいの影響については、単にログインされるかもしれない、で終わらせないでください。DB の読み書き、個人情報漏えい、監査対応、鍵ローテーション、アプリ停止リスクなど、実務で起こる連鎖を想像して整理することが重要です。技術だけでなく運用影響まで考える癖をつけてください。

次は [handson6.md](handson6.md) で API を配置します。