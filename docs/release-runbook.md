# Release Runbook

この runbook は、handson18 の canary を実務寄りに運用するための手順書です。目的は、`apply すること` ではなく、`安全に出して、観測して、戻せること` を身につけることです。

## 使う対象

- [manifests/extensions/servicemesh-advanced/user-service-canary-virtualservice.yaml](../manifests/extensions/servicemesh-advanced/user-service-canary-virtualservice.yaml)
- [manifests/extensions/servicemesh-advanced/user-service-stable-only-virtualservice.yaml](../manifests/extensions/servicemesh-advanced/user-service-stable-only-virtualservice.yaml)
- [manifests/extensions/servicemesh-advanced/user-service-promote-canary-virtualservice.yaml](../manifests/extensions/servicemesh-advanced/user-service-promote-canary-virtualservice.yaml)
- [scripts/mesh-canary-smoke-test.sh](../scripts/mesh-canary-smoke-test.sh)
- [scripts/mesh-release-observe.sh](../scripts/mesh-release-observe.sh)
- [scripts/mesh-canary-rollback.sh](../scripts/mesh-canary-rollback.sh)
- [scripts/mesh-canary-promote.sh](../scripts/mesh-canary-promote.sh)
- [release-metrics.md](release-metrics.md)

## 実施前チェック

- `kubectl get pods -n apps` で user-service、user-service-canary、sleep が起動している
- `kubectl get ns apps --show-labels` で sidecar 注入ラベルが付いている
- `kubectl get peerauthentication -n apps` で `apps-strict` の有無を確認した
- Grafana か `kubectl top pod -n apps` で観測先を決めた
- 問題が出たときに rollback を打つ担当者と判断基準を決めた

## リリース手順

1. canary 配置

```bash
kubectl apply -k manifests/extensions/servicemesh-advanced
```

2. canary 混在の確認

```bash
bash scripts/mesh-canary-smoke-test.sh 50
```

3. 観測

```bash
bash scripts/mesh-release-observe.sh
```

確認するもの:

- 5xx が増えていないか
- レイテンシが悪化していないか
- user-service-canary だけ再起動していないか
- istio-proxy のログに目立つ接続失敗がないか
- CPU、Memory、restart の比較は [release-metrics.md](release-metrics.md) を基準にする

4. 昇格または切り戻し

問題がなければ:

```bash
bash scripts/mesh-canary-promote.sh
```

問題があれば:

```bash
bash scripts/mesh-canary-rollback.sh
```

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

## 最低限の確認コマンド

```bash
kubectl get pods -n apps
kubectl get virtualservice -n apps
kubectl describe virtualservice user-service-canary -n apps
kubectl logs -l app.kubernetes.io/name=user-service-canary -n apps -c istio-proxy --tail=100
kubectl top pod -n apps
bash scripts/mesh-canary-smoke-test.sh 50
bash scripts/mesh-release-observe.sh
```

## この runbook で学ぶこと

- manifest を apply するだけでは運用にならないこと
- rollout、observe、rollback、promote を 1 セットで考えること
- service mesh は routing 機能だけでなく、変更の安全性を高める道具だということ