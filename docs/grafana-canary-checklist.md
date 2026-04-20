# Grafana Canary Checklist

この資料は、canary リリース中に Grafana をどの順番で確認するかを実務向けに整理したチェックリストです。目的は、ダッシュボードを眺めることではなく、`昇格してよいか` と `今すぐ戻すべきか` を短時間で判断できるようにすることです。

## まず見る順番

1. user-service と user-service-canary の Pod 再起動回数
2. user-service と user-service-canary の CPU 使用傾向
3. user-service と user-service-canary の Memory 使用傾向
4. 5xx や接続失敗の兆候
5. 安定しているなら観測時間を満たしたか確認する

## 1. 再起動回数

最初に見る理由:

- canary 側だけ落ち続けていると、その時点で昇格候補から外れるため
- 再起動はアプリ異常、設定ミス、リソース不足の早い兆候になりやすいため

見るポイント:

- stable に比べて canary の restart が増えていないか
- 直近数分で連続増加していないか

## 2. CPU 使用傾向

次に見る理由:

- canary 側だけ過剰な負荷が出ていないかを早めに把握できるため

見るポイント:

- canary だけ継続的に高止まりしていないか
- stable と比べて不自然な差がないか

## 3. Memory 使用傾向

次に見る理由:

- leak やキャッシュ暴走のような問題は CPU より先に Memory で見えることがあるため

見るポイント:

- canary だけ右肩上がりで増え続けていないか
- stable と比較して極端な差がないか

## 4. 失敗兆候

見るポイント:

- 5xx が増えていないか
- timeout や upstream 接続失敗が増えていないか
- istio-proxy ログとアプリログの失敗が一致していないか

## 5. 観測時間

最後に見る理由:

- 短時間だけ正常でも、すぐ昇格すると見落としが出るため

見るポイント:

- 事前に決めた 10 分や 15 分などの観測時間を満たしたか
- その間に restart や error rate の増加がなかったか

## Go / No-Go の考え方

Go の例:

- smoke test が通る
- canary 側だけの restart 増加がない
- stable と canary の CPU、Memory に大きな差がない
- 5xx や timeout が増えていない
- 観測時間を満たした

No-Go の例:

- canary 側だけ restart が増える
- canary 側だけ CPU や Memory が極端に高い
- 5xx や timeout が増える
- 観測時間が短く、まだ判断材料が足りない

## 実務での会話例

- 「まず restart を見ます。そこで差があるなら即 rollback 候補です。」
- 「CPU と Memory に差がなければ、次に 5xx と timeout を見ます。」
- 「15 分の観測を満たして異常がなければ promote を検討します。」

## 一緒に使う資料

- [release-runbook.md](release-runbook.md)
- [release-metrics.md](release-metrics.md)
- [../scripts/mesh-release-observe.sh](../scripts/mesh-release-observe.sh)
- [../scripts/mesh-release-summary.sh](../scripts/mesh-release-summary.sh)