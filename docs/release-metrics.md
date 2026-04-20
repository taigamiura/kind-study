# Release Metrics

この資料は、handson18 の canary リリースで「何を見て昇格判断するか」を具体化するための観測ガイドです。目的は、`大丈夫そう` という感覚ではなく、`どの指標を見て問題なしと判断したか` を言えるようにすることです。

## 最低限見る項目

- smoke test の成功状況
- stable と canary の CPU 使用傾向
- stable と canary の Memory 使用傾向
- stable と canary の Pod 再起動回数
- istio-proxy やアプリログに目立つ接続失敗がないか

## まず見る順番

1. [scripts/mesh-canary-smoke-test.sh](../scripts/mesh-canary-smoke-test.sh) で canary が混ざるか確認する
2. [scripts/mesh-release-observe.sh](../scripts/mesh-release-observe.sh) で Pod 状態、再起動、top を見る
3. Grafana で stable と canary の差が大きすぎないかを見る
4. 必要なら Prometheus の式で傾向を確認する

## kubectl で最低限見るもの

```bash
kubectl get pods -n apps -l 'app.kubernetes.io/name in (user-service,user-service-canary)'
kubectl top pod -n apps | grep user-service
kubectl logs -l app.kubernetes.io/name=user-service-canary -n apps -c istio-proxy --tail=100
```

## Prometheus で見やすい例

以下は kube-prometheus-stack で取りやすい、比較的汎用的な指標です。

### CPU 使用傾向

```promql
sum(rate(container_cpu_usage_seconds_total{namespace="apps",pod=~"user-service(-canary)?-.*",container!="POD"}[5m])) by (pod)
```

### Memory 使用量

```promql
sum(container_memory_working_set_bytes{namespace="apps",pod=~"user-service(-canary)?-.*",container!="POD"}) by (pod)
```

### Pod 再起動回数

```promql
max(kube_pod_container_status_restarts_total{namespace="apps",pod=~"user-service(-canary)?-.*"}) by (pod)
```

## どう見ればよいか

- CPU: canary だけ継続的に高すぎないか
- Memory: canary だけ増え続けていないか
- Restart: canary 側だけ増えていないか
- Smoke Test: stable と canary が意図した割合で返るか

## 異常とみなす考え方

- canary 側だけ再起動が増える
- canary 側だけ CPU や Memory が極端に高い
- smoke test が失敗する、または canary が混ざらない
- ログに接続失敗や timeout が継続して出る

しきい値はシステムごとに違いますが、重要なのは「stable と比べて不自然な差があるか」を見ることです。

## 昇格判断の例

- 10% canary を 15 分観測した
- smoke test が継続成功した
- stable と canary の CPU、Memory、restart に大きな差がない
- 利用者影響につながるエラーが見えない

この状態なら昇格を検討できます。逆に、差分を説明できないなら昇格を急がない方が安全です。

## 切り戻し判断の例

- canary 側だけ restart が増える
- canary 側だけ `kubectl top` の数値が不自然に高い
- istio-proxy ログに接続失敗が連続する
- smoke test が失敗する

この場合は、まず [scripts/mesh-canary-rollback.sh](../scripts/mesh-canary-rollback.sh) で stable 100% へ戻し、その後に原因を調査します。

## この資料で学ぶこと

- 監視はダッシュボードを見るためではなく、リリース判断の根拠を作るためにあること
- canary の成否は `出せたか` ではなく `安全に観測して戻せるか` で考えること
- stable と canary の比較が、実務の昇格判断で重要になること