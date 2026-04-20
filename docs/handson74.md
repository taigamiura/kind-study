# Handson 74

## テーマ

外部依存と egress 設計、連携障害対応を学ぶ。

## 今回のゴール

- Kubernetes 内だけで完結しない障害を想定できる
- 外部 API、認証基盤、DNS、メール基盤などの依存を設計に入れられる
- circuit breaker、timeout、retry の使い分けを説明できる

## この回で先に押さえる用語

- egress control
- circuit breaker
- retry
- timeout
- bulkhead

## 対応ファイル

- [external-dependency-resilience-guide.md](external-dependency-resilience-guide.md)

## この回で実際にやること

1. [external-dependency-resilience-guide.md](external-dependency-resilience-guide.md) を読む
2. 外部依存一覧を作る
3. retry、timeout、circuit breaker をどこへ入れるか整理する
4. `外部依存が落ちた時に全部巻き込まない` 設計を考える

## 完了条件

- 外部依存が main failure mode になりうると説明できる
- circuit breaker と retry の違いを説明できる
- egress 設計の必要性を説明できる

## 実務で見る観点

- クラスタ外依存が可視化されているか
- timeout や retry が無制限でないか
- 全機能が 1 依存先障害で巻き込まれないか


## 詰まったときの確認ポイント

- 外部依存を一覧化できているか
- retry が障害拡大要因にならないか
- timeout、circuit breaker、bulkhead を役割分担できているか

## この回の後に必ずやること

1. 外部依存の failure mode を 1 つずつ書く
2. degrade 方針と完全停止条件を分けて整理する
3. [external-dependency-resilience-guide.md](external-dependency-resilience-guide.md) を見て障害設計の不足を確認する

## この回の宿題

- 外部依存先一覧を作る
- 各依存先が落ちた場合の degrade 方針を書く

## 学ぶポイント

- 本番障害の多くはクラスタ内より外部依存で起きる
- retry は救済策にも増幅器にもなる
- egress 設計はネットワークと障害設計の両方に関わる

## 学ぶポイントの解説

Kubernetes 内部をどれだけ整えても、外部 API や認証基盤や DNS が不安定なら、サービス全体は不安定になります。実務ではこの外部依存の failure mode を先に把握しているかどうかが重要です。

特に retry と timeout は、入れれば安全になるわけではありません。無制限 retry は障害増幅につながるため、circuit breaker や bulkhead と組み合わせて考える必要があります。

次は [handson75.md](handson75.md) で platform engineering を学びます。