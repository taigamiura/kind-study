# PostgreSQL Secret Rotation Runbook

この runbook は PostgreSQL 接続用 Secret を安全にローテーションするための最小手順です。目的は、`Secret を更新した` を `DB 側の認証変更と workload 反映まで完了した` に変えることです。

この資料は学習用ですが、実務で事故になりやすい点を外していません。特に重要なのは、Kubernetes Secret の更新と PostgreSQL 内の認証情報更新は別の操作だということです。

## 使う対象

- [secret-rotation-checklist.md](secret-rotation-checklist.md)
- [backup-restore-runbook.md](backup-restore-runbook.md)
- [../manifests/base/postgres/secret.yaml](../manifests/base/postgres/secret.yaml)
- [../manifests/base/postgres/statefulset.yaml](../manifests/base/postgres/statefulset.yaml)

## 前提

- PostgreSQL は `infra` namespace で動いている
- PostgreSQL へ接続する application は別 workload として存在する
- DB 接続情報は Kubernetes Secret から注入されている
- 変更前に切り戻し方法と backup の有無を確認している

## 最初に理解しておくこと

- Secret を更新しただけでは、動作中 Pod の環境変数は変わらない
- PostgreSQL コンテナの `POSTGRES_USER` と `POSTGRES_PASSWORD` は初回初期化時の意味を含む
- 既存 DB の認証実体は PostgreSQL 内の role であり、Secret 更新だけでは切り替わらない
- 失敗しにくい切り替えは `新資格情報を先に追加` して `新旧共存期間` を持つ方式である

## 実施方針

この runbook では、旧ユーザーをすぐ上書きするのではなく、新ユーザーを追加して切り替える方式を採用します。理由は、切り戻しがしやすく、どこまで切り替わったかを段階的に確認できるためです。

想定する切り替えの流れは次の 4 段階です。

1. 準備
2. 切り替え
3. 確認
4. 後片付け

## 1. 準備

最初に、現行 Secret と参照元 workload を把握します。

```bash
kubectl get secret postgres-secret -n infra -o yaml
kubectl get deploy,statefulset -A | grep postgres
```

次に、PostgreSQL Pod が正常であることを確認します。

```bash
kubectl get pods -n infra -l app.kubernetes.io/name=postgres
kubectl logs postgres-0 -n infra --tail=50
```

変更前に backup を取得できる状態も確認します。少なくとも、直近の restore 手順を説明できることが必要です。

```bash
bash scripts/postgres-backup.sh
ls -1 artifacts/postgres-backups
```

この段階で確認することは次の通りです。

- どの Secret を更新するか明確である
- どの workload がその Secret を使うか分かっている
- PostgreSQL が正常である
- backup と切り戻し方法が説明できる

### DB 側で新ユーザーを追加する

次に、旧ユーザーを消さずに新ユーザーを追加します。以下は例です。DB 名や権限は自分の環境に合わせて調整してください。

```bash
kubectl exec -n infra postgres-0 -- sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE ROLE app_user_next WITH LOGIN PASSWORD '\''replace-with-strong-password'\'';"'
```

```bash
kubectl exec -n infra postgres-0 -- sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "GRANT CONNECT ON DATABASE $POSTGRES_DB TO app_user_next;"'
```

```bash
kubectl exec -n infra postgres-0 -- sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "GRANT USAGE ON SCHEMA public TO app_user_next; GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_user_next; ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user_next;"'
```

ここで大事なのは、旧ユーザーをまだ消さないことです。切り替え失敗時にすぐ戻せる状態を保ちます。

## 2. 切り替え

新しい接続情報を Secret に反映します。手元の学習環境なら、次のように Secret を更新できます。

```bash
kubectl create secret generic postgres-secret \
  -n infra \
  --from-literal=POSTGRES_DB=app \
  --from-literal=POSTGRES_USER=app_user_next \
  --from-literal=POSTGRES_PASSWORD='replace-with-strong-password' \
  --dry-run=client -o yaml | kubectl apply -f -
```

ここで注意することは 2 つあります。

- Secret が更新されても既存 Pod の環境変数は即時には変わらない
- 再起動すべき対象は `その Secret を参照して DB 接続する workload` である

Deployment を使っている application なら、次のように順次再起動します。

```bash
kubectl rollout restart deployment user-service -n apps
kubectl rollout status deployment user-service -n apps
```

```bash
kubectl rollout restart deployment item-service -n apps
kubectl rollout status deployment item-service -n apps
```

複数 workload がある場合は、一度に全部再起動せず、影響を見ながら順次進める方が失敗しにくいです。

### 切り戻し条件

次のどれかに当てはまったら、旧 Secret に戻して再度 rollout restart します。

- application が DB 認証エラーを出す
- readiness が戻らない
- 5xx や job failure が増える
- 新ユーザーでの接続成功を確認できない

## 3. 確認

Pod が正常に入れ替わったかを確認します。

```bash
kubectl get pods -n apps
kubectl rollout status deployment/user-service -n apps
kubectl rollout status deployment/item-service -n apps
```

application ログに認証エラーが出ていないかを見ます。

```bash
kubectl logs deployment/user-service -n apps --tail=100
kubectl logs deployment/item-service -n apps --tail=100
```

次に、新ユーザーで PostgreSQL へ接続できることを確認します。

```bash
kubectl exec -n infra postgres-0 -- sh -c 'PGPASSWORD='\''replace-with-strong-password'\'' psql -h postgres -U app_user_next -d "$POSTGRES_DB" -c "\\conninfo"'
```

この段階で確認することは次の通りです。

- 再起動した Pod が `Running` と `Ready` に戻っている
- application ログに `password authentication failed` が出ていない
- 新ユーザーで接続できる
- 古いユーザーに依存した workload が残っていない

### 追加で見ると理解が深まるポイント

- Secret を更新しても Pod を再起動するまで環境変数は変わらない
- DB 内 role と Kubernetes Secret は別レイヤーである
- `Pod 正常` と `業務トラフィック正常` は同義ではない

## 4. 後片付け

安定稼働を確認できたら、旧ユーザーの権限を剥がして削除します。更新直後に消すのではなく、監視やログを見て問題ないことを確認したあとで実施します。

```bash
kubectl exec -n infra postgres-0 -- sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "REVOKE ALL PRIVILEGES ON DATABASE $POSTGRES_DB FROM app_user_old;"'
```

```bash
kubectl exec -n infra postgres-0 -- sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "DROP ROLE app_user_old;"'
```

最後に、作業記録を残します。最低限、次の内容を残してください。

- 実施日時
- 実施者
- 変更対象 Secret 名
- 変更対象 workload
- 新旧ユーザー名
- 確認したログ、メトリクス、接続確認結果
- 切り戻し有無

## 実務で見る観点

- Secret の正本がどこか決まっているか
- 新旧資格情報の共存期間を取れているか
- Secret 更新後の再起動対象が洗い出せているか
- 監査用の記録が残る運用になっているか
- PostgreSQL 内 role 変更と Kubernetes Secret 変更を混同していないか

## よくある失敗

- Secret だけ更新して Pod 再起動を忘れる
- DB 内ユーザーを更新せず、Kubernetes Secret だけ変える
- 旧ユーザーを早く消しすぎて切り戻せなくなる
- Deployment を一斉再起動して影響範囲が読めなくなる
- backup を取らずに本番切り替えを始める

## 最小チェックリスト

- 新ユーザーは作成済みか
- 新ユーザーで DB 接続できるか
- Secret は更新済みか
- 参照 workload は再起動済みか
- 認証エラーは出ていないか
- 旧ユーザー削除前に安定確認を終えたか

## この runbook で学ぶこと

- Secret rotation は `値を変える作業` ではなく `DB と workload を整合させる作業` であること
- stateful system の認証情報変更は新旧共存で進める方が安全なこと
- 切り替え成功の判定には Pod 状態だけでなく接続確認とログ確認が必要なこと
