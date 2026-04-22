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

## 確認するとしたらどこを見るか

- capacity review では requests、limits、actual usage、replica 数、node 余力を別々でなく一緒に見る
- 平常時だけでなく、高負荷時と障害時に headroom が残るか確認する

## 完了条件

- scaling と capacity の見直し案を出せる
- 過剰 requests と不足 headroom の問題を説明できる
- cost 最適化で削ってはいけないものを説明できる

## 学ぶポイント

- capacity review は節約だけでなく事故防止でもある
- 実務では最適値より説明可能な判断が重要である
- scaling 設計は observability とセットで改善するべきである

## この回の宿題

- 需要変動が大きいサービスの capacity 方針を書く
- 削ってよいコストと削ってはいけないコストを分ける

次は [handson63.md](handson63.md) で production readiness review を行います。