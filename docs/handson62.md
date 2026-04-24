# Handson 62

## テーマ

capacity、cost、scaling のレビューを実践する。

## 今回のゴール

- requests / limits / actual usage / replica / node 数を一緒にレビューできる
- 過剰設計と不足設計の両方を見抜ける
- 需要変動を前提に capacity を考えられる

## 対応ファイル

- [capacity-cost-review-checklist.md](capacity-cost-review-checklist.md)
- [autoscaling-cost-guide.md](autoscaling-cost-guide.md)

## この回で実際にやること

1. [capacity-cost-review-checklist.md](capacity-cost-review-checklist.md) を使って現状を棚卸しする
2. handson13、39、41、53 を参照して改善案を書く
3. `負荷急増時`, `平常時`, `夜間低負荷` の 3 パターンを想定して見直す
4. cost と可用性の trade-off を文章で説明する

## この回だけで押さえる整理

capacity review は `CPU が高いか低いか` を見る回ではありません。requests、limits、実負荷、replica 数、Node 余力、HPA の動き、障害時の headroom を一緒に見て、`今の設計で安全に増減できるか` を判断する回です。

判断の基本は 3 パターンで分けると分かりやすいです。

- 平常時: 無駄に大きすぎる requests でコストを浪費していないか
- 高負荷時: HPA や手動 scale が効いても Node 側に空きがあるか
- 障害時: Node 1 台を失っても残りで最低限の replica を維持できるか

ここで大事なのは、`節約` と `事故防止` が同じ設計の裏表だということです。requests を削りすぎれば burst に耐えられず、逆に盛りすぎれば bin packing が悪化してコストもスケールも重くなります。

## 確認するとしたらどこを見るか

- capacity review では requests、limits、actual usage、replica 数、node 余力を別々でなく一緒に見る
- 平常時だけでなく、高負荷時と障害時に headroom が残るか確認する

## 完了条件

- scaling と capacity の見直し案を出せる
- 過剰 requests と不足 headroom の問題を説明できる
- cost 最適化で削ってはいけないものを説明できる

## 実務で見る観点

- requests をいじると HPA、scheduling、quota へどう波及するか説明できるか
- cost 削減が observability、HA、余力設計を壊していないか
- `平常時は安いが障害時に持たない` 構成になっていないか

## よくある失敗

- 平常時の CPU 使用率だけ見て requests を削りすぎる
- Pod 数だけ増やせばよいと思い、Node 側余力を見ない
- コスト最適化の名目で監視や headroom を削る

## 学ぶポイントの解説

capacity planning が難しいのは、未来の需要を完全には読めないからです。だからこそ、説明可能な前提を置き、平常時、高負荷時、障害時の 3 面で設計を語れることが重要になります。

また、Kubernetes では requests が scheduling と cost の両方へ効きます。つまり単なる `予約値` ではなく、クラスタ全体の使い方を決める経営的な数字でもあります。ここを理解すると、capacity review が単なる性能確認ではなく運用設計だと分かります。

## 学ぶポイント

- capacity review は節約だけでなく事故防止でもある
- 実務では最適値より説明可能な判断が重要である
- scaling 設計は observability とセットで改善するべきである

## この回の宿題

- 需要変動が大きいサービスの capacity 方針を書く
- 削ってよいコストと削ってはいけないコストを分ける

次は [handson63.md](handson63.md) で production readiness review を行います。