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
- [scripts/mesh-release-preflight.sh](../scripts/mesh-release-preflight.sh)
- [scripts/mesh-release-observe.sh](../scripts/mesh-release-observe.sh)
- [scripts/mesh-canary-rollback.sh](../scripts/mesh-canary-rollback.sh)
- [scripts/mesh-canary-promote.sh](../scripts/mesh-canary-promote.sh)
- [scripts/mesh-release-summary.sh](../scripts/mesh-release-summary.sh)
- [scripts/mesh-release-postcheck.sh](../scripts/mesh-release-postcheck.sh)
- [scripts/mesh-rollback-evidence.sh](../scripts/mesh-rollback-evidence.sh)
- [release-decision-template.md](release-decision-template.md)
- [release-communication-template.md](release-communication-template.md)
- [release-followup-checklist.md](release-followup-checklist.md)
- [rollback-investigation-template.md](rollback-investigation-template.md)
- [preventive-action-template.md](preventive-action-template.md)
- [rerelease-readiness-checklist.md](rerelease-readiness-checklist.md)
- [grafana-canary-checklist.md](grafana-canary-checklist.md)
- [grafana-dashboard-guide.md](grafana-dashboard-guide.md)
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
bash scripts/mesh-release-preflight.sh
kubectl apply -k manifests/extensions/servicemesh-advanced
kubectl get deploy,svc,virtualservice,peerauthentication -n apps
bash scripts/mesh-canary-smoke-test.sh
bash scripts/mesh-release-observe.sh
bash scripts/mesh-release-summary.sh
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

1. `bash scripts/mesh-release-preflight.sh` で事前条件を確認する
2. `bash scripts/mesh-canary-smoke-test.sh 50` で canary が混ざって返ることを確認する
3. `bash scripts/mesh-release-observe.sh` で Pod 状態、再起動回数、`kubectl top` をまとめて確認する
4. Grafana や [release-metrics.md](release-metrics.md) の観測項目に沿って stable と canary の差を確認する
5. [grafana-canary-checklist.md](grafana-canary-checklist.md) に沿って、見る順序と go/no-go 判断を整理する
6. [grafana-dashboard-guide.md](grafana-dashboard-guide.md) を見ながら dashboard とパネルを開いて確認する
7. [release-decision-template.md](release-decision-template.md) に沿って promote / rollback / hold を記録する
8. [release-communication-template.md](release-communication-template.md) に沿って、チームへ現在状態を共有する
9. 判断に迷う場合は Hold として観測を延長し、再判断時刻を決める
10. 問題があれば `bash scripts/mesh-canary-rollback.sh` で stable 100% に戻す
11. 問題がなければ `bash scripts/mesh-canary-promote.sh` で canary を全量へ昇格する
12. `bash scripts/mesh-release-postcheck.sh` と [release-followup-checklist.md](release-followup-checklist.md) で promote 後または rollback 後の追跡監視を行う
13. rollback した場合は `bash scripts/mesh-rollback-evidence.sh` と [rollback-investigation-template.md](rollback-investigation-template.md) で初動調査メモを残す
14. rollback した場合は [preventive-action-template.md](preventive-action-template.md) に再発防止アクションを残す
15. 再度 canary を出す前に `bash scripts/mesh-rerelease-precheck.sh` と [rerelease-readiness-checklist.md](rerelease-readiness-checklist.md) で再リリース可否を確認する

補足:

- `kubectl top` は metrics-server が前提です
- metrics-server 未導入なら、Grafana、Pod 状態、restart 回数、5xx、レイテンシ観測を優先してください
- canary 判断の本質は `top の数値を見ること` ではなく、stable と canary の差を複数指標で比較することです

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

Grafana を使う場合も同じで、闇雲にダッシュボードを開くのではなく、どのパネルを上から順に見て、どこで切り戻し判断をするかを決めておく方が強いです。そのための最小手順を [grafana-canary-checklist.md](grafana-canary-checklist.md) にまとめています。

さらに、実際に Grafana を開いたときに迷わないよう、どの dashboard 名を開き、どのパネルを見ればよいかを [grafana-dashboard-guide.md](grafana-dashboard-guide.md) にまとめています。

実務では、観測した内容をその場で判断に変え、後から見返せるように残すところまで求められます。そのため、この回では `bash scripts/mesh-release-preflight.sh` と [release-decision-template.md](release-decision-template.md) も使います。

さらに、実際の現場では自分だけ分かっていても不十分で、今どの段階にいて、何を根拠に promote / rollback / hold を選んだかを短く共有する必要があります。そのための文面例を [release-communication-template.md](release-communication-template.md) にまとめています。

また、Hold は単なる保留ではなく、追加観測して再判断するという明確な運用状態です。再判断時刻を決めずに Hold すると、実務では誰も責任を持てなくなります。

rollback も同じで、戻した瞬間に終わりではありません。どの Pod に何が起きていたか、5xx がどう出ていたか、次に誰がどこを調べるかを残しておかないと、同じ事故を繰り返します。

さらに実務では、調査メモだけでも足りません。再リリース前に必須な対策、少し後でもよい恒久対策、監視強化のような運用対策を分けてタスク化しないと、調査結果が次の改善に結びつきません。

そのうえで、本当にもう一度出してよいかを確認する gate も必要です。前回と同じ条件のまま再度 canary を出すと、実務では `学んでいない rollback` になります。

## この回の宿題

- `PERMISSIVE` から `STRICT` へ上げる前に、何を確認しておくべきか整理する
- canary の 10% 配布を「安全」と判断するために、どの指標を見るべきか考える

## 宿題の考え方

`STRICT` への移行前確認では、sidecar 注入済み Pod、namespace の対象範囲、例外通信の有無が重要です。設定の強さだけでなく、切り戻しや段階移行を意識して考えてください。

canary の安全性判断では、成功率、レイテンシ、5xx、リソース使用率など、利用者影響と近い指標を見る必要があります。単に Pod が起動しているだけでは不十分です。

次にやることとしては、handson17 までの状態確認、handson18 の apply、スモークテスト実行、観測、rollback と昇格の練習までを一続きで実施してください。ここまでやると、実務で求められる「出す」「見る」「戻す」の流れを説明できるようになります。

実務に寄せて進めるなら、最後に [release-runbook.md](release-runbook.md) を使って、実施前確認、観測項目、rollback 判断、昇格判断を手順書として読み直してください。

そのうえで [release-metrics.md](release-metrics.md) を見ながら、どの指標を何分見て、何を異常とみなすかまで言えるようにしてください。

最後に `bash scripts/mesh-release-summary.sh` を実行して、kubectl で見える情報と Grafana で確認すべき観点をひとまとめに確認すると、現場のリリース確認に近い流れになります。

その後に [release-decision-template.md](release-decision-template.md) を埋めて、なぜ promote したか、なぜ rollback したかを短く言語化してください。ここまでできると、実務での再現性がかなり上がります。

最後に [release-communication-template.md](release-communication-template.md) を使って、開始連絡、観測中連絡、rollback 連絡、promote 完了連絡まで書けるようにしてください。ここまでできると、個人作業ではなくチーム運用にかなり近づきます。

その後に `bash scripts/mesh-release-postcheck.sh` と [release-followup-checklist.md](release-followup-checklist.md) を使って、判断直後の追跡監視まで完了させてください。ここまでできると、release を出したあとに崩れていないかまで確認できるようになります。

もし rollback した場合は、さらに `bash scripts/mesh-rollback-evidence.sh` を実行して、Pod 状態、VirtualService、proxy ログなどの証跡を残し、[rollback-investigation-template.md](rollback-investigation-template.md) に初動調査メモを書いてください。ここまでできると、障害対応の入口まで実務にかなり近づきます。

その次に [preventive-action-template.md](preventive-action-template.md) を使って、再発防止アクションを `再リリース前に必須`, `今週中に実施`, `後で改善` に分けて書いてください。ここまでできると、障害対応を改善活動へつなげる流れまで説明できるようになります。

さらに再リリース前には `bash scripts/mesh-rerelease-precheck.sh` を実行し、[rerelease-readiness-checklist.md](rerelease-readiness-checklist.md) を見ながら、修正済み項目、監視強化、rollback 条件、観測時間の見直しまで確認してください。ここまでできると、`直したから出す` ではなく `再度出してよい条件を満たしたから出す` と説明できるようになります。