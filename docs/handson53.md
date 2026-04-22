# Handson 53

## テーマ

Autoscaling、capacity planning、cost の考え方を学ぶ。

## 今回のゴール

- HPA だけで autoscaling が完結しない理由を説明できる
- Node 数、Pod requests、実負荷、コストがつながっていると理解する
- `どれだけ必要か` を見積もる発想を持てる

## この回で先に押さえる用語

- Cluster Autoscaler
- VPA
- capacity planning
- bin packing
- overprovisioning

## 対応ファイル

- [autoscaling-cost-guide.md](autoscaling-cost-guide.md)
- [scripts/capacity-observe.sh](../scripts/capacity-observe.sh)

## この回で実際にやること

1. [autoscaling-cost-guide.md](autoscaling-cost-guide.md) を読む
2. `bash scripts/capacity-observe.sh apps` を実行して requests と current usage の見方を確認する
3. HPA、VPA、Cluster Autoscaler の役割分担を整理する
4. `必要な headroom` をなぜ残すべきか言語化する

## このコマンドで確認するのはここ

- `bash scripts/capacity-observe.sh apps`: Pod ごとの current usage、requests / limits、Node 側余力、過大/過小な requests を見る
- capacity planning では: 平常時と高負荷時で headroom が残るか確認する

## 完了条件

- HPA、VPA、Cluster Autoscaler の違いを説明できる
- capacity planning の必要性を説明できる
- requests の過大 / 過小設定が何を壊すか説明できる

## 実務で見る観点

- スケールする対象が Pod なのか Node なのかを分けて考えているか
- resource 要求が実測と乖離していないか
- 可用性確保の headroom とコスト最適化のバランスを取れているか

## よくある失敗

この回の失敗は、autoscaling と cost を別テーマとして切り離すと起きやすいです。箇条書きは別々に見えても、背景には `増やせること` と `増やしてよいこと` を分けて考えていないことがあります。

- HPA だけ導入して終わる
- requests を大きくしすぎてコストを浪費する
- 余裕を削りすぎて障害時の burst を受けられない

## 学ぶポイント

- autoscaling は HPA 単体でなく Pod、Node、予測の全体設計である
- cost 最適化は requests / limits と scheduling に直結する
- capacity planning は高負荷イベント前に最も効く

## 詰まったときの確認ポイント

- Pod を増やす問題か Node を増やす問題か分けられているか
- 実測と requests がどの程度ずれているか
- headroom を削りすぎていないか

## この回の後に必ずやること

1. 平常時と高負荷時の必要リソースを分けて考える
2. 現状の requests / limits が過大か過小かを書き出す
3. [autoscaling-cost-guide.md](autoscaling-cost-guide.md) を見て改善案を 3 つ出す

## この回の宿題

- HPA と Cluster Autoscaler の連携が必要なシナリオを書く
- requests を 2 倍に見積もった場合の悪影響を整理する

次は [handson54.md](handson54.md) で External Secrets を学びます。