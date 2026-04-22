# Handson 40

## テーマ

PodDisruptionBudget と node drain を学ぶ。

## 今回のゴール

- 自発的な停止と障害停止の違いを説明できる
- PDB が `メンテナンス時の安全装置` であることを理解する
- node drain と rollout の違いを説明できる

## この回で先に押さえる用語

- PodDisruptionBudget: 自発停止の許容量
- Drain: Node から安全に Pod を退避する操作
- Cordon: Node へ新規配置を止める操作
- Eviction: Pod を別 Node へ退避させること
- Maintenance Window: メンテナンス時間帯

## 対応ファイル

- [maintenance-runbook.md](maintenance-runbook.md)
- [manifests/extensions/resilience/user-service-pdb.yaml](../manifests/extensions/resilience/user-service-pdb.yaml)
- [manifests/extensions/resilience/item-service-pdb.yaml](../manifests/extensions/resilience/item-service-pdb.yaml)
- [scripts/maintenance-precheck.sh](../scripts/maintenance-precheck.sh)

## この回で実際にやること

1. [maintenance-runbook.md](maintenance-runbook.md) を読み、drain の前提確認を整理する
2. user-service と item-service の PDB を読む
3. `bash scripts/maintenance-precheck.sh apps` で PDB と Pod 状態を確認する
4. `障害停止` と `計画停止` の考え方の違いを整理する

## このコマンドで確認するのはここ

- `bash scripts/maintenance-precheck.sh apps`: Pod の `READY/STATUS`、replica 数、PDB の `minAvailable` または `maxUnavailable`、drain 前に止めてはいけない Pod がないかを見る
- 追加で `kubectl get pdb -n apps` を使う場合: `ALLOWED DISRUPTIONS` が 0 になっていないかを見る

## 完了条件

- PDB がいつ効き、いつ効かないか説明できる
- drain 前に何を確認すべきか説明できる
- rollout restart と node drain の違いを説明できる

## 実務で見る観点

- メンテナンス時にサービス停止をどこまで許容するか決まっているか
- replica 数と PDB が矛盾していないか
- drain 前に readiness / replicas / PDB を確認できているか

## よくある失敗

この回の失敗は、可用性の設定を YAML の有無だけで判断すると起きやすいです。箇条書きは別々に見えても、背景には `どのメンテナンス操作で守られるか` を実際の drain と結び付けていないことがあります。

- replica 1 のまま PDB を置いて意味がない
- drain を急いで実施して一時停止を広げる
- PDB があるから絶対安全だと誤解する

## 学ぶポイント

- PDB は計画停止時の安全性を上げるが、障害停止そのものを防ぐものではない
- drain 前には `逃がせる状態か` の確認が必要である
- 本番運用ではメンテナンスの安全性も設計対象である

## 学ぶポイントの解説

Kubernetes を本番で運用すると、Node 再起動、OS patch、version upgrade など、計画停止を避けられません。そのときに必要なのが PDB と drain の理解です。これがないと、意図せず同時停止を起こしやすくなります。

PDB は `一度にどこまで落としてよいか` を表現するため、可用性設計と強く結びつきます。ここはアプリ配備だけ学んだ人が抜けやすい実務ポイントです。

## この回の宿題

- replica 数 2 と 3 で、どの PDB が妥当か考える
- node drain 前に確認すべき項目を 5 つ挙げる

次は [handson41.md](handson41.md) で配置制御を学びます。