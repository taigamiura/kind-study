# Handson 10

## テーマ

Argo CD による GitOps と、最後の障害訓練を学ぶ。

## 今回のゴール

- Argo CD を入れる意味を説明できる
- Git が正である状態の価値を理解できる
- Kubernetes の自己修復や差分管理を体感できる

## この回の前提

- ingress-nginx が導入済みである
- `manifests/base/argocd/*.yaml` の `repoURL` と `path` を自分の環境に合わせてから apply する

この回は `apply できたら終わり` ではありません。Argo CD はブラウザで差分や同期状態を見ると理解がかなり進みます。

## この回で先に押さえる用語

- GitOps: Git を正としてクラスタ状態を管理する運用
- Argo CD: GitOps を実現するツール
- Drift: Git とクラスタ状態のずれ
- Rollback: 安全な状態へ戻すこと

用語に迷ったら [glossary.md](glossary.md) の GitOps、Argo CD、Drift、Rollback を先に確認してください。

## 目的

- kubectl の手作業運用から卒業し、宣言的運用へ移る

## 実務上のメリット

- 設定ドリフトを減らせる
- 誰が何を変えたか追跡しやすい
- rollback と再現性が高くなる

## 推奨分割

- infra Application: ingress, postgres, monitoring
- apps Application: user-service, item-service, web-app

対応ファイル:

- [manifests/helm/argocd-values.yaml](../manifests/helm/argocd-values.yaml)
- [manifests/base/argocd/app-project.yaml](../manifests/base/argocd/app-project.yaml)
- [manifests/base/argocd/infra-application.yaml](../manifests/base/argocd/infra-application.yaml)
- [manifests/base/argocd/apps-application.yaml](../manifests/base/argocd/apps-application.yaml)
- [manifests/base/argocd/observability-application.yaml](../manifests/base/argocd/observability-application.yaml)
- [scripts/install-argocd.sh](../scripts/install-argocd.sh)

## この回で実際にやること

1. Argo CD を Helm でインストールする
2. AppProject と Application manifest を読む
3. Git リポジトリ URL が自分の環境に合っているか確認してから apply する
4. Argo CD が管理対象をどう分けるかを確認する
5. ブラウザで Argo CD UI を開き、Application 一覧と同期状態を確認する
6. 最後に Pod 削除や replica 変更などの障害訓練を試し、Argo CD の見え方を観察する

## 実行コマンド例

```bash
bash scripts/install-argocd.sh
kubectl apply -k manifests/overlays/local/gitops
kubectl get pods -n gitops
kubectl get applications -n gitops
kubectl get appprojects -n gitops
kubectl get ingress -n gitops
kubectl get secret argocd-initial-admin-secret -n gitops -o jsonpath='{.data.password}' | base64 -d; echo
kubectl delete pod -l app.kubernetes.io/name=user-service -n apps
kubectl scale deployment web-app --replicas=3 -n apps
kubectl get pods -n apps -w
```

ブラウザでは次を開きます。

```text
http://argocd.localtest.me
```

login 情報:

- user: admin
- password: `argocd-initial-admin-secret` から取り出した値

Argo CD に入ったら、最初は次の順で見ます。

1. Application 一覧を開く
2. `kind-study-infra`, `kind-study-apps`, `kind-study-observability` の 3 つがあるか確認する
3. `Synced` と `Healthy` の表示を確認する
4. どれか 1 つを開き、配下 resource がツリーで見えることを確認する

ここで理解してほしいこと:

- `Synced`: Git 上の定義とクラスタ状態が一致している
- `OutOfSync`: 手作業変更や apply 漏れなどで差分がある
- `Healthy`: resource は概ね期待どおり動いている

次に drift を体感します。

1. `kubectl scale deployment web-app --replicas=3 -n apps` を実行する
2. ブラウザで `kind-study-apps` を再表示する
3. 一時的に `OutOfSync` になるか、selfHeal で戻るかを確認する

さらに `kubectl delete pod -l app.kubernetes.io/name=user-service -n apps` を実行すると、Kubernetes の自己修復と GitOps の差分管理が別物だと分かりやすくなります。

- Pod 削除: Deployment / Kubernetes の自己修復で戻る
- replica 変更: Git とクラスタの差分なので Argo CD が戻す対象になる

## 初学者が最初につまずきやすいポイント

Argo CD をまだ腹落ちしていない段階だと、`ローカルで YAML を直して kubectl apply したのに、なぜ元に戻るのか` がかなり分かりにくいです。

ここで大事なのは、Argo CD は `ローカルファイル` を見ていないことです。Argo CD が見ているのは `GitHub の main` のような、Application に設定した Git の状態です。

つまり、Argo CD が無い世界では次の流れになります。

1. ローカルで YAML を直す
2. `kubectl apply` する
3. クラスタがそのまま更新される

一方で Argo CD がある世界では次の流れになります。

1. ローカルで YAML を直す
2. `kubectl apply` でクラスタは一瞬変わる
3. でも Git の正解が古いままなら、Argo CD が差分を見つける
4. Argo CD が Git の内容へ戻す

この違いが、GitOps の一番大事な感覚です。GitOps では `kubectl apply が最終結果` ではなく、`Git に入った変更が最終結果` になります。

初学者向けに言い換えると、Argo CD は `Git を正解として、クラスタをその正解に保つ監督役` です。ローカルで手直ししただけでは正式な変更とはみなされず、Git に push して初めて新しい正解になります。

## 完了条件

- gitops namespace に Argo CD 関連 Pod が起動している
- AppProject と Application が作成されている
- `http://argocd.localtest.me` で Argo CD UI を開ける
- Application 一覧で `Synced` / `OutOfSync` / `Healthy` を読める
- Pod 削除や replica 変更後の挙動を観察し、自己修復や差分管理を説明できる

## 実務で見る観点

- Git の差分が、そのまま運用監査やレビューの材料になると理解しているか
- 「今のクラスタ状態」ではなく「あるべき状態」を中心に運用できるか

## よくある失敗

- repoURL や path を自分の環境に合わせずに apply して同期失敗する
- Argo CD 本体は動いているが Application が OutOfSync や Missing のまま放置する
- ブラウザで入れるのに `Applications` 一覧を見ず、何が同期対象か把握しない
- `OutOfSync` と `Healthy` の違いを混同する
- ローカルで直して `kubectl apply` したのに、Git に push していない変更が戻される理由を理解しない
- 障害訓練で壊した内容と Git 上の正との差分を意識せずに観察してしまう

## 詰まったときの確認コマンド

```bash
kubectl get pods -n gitops
kubectl get appprojects,applications -n gitops
kubectl describe application kind-study-apps -n gitops
kubectl describe application kind-study-infra -n gitops
kubectl logs -n gitops -l app.kubernetes.io/name=argocd-application-controller --tail=100
```

ブラウザで入れない場合は、次も確認します。

```bash
kubectl get ingress -n gitops
kubectl describe ingress argocd-server -n gitops
kubectl get svc -n gitops
```

## 障害シナリオと復旧の考え方

想定シナリオ:

- Application が OutOfSync のまま戻らない
- Git には正しい定義があるのにクラスタとの差分が解消されない
- 手作業変更と GitOps の定義が衝突して状態が不安定になる

復旧の考え方:

- repoURL、targetRevision、path が正しいかを確認する
- Application の events と controller logs で差分原因を確認する
- 手作業変更を戻すか Git に反映するかを運用ルールに従って判断する

## レビュー観点と運用判断ポイント

- Git を唯一の正とする運用ルールが曖昧になっていないか
- Application 分割が責務と同期単位に合っているか
- 手作業変更禁止や例外手順がチームで共有されているか

## 模擬インシデント演習

演習内容:

- 誰かが本番クラスタで手作業変更を行い、Argo CD が OutOfSync になった状況を想定する

考えること:

- 手作業変更を戻すか Git に取り込むか、どんな基準で判断するか
- どの情報を見れば安全に判断できるか

## レビューコメント例

- 「Application 分割は分かりやすいですが、repoURL をローカル学習用の仮値のままにすると初学者がそのまま apply して詰まるので注意喚起を強めたいです。」
- 「手作業変更と GitOps の衝突を障害訓練に入れているのは良いです。実務で最も起きやすい drift の学習につながります。」

## 最後にやる障害訓練

- API Pod を削除する
- web-app を 3 replica に増やす
- PostgreSQL Pod を再作成する
- Secret の値を壊す
- readinessProbe を失敗させる

## この回で理解すべきこと

- Kubernetes は壊れても戻す仕組みを持つ
- GitOps は変更を残し、比較し、戻しやすくする
- 正常系だけでなく異常系を見ると理解が深まる

## 学ぶポイントの解説

この回では、Kubernetes の本当の価値が正常時より異常時に見えやすいことを体感してほしいです。Pod を消しても戻る、望ましい状態に再収束する、というのは Kubernetes の根幹です。ただし、その「望ましい状態」が何かを定義していなければ、自己修復は起きません。GitOps はその望ましい状態を Git に置く運用です。

kubectl apply を人が打ち続ける運用は、小規模なうちは成立しても、誰が何を変えたか、今の状態が本当に正しいのかが曖昧になりやすいです。Argo CD は Git とクラスタを比較し、差分を見つけて埋めることで、この曖昧さを減らします。実務では、この差分の可視化と再現性が非常に重要です。

最後に障害訓練を入れているのは、学習を知識だけで終わらせないためです。Secret を壊したときにどう見えるか、readinessProbe が失敗すると何が起きるかを体験すると、抽象概念が実感に変わります。実務に近づくほど、この「壊して理解する」姿勢が役立ちます。

## この回の宿題

- kubectl apply を続ける運用の弱さを整理する
- GitOps を導入するとレビューと監査がどう変わるか説明する

## 宿題の考え方

kubectl apply 中心の運用の弱さを考えるときは、再現性、監査性、属人性の 3 つの観点で整理してください。手元のコマンド操作は速い一方で、誰が何をどの順番で適用したかが追いにくく、環境差分が生まれやすいです。これはチーム開発になるほど問題になります。

GitOps を導入したときのレビューと監査の変化は、変更が Git の差分として残る点にあります。レビューでは YAML の差分を見て意図を確認でき、監査ではどの commit がどの状態を作ったか追跡できます。宿題では、便利になった、ではなく、何が可視化されて何が統制しやすくなるのかを言語化してください。

## このシリーズの次

次は [handson11.md](handson11.md) で Helm を学びます。Argo CD が `Git の状態をどう反映するか` を見たあとに、Helm が `大きなアドオンをどう安全に入れるか` を学ぶとつながりやすいです。