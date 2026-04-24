# Handson 42

## テーマ

logging と tracing の実務的な使い分けを学ぶ。

## 今回のゴール

- metrics、logs、traces の役割分担を説明できる
- `Grafana で異常を見つける` だけで終わらず深掘りの流れを理解する
- logging / tracing 導入の価値とコストを両方説明できる

## この回で先に押さえる用語

- Logging: ログ収集と検索
- Tracing: リクエスト経路の追跡
- Correlation ID: リクエスト横断の識別子
- OpenTelemetry: telemetry 収集の標準
- Sampling: trace を一部だけ取る方法

## 対応ファイル

- [logging-tracing-guide.md](logging-tracing-guide.md)
- [scripts/logs-triage.sh](../scripts/logs-triage.sh)

## この回で実際にやること

1. [logging-tracing-guide.md](logging-tracing-guide.md) を読み、metrics / logs / traces の役割を整理する
2. `bash scripts/logs-triage.sh apps` で apps namespace のログ確認導線を試す
3. `どの障害なら logs で深掘りし、どの障害なら tracing が効くか` を分ける
4. correlation ID があると何が楽になるか言語化する

## この回だけで押さえる整理

observability では metrics、logs、traces を 1 つで済ませようとしないことが重要です。異常検知、事実確認、依存追跡の役割差を分けて使えるようになると、この回のゴールに届きます。

## このコマンドで確認するのはここ

- `bash scripts/logs-triage.sh apps`: warning / error ログ、対象 Pod 名、直近の失敗メッセージ、相関 ID の有無を見る
- metrics から logs へ降りるとき: `どの Pod のどの時間帯を見るべきか` が出力から分かるか確認する

## 完了条件

- metrics、logs、traces の役割分担を説明できる
- logging / tracing 導入の価値と運用コストを説明できる
- どの場面で trace が必要か具体例で言える

## 実務で見る観点

- metrics だけで見えない事実を logs で拾えているか
- 分散システムで依存先を trace できるか
- ログ収集コストや保存期間が無制限になっていないか

## よくある失敗

この回の失敗は、1 つの観測手段だけで原因まで追おうとすると起きやすいです。箇条書きは別々に見えても、背景には `metrics で気づき, logs/traces で確かめる` 役割分担の不足があります。

- すべてログへ頼ってノイズが増える
- metrics 異常を見ても該当ログへたどれない
- trace を全部保存してコストや負荷が重くなる

## 学ぶポイント

- metrics は異常検知、logs は事実確認、traces は依存関係の深掘りに強い
- observability は 1 つの道具で完結しない
- logging / tracing は導入するだけでなく検索しやすさとコスト設計が重要である

## 学ぶポイントの解説

metrics が強いのは `おかしい` を早く見つけるところです。しかし `なぜ` はログや trace がないと分からないことが多いです。特にサービス数が増えるほど、1 リクエストがどこで遅くなったかを trace できる価値が上がります。

一方で、logging / tracing は何でも取ればよいわけではありません。保存期間、サンプリング、相関 ID 設計まで含めて考える必要があります。

## この回の宿題

- `metrics で気づく障害`, `logs で分かる障害`, `traces でしか追いにくい障害` を 1 つずつ挙げる
- どのログを structured log にすべきか考える

次は [handson43.md](handson43.md) で Pod Security を学びます。