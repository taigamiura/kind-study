# Handson 70

## テーマ

OpenTelemetry と log pipeline の実装設計を学ぶ。

## 今回のゴール

- metrics、logs、traces を collector ベースでどう扱うか説明できる
- sampling、retention、PII マスキングの必要性を説明できる
- `観測できる` と `安全に観測運用できる` の差を理解する

## この回で先に押さえる用語

- collector
- sampling
- retention
- PII
- log pipeline

## 対応ファイル

- [opentelemetry-observability-guide.md](opentelemetry-observability-guide.md)
- [manifests/extensions/observability/collector-configmap-sample.yaml](../manifests/extensions/observability/collector-configmap-sample.yaml)

## この回で実際にやること

1. [opentelemetry-observability-guide.md](opentelemetry-observability-guide.md) を読む
2. sample collector config を見て pipeline を読む
	sample は collector の考え方をつかむ最小構成であり、そのまま本番投入する前提ではないことも確認する
3. log / trace の保存期間とマスキング方針を整理する
4. 監視コストと観測価値のバランスを言語化する

## 完了条件

- collector の役割を説明できる
- sampling の必要性を説明できる
- PII を log に残さない理由を説明できる

## 実務で見る観点

- 何をどこへ送るか整理されているか
- log / trace を無制限保存していないか
- 個人情報や token を観測基盤へ流していないか


## 詰まったときの確認ポイント

- collector の役割を説明できるか
- sampling をコスト最適化だけの話だと思っていないか
- PII の混入経路を洗い出せているか

## この回の後に必ずやること

1. 収集対象ごとの retention を決める
2. log / trace に入れてはいけない値を列挙する
3. [opentelemetry-observability-guide.md](opentelemetry-observability-guide.md) と collector sample を見て pipeline を説明できるか確認する

## この回の宿題

- log と trace の retention 方針を書く
- PII が混入しやすいポイントを列挙する

## 学ぶポイント

- observability は収集量を増やすほど良いわけではない
- collector を理解すると metrics、logs、traces を一体で設計しやすい
- log / trace はコストとコンプライアンスの両面で設計が必要である

## 学ぶポイントの解説

可観測性の導入でありがちな失敗は、全部集めて後で考えることです。実務ではコスト、保存期間、PII 混入、検索しやすさまで設計しないと、観測基盤そのものが負債になります。

collector の役割を理解すると、アプリから直接各基盤へ送るよりも、どこで加工し、どこで落とし、どこへ送るかを一元化しやすくなります。ここは運用のしやすさに直結します。

次は [handson71.md](handson71.md) でアプリ実装規約を学びます。