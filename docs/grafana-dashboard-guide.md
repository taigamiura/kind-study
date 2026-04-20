# Grafana Dashboard Guide

この資料は、Grafana を開いたあとに「どの dashboard を見ればよいか」で迷わないための実務向けガイドです。目的は、canary 中に必要な情報へ最短で到達することです。

## 先に結論

canary 判断では、次の順で dashboard を開くと追いやすいです。

1. Kubernetes / Compute Resources / Namespace (Pods)
2. Kubernetes / Compute Resources / Pod
3. Kubernetes / Compute Resources / Node
4. 必要なら PostgreSQL や exporter 系 dashboard

環境や chart のバージョンで dashboard 名が多少違うことはありますが、`Kubernetes`, `Compute Resources`, `Pods`, `Node` を含む名前を優先して探してください。

## 1. Namespace (Pods) dashboard

最初に開く理由:

- `apps` namespace 全体を俯瞰できるため
- stable と canary を同じ画面で比較しやすいため

見るパネル:

- CPU usage
- Memory usage
- Pod restarts
- Running pods

見るポイント:

- `user-service` と `user-service-canary` に大きな差がないか
- canary 側だけ restart が増えていないか

## 2. Pod dashboard

次に開く理由:

- 特定 Pod に絞って異常を確認できるため

見るパネル:

- CPU per pod
- Memory per pod
- Network I/O
- Container restarts

見るポイント:

- canary Pod だけ CPU や Memory が高止まりしていないか
- restart や network error が canary 側だけに偏っていないか

## 3. Node dashboard

必要に応じて開く理由:

- Pod ではなく Node 側の問題で揺れている可能性を除外するため

見るパネル:

- Node CPU
- Node Memory
- Node Network
- Disk pressure や resource saturation の兆候

見るポイント:

- canary 異常に見えても、実は Node 側飽和ではないか
- 特定 Node だけ高負荷で、Pod 差分ではない問題がないか

## 4. PostgreSQL や exporter 系 dashboard

見る理由:

- API 側の change でも DB 接続や backend 側負荷に影響が出ることがあるため

見るパネル:

- active connections
- slow queries に近い兆候
- exporter health

見るポイント:

- canary 適用後に DB 接続数や backend 負荷が不自然に増えていないか

## 実務の見方

### まず 3 分で見るもの

- Namespace (Pods) で restart と CPU
- Pod dashboard で canary の CPU、Memory
- 5xx や timeout の兆候

### 次の 10 分で見るもの

- Memory が右肩上がりで増えていないか
- restart が時間経過で増えていないか
- stable と canary の差が継続していないか

### 判断に迷ったら

- Pod 単体の異常か
- namespace 全体の揺れか
- Node 側要因か

この 3 つに分けて見直してください。

## Go / No-Go を dashboard で考える

Go の例:

- canary 側の restart 増加がない
- CPU、Memory が stable と比べて大きく乖離していない
- dashboard 上で 5xx や timeout の兆候が見えない

No-Go の例:

- canary 側だけ restart が増える
- canary 側だけ Memory が増え続ける
- CPU 高騰や network error が canary 側に偏る

## 一緒に使う資料

- [grafana-canary-checklist.md](grafana-canary-checklist.md)
- [release-metrics.md](release-metrics.md)
- [release-runbook.md](release-runbook.md)