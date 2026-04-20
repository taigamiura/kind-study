# Handson 57

## テーマ

性能試験、profiling、性能劣化の詰め方を学ぶ。

## 今回のゴール

- `遅い` を CPU、memory、network、DB、アプリ実装に分けて考えられる
- load test と profiling の役割差を説明できる
- CPU throttling や connection pool の問題を観点として持てる

## この回で先に押さえる用語

- load test
- profiling
- CPU throttling
- p95 / p99 latency
- connection pool

## 対応ファイル

- [performance-tuning-guide.md](performance-tuning-guide.md)
- [scripts/performance-observe.sh](../scripts/performance-observe.sh)

## この回で実際にやること

1. [performance-tuning-guide.md](performance-tuning-guide.md) を読む
2. `bash scripts/performance-observe.sh apps` を実行して top と requests / limits を確認する
3. `高 CPU`, `高 latency`, `memory 増加`, `DB 待ち` をどう切り分けるか整理する
4. p95 / p99 を見る理由を説明する

## 完了条件

- load test と profiling の違いを説明できる
- CPU throttling の意味を説明できる
- 遅延分析の基本順序を説明できる

## 実務で見る観点

- 平均値だけでなく tail latency を見ているか
- requests / limits と実負荷の乖離を確認しているか
- DB、アプリ、network のどこが律速か切り分けているか

## よくある失敗

- 遅い原因をすべてアプリコードのせいにする
- 平均 latency だけ見て安心する
- throttling や GC を見ずに Node 増強へ走る

## 学ぶポイント

- 性能問題は勘ではなく観測と仮説検証で詰める
- Kubernetes では resource 制限そのものが遅延原因になることがある
- load test、profiling、metrics、logs を組み合わせるのが実務的である

## 詰まったときの確認ポイント

- 平均値だけを見ていないか
- CPU、memory、DB、network のどこが律速か分けられているか
- throttling や pool 枯渇を疑えているか

## この回の後に必ずやること

1. 高 latency のときの確認順を時系列で書く
2. metrics、logs、traces、profiling の役割分担を整理する
3. [performance-tuning-guide.md](performance-tuning-guide.md) を見て抜けている観点を補う

## この回の宿題

- 高 latency の調査手順を時系列で書く
- 平均値だけでは見落とす問題を挙げる

次は [handson58.md](handson58.md) で team 運用を学びます。