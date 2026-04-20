# Handson 20

## テーマ

Secret と TLS 証明書の更新運用を学ぶ。

## 今回のゴール

- Secret を更新したあとに何が再起動対象になるか説明できる
- 証明書の期限切れを事前に確認する習慣を持てる
- `apply したら終わり` ではなく `反映確認まで行う` 流れを実践できる

## この回で先に押さえる用語

- Secret: 機密情報を格納する resource
- Rotation: 定期的に値を更新すること
- Certificate: TLS 証明書
- Renewal: 証明書の更新
- Rollout Restart: Deployment を安全に再起動する操作

## 対応ファイル

- [secret-rotation-checklist.md](secret-rotation-checklist.md)
- [manifests/base/postgres/secret.yaml](../manifests/base/postgres/secret.yaml)
- [manifests/extensions/https/apps-certificate.yaml](../manifests/extensions/https/apps-certificate.yaml)
- [scripts/cert-expiry-check.sh](../scripts/cert-expiry-check.sh)
- [scripts/secret-rollout-restart.sh](../scripts/secret-rollout-restart.sh)

## この回で実際にやること

1. どの Secret がどの workload に効くかを整理する
2. `bash scripts/cert-expiry-check.sh` で証明書状態を確認する
3. Secret を更新した想定で、再起動すべき Deployment を洗い出す
4. `bash scripts/secret-rollout-restart.sh` を使って rollout restart を実施する
5. 更新後に Pod、Secret、Certificate の状態を確認する

## 実行コマンド例

```bash
bash scripts/cert-expiry-check.sh
bash scripts/secret-rollout-restart.sh apps user-service item-service web-app
kubectl get secret -n infra
kubectl get certificate -n apps
kubectl rollout status deployment/user-service -n apps
```

## 完了条件

- 証明書の有効期限と Ready 状態を確認できる
- Secret 更新後に再起動対象を説明できる
- rollout restart 後に Pod が新しくなったことを確認できる

## 実務で見る観点

- Secret を誰が更新するか、更新窓口が曖昧でないか
- 証明書期限切れを事前検知できるか
- 更新後の影響確認が runbook 化されているか

## よくある失敗

- Secret を更新したが Pod 再起動を忘れる
- 証明書の Ready だけ見て、有効期限を見ない
- どの Deployment がその Secret を使うか把握していない

## 詰まったときの確認コマンド

```bash
kubectl get secret -A
kubectl get certificate -A
kubectl describe certificate apps-local-tls -n apps
kubectl get pods -n apps
```

## 学ぶポイント

- Secret 運用は `値の更新` と `反映確認` の 2 段階で考える
- 証明書運用は `Ready` だけでなく `残り期限` を見る
- day-2 運用では期限管理と再起動管理が重要である

## 学ぶポイントの解説

アプリケーションは作って終わりではなく、機密情報や証明書を定期的に更新し続けます。ここで多い事故は、Secret の値だけ更新して Pod へ反映されていない、あるいは証明書期限切れを本番直前まで見逃すことです。

そのため実務では、`何を更新したか`, `どの workload へ影響するか`, `再起動後に何を確認するか` をセットで管理します。この回では、その最小単位を handson 化しています。

## この回の宿題

- 今の構成で期限切れが起きると困る Secret と Certificate を 3 つ挙げる
- 更新後に必ず見るメトリクスや状態を 3 つ挙げる

次は [handson21.md](handson21.md) で SLO と Alert の考え方を学びます。