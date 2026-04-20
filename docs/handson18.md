# Handson 18

## テーマ

mTLS の STRICT 化とカナリアリリースを学ぶ。

## 今回のゴール

- `PERMISSIVE` と `STRICT` の違いを説明できる
- サービスメッシュで canary を行うときの traffic split を理解できる
- 「暗号化された内部通信」と「段階リリース」を mesh 側で制御する意味を説明できる

## この回で先に押さえる用語

- mTLS: 相互認証つき暗号化通信
- PERMISSIVE: 平文と mTLS の両方を許す移行モード
- STRICT: mTLS のみを許可するモード
- Canary Release: 一部流量だけ新バージョンへ流す手法
- Rollback: 問題時に安全な状態へ戻すこと
- Runbook: 手順を定型化した文書

用語に迷ったら [glossary.md](glossary.md) の mTLS、PERMISSIVE、STRICT、Canary Release、Runbook を先に確認してください。

## 対応ファイル

- [manifests/extensions/servicemesh-advanced/peer-authentication-strict.yaml](../manifests/extensions/servicemesh-advanced/peer-authentication-strict.yaml)
- [manifests/extensions/servicemesh-advanced/user-service-canary-deployment.yaml](../manifests/extensions/servicemesh-advanced/user-service-canary-deployment.yaml)
- [manifests/extensions/servicemesh-advanced/user-service-canary-service.yaml](../manifests/extensions/servicemesh-advanced/user-service-canary-service.yaml)
- [manifests/extensions/servicemesh-advanced/user-service-canary-virtualservice.yaml](../manifests/extensions/servicemesh-advanced/user-service-canary-virtualservice.yaml)
- [manifests/extensions/servicemesh-advanced/user-service-stable-only-virtualservice.yaml](../manifests/extensions/servicemesh-advanced/user-service-stable-only-virtualservice.yaml)
- [manifests/extensions/servicemesh-advanced/user-service-promote-canary-virtualservice.yaml](../manifests/extensions/servicemesh-advanced/user-service-promote-canary-virtualservice.yaml)
- [scripts/mesh-canary-smoke-test.sh](../scripts/mesh-canary-smoke-test.sh)
- [scripts/mesh-release-observe.sh](../scripts/mesh-release-observe.sh)
- [scripts/mesh-canary-rollback.sh](../scripts/mesh-canary-rollback.sh)
- [scripts/mesh-canary-promote.sh](../scripts/mesh-canary-promote.sh)
- [release-metrics.md](release-metrics.md)
- [release-runbook.md](release-runbook.md)

## この回で実際にやること

1. handson17 まで完了した状態から始める
2. canary 用の `user-service-canary` を追加で起動する
3. VirtualService の weight で stable と canary の流量を分ける
4. `PERMISSIVE` の mTLS を `STRICT` に上げる
5. 通信失敗が出ないことを確認し、段階移行の意味を整理する

## 実行コマンド例

```bash
kubectl apply -k manifests/extensions/servicemesh-advanced
kubectl get deploy,svc,virtualservice,peerauthentication -n apps
bash scripts/mesh-canary-smoke-test.sh
bash scripts/mesh-release-observe.sh
kubectl describe peerauthentication apps-strict -n apps
kubectl describe virtualservice user-service-canary -n apps
```

## 完了条件

- `user-service-canary` の Pod と Service が作成されている
- VirtualService で stable と canary の重み付けが定義されている
- `apps-strict` PeerAuthentication が作成されている
- `STRICT` に上げても mesh 内通信が継続できる理由を説明できる

## 実務で見る観点

- mTLS はセキュリティ設定であると同時に、移行計画が必要な変更だと理解しているか
- canary の重み付けを使って、変更を一気に全量へ出さずに済むか

## よくある失敗

- sidecar 未注入の Pod が残ったまま `STRICT` に上げて通信断を起こす
- canary 用 Service はあるが VirtualService の host や weight が正しくなく、期待どおりに流量が分かれない
- canary 実施中に何をもって「問題なし」と判断するか決めていない

## 詰まったときの確認コマンド

```bash
kubectl get pods -n apps
kubectl get peerauthentication -n apps
kubectl describe peerauthentication apps-strict -n apps
kubectl get virtualservice -n apps
kubectl describe virtualservice user-service-canary -n apps
kubectl get svc -n apps | grep user-service
kubectl logs -l app.kubernetes.io/name=user-service -n apps -c istio-proxy --tail=100
bash scripts/mesh-canary-smoke-test.sh 50
```

## この回の後に必ずやること

1. `bash scripts/mesh-canary-smoke-test.sh 50` で canary が混ざって返ることを確認する
2. `bash scripts/mesh-release-observe.sh` で Pod 状態、再起動回数、`kubectl top` をまとめて確認する
3. Grafana や [release-metrics.md](release-metrics.md) の観測項目に沿って stable と canary の差を確認する
4. 問題があれば `bash scripts/mesh-canary-rollback.sh` で stable 100% に戻す
5. 問題がなければ `bash scripts/mesh-canary-promote.sh` で canary を全量へ昇格する

## 本番前チェックリスト

- sidecar 未注入 Pod が残っていない
- `sleep` からの疎通だけでなく、web-app からの実際の利用経路でも通信確認した
- 5xx、レイテンシ、Pod 再起動回数を観測した
- stable と canary の CPU、Memory、再起動回数を比較した
- rollback 手順を事前に実行できる形で用意した
- canary を何分観測し、何をもって昇格判断するかを決めた

## 切り戻しと昇格の実践

```bash
# 問題が出たら stable 100% に戻す
bash scripts/mesh-canary-rollback.sh

# 問題がなければ canary を昇格する
bash scripts/mesh-canary-promote.sh
```

## 障害シナリオと復旧の考え方

想定シナリオ:

- `STRICT` へ変更した直後に `sleep` から `user-service` への通信が失敗する
- canary を 10% のつもりで出したが、実際はほぼ全量が canary に流れてしまう

復旧の考え方:

- まず sidecar 注入されていない Pod が残っていないかを確認する
- 次に VirtualService の route 先と重み設定を確認する
- セキュリティ変更とトラフィック変更を同時にやりすぎていないか見直す
- 影響が出ている間は原因究明より先に rollback を打てるようにしておく

## レビュー観点と運用判断ポイント

- `STRICT` へ上げる前に sidecar 注入済みであることを確認できる構成か
- canary の重みは監視やメトリクス確認とセットで運用される前提か
- stable と canary の切り戻し手順が単純であるか

## 模擬インシデント演習

演習内容:

- `apps` namespace を `STRICT` にした直後、`sleep` から `user-service` への curl が失敗した状況を想定する

考えること:

- sidecar 注入、PeerAuthentication、Service 宛先、VirtualService のどこから確認するか
- まず設定を戻すべきか、原因を切り分けて継続調査すべきかをどう判断するか

## レビューコメント例

- 「`STRICT` に上げる手順は良いですが、sidecar 注入確認が前提条件としてもう少し強く書かれていると安全です。」
- 「canary の weighted routing を mesh 側で持つのは実務的です。アプリ実装を変えずに段階配布できるメリットが明確です。」

## 学ぶポイント

- `PERMISSIVE` は移行用、`STRICT` は本番寄りの強い制約
- canary はアプリコードではなく mesh の routing で制御できる
- セキュリティ変更とリリース変更は、段階的に進める方が安全である

## 学ぶポイントの解説

サービスメッシュの真価は、通信の暗号化とリリース制御をアプリ実装から切り離せる点にあります。`PERMISSIVE` は移行のための猶予状態であり、最終的には `STRICT` を目指すことが多いですが、いきなり上げると sidecar 未注入の通信が落ちます。したがって、mesh 化の完了確認とセキュリティ強化はセットで考える必要があります。

canary リリースも同じです。新しいバージョンを全量に一気に出すのではなく、まず一部の流量だけを canary に流し、メトリクスやエラー率を見て広げる方が安全です。サービスメッシュを使うと、この重み付けを routing 設定として宣言できるため、アプリ本体のコード変更を減らせます。

実務では、canary を出すことよりも、観測して戻せることの方が重要です。そのため、この回では canary の apply だけで終わらせず、スモークテスト、rollback、昇格までを一連の運用として扱います。

さらに一歩進めるなら、観測は人の勘ではなく、あらかじめ決めた指標で行うべきです。この教材では [release-metrics.md](release-metrics.md) に、canary 中に最低限見るべき CPU、Memory、再起動、失敗兆候の見方をまとめています。

## この回の宿題

- `PERMISSIVE` から `STRICT` へ上げる前に、何を確認しておくべきか整理する
- canary の 10% 配布を「安全」と判断するために、どの指標を見るべきか考える

## 宿題の考え方

`STRICT` への移行前確認では、sidecar 注入済み Pod、namespace の対象範囲、例外通信の有無が重要です。設定の強さだけでなく、切り戻しや段階移行を意識して考えてください。

canary の安全性判断では、成功率、レイテンシ、5xx、リソース使用率など、利用者影響と近い指標を見る必要があります。単に Pod が起動しているだけでは不十分です。

次にやることとしては、handson17 までの状態確認、handson18 の apply、スモークテスト実行、観測、rollback と昇格の練習までを一続きで実施してください。ここまでやると、実務で求められる「出す」「見る」「戻す」の流れを説明できるようになります。

実務に寄せて進めるなら、最後に [release-runbook.md](release-runbook.md) を使って、実施前確認、観測項目、rollback 判断、昇格判断を手順書として読み直してください。

そのうえで [release-metrics.md](release-metrics.md) を見ながら、どの指標を何分見て、何を異常とみなすかまで言えるようにしてください。