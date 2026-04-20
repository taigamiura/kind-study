# Release Runbook

この runbook は、handson18 の canary を実務寄りに運用するための手順書です。目的は、`apply すること` ではなく、`安全に出して、観測して、戻せること` を身につけることです。

## 使う対象

- [manifests/extensions/servicemesh-advanced/user-service-canary-virtualservice.yaml](../manifests/extensions/servicemesh-advanced/user-service-canary-virtualservice.yaml)
- [manifests/extensions/servicemesh-advanced/user-service-stable-only-virtualservice.yaml](../manifests/extensions/servicemesh-advanced/user-service-stable-only-virtualservice.yaml)
- [manifests/extensions/servicemesh-advanced/user-service-promote-canary-virtualservice.yaml](../manifests/extensions/servicemesh-advanced/user-service-promote-canary-virtualservice.yaml)
- [scripts/mesh-release-preflight.sh](../scripts/mesh-release-preflight.sh)
- [scripts/mesh-canary-smoke-test.sh](../scripts/mesh-canary-smoke-test.sh)
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
- [scripts/mesh-rerelease-precheck.sh](../scripts/mesh-rerelease-precheck.sh)

## 実施前チェック

- `kubectl get pods -n apps` で user-service、user-service-canary、sleep が起動している
- `kubectl get ns apps --show-labels` で sidecar 注入ラベルが付いている
- `kubectl get peerauthentication -n apps` で `apps-strict` の有無を確認した
- Grafana か `kubectl top pod -n apps` で観測先を決めた
- 問題が出たときに rollback を打つ担当者と判断基準を決めた

## リリース手順

1. canary 配置

```bash
bash scripts/mesh-release-preflight.sh
kubectl apply -k manifests/extensions/servicemesh-advanced
```

開始共有:

[release-communication-template.md](release-communication-template.md) の「開始連絡」を使って、10% canary 開始を共有する。

2. canary 混在の確認

```bash
bash scripts/mesh-canary-smoke-test.sh 50
```

3. 観測

```bash
bash scripts/mesh-release-observe.sh
bash scripts/mesh-release-summary.sh
```

確認するもの:

- 5xx が増えていないか
- レイテンシが悪化していないか
- user-service-canary だけ再起動していないか
- istio-proxy のログに目立つ接続失敗がないか
- CPU、Memory、restart の比較は [release-metrics.md](release-metrics.md) を基準にする
- Grafana 上の確認順序は [grafana-canary-checklist.md](grafana-canary-checklist.md) を基準にする
- Grafana の dashboard とパネル選択は [grafana-dashboard-guide.md](grafana-dashboard-guide.md) を基準にする

4. 昇格または切り戻し

判断の記録:

昇格前または切り戻し前に [release-decision-template.md](release-decision-template.md) を埋めて、根拠を残す。

判断の共有:

promote / rollback / hold のいずれでも、[release-communication-template.md](release-communication-template.md) の文面例を使ってチームへ共有する。

Hold の扱い:

Hold にした場合は、観測延長時間と再判断時刻をその場で決める。`後で見る` で止めない。

問題がなければ:

```bash
bash scripts/mesh-canary-promote.sh
```

問題があれば:

```bash
bash scripts/mesh-canary-rollback.sh
```

Rollback 後の証跡回収:

```bash
bash scripts/mesh-rollback-evidence.sh
```

その後 [rollback-investigation-template.md](rollback-investigation-template.md) に沿って、影響範囲、最初の仮説、次に確認することを残す。

改善アクション化:

調査だけで終わらせず、[preventive-action-template.md](preventive-action-template.md) に沿って、再発防止のアクションを `すぐやる / 後でやる` に分けて残す。

再リリース判定:

再度 canary を出す前に `bash scripts/mesh-rerelease-precheck.sh` を実行し、[rerelease-readiness-checklist.md](rerelease-readiness-checklist.md) に沿って、前回の失敗条件が潰れているかを確認する。

追跡監視:

```bash
bash scripts/mesh-release-postcheck.sh
```

その後 [release-followup-checklist.md](release-followup-checklist.md) に沿って、promote 後または rollback 後の状態確認を行う。

## 切り戻し判断の目安

- API の 5xx が継続して増える
- レイテンシが継続して悪化する
- sidecar やアプリ Pod の再起動が増える
- 利用者影響が出始めている

原因調査は重要ですが、影響が進行中なら rollback を先に打つ方が安全です。

## 昇格判断の目安

- smoke test が安定して通る
- 監視上の異常がない
- canary 側だけに偏ったエラーが出ていない
- 観測時間を事前に決めた基準以上確保した
- stable と canary の差分を指標で説明できる

## 実務での会話例

- 「まず 10% で出し、5xx とレイテンシを 15 分見ます。問題があれば stable 100% へ戻します。」
- 「原因調査は rollback 後に続けます。今は利用者影響を止めることを優先します。」
- 「昇格前に canary 側の Pod 再起動回数と istio-proxy のエラーを確認します。」
- 「判断材料が足りないので 10 分 Hold し、追加観測後に再判断します。」
- 「rollback は完了しました。まず証跡を保存し、利用者影響の範囲と次の調査担当を切り分けます。」
- 「初動調査メモは残したので、再リリース前に必要な対策と恒久対応を分けてタスク化します。」
- 「再リリース前チェックで、前回の失敗条件が解消したことと監視条件の見直しを確認してから 10% canary を再開します。」

## 最低限の確認コマンド

```bash
kubectl get pods -n apps
kubectl get virtualservice -n apps
kubectl describe virtualservice user-service-canary -n apps
kubectl logs -l app.kubernetes.io/name=user-service-canary -n apps -c istio-proxy --tail=100
kubectl top pod -n apps
bash scripts/mesh-canary-smoke-test.sh 50
bash scripts/mesh-release-observe.sh
bash scripts/mesh-release-summary.sh
```

## この runbook で学ぶこと

- manifest を apply するだけでは運用にならないこと
- rollout、observe、rollback、promote を 1 セットで考えること
- service mesh は routing 機能だけでなく、変更の安全性を高める道具だということ
- release 前の preflight と、release 後の判断記録が実務では重要なこと
- 技術判断を、短く正確なチーム共有へ変換することも実務では重要なこと
- promote / rollback の直後に追跡監視して、結果を閉じることも実務では重要なこと
- rollback 後は証跡を回収し、原因調査の出発点を残すことも実務では重要なこと
- rollback 後の調査を、再発防止アクションへ落とすことも実務では重要なこと
- rollback 後の改善を確認し、再リリース可否を明確に判定することも実務では重要なこと