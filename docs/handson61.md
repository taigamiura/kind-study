# Handson 61

## テーマ

セキュリティレビューと是正計画を実践する。

## 今回のゴール

- workload、権限、Secret、image、network の観点でレビューできる
- 問題を見つけるだけでなく優先順位と是正計画まで書ける
- 例外運用を安全に扱う観点を持てる

## 対応ファイル

- [security-review-checklist.md](security-review-checklist.md)
- [pod-security-guide.md](pod-security-guide.md)
- [policy-as-code-guide.md](policy-as-code-guide.md)

## この回で実際にやること

1. [security-review-checklist.md](security-review-checklist.md) を使って現状を棚卸しする
2. 重大度を high / medium / low に分ける
3. handson38、43、49、50、51、54 を参照して是正計画を書く
4. `今すぐ直す`, `期限付き例外`, `後続改善` に分類する

## 確認するとしたらどこを見るか

- セキュリティレビューでは workload、権限、Secret、image、network の各観点で high/medium/low が区別できているかを見る
- 問題一覧だけでなく、是正順序と例外期限まで書けているか確認する

## 完了条件

- セキュリティレビュー結果を一覧化できる
- 重大度と是正優先度を説明できる
- 例外運用の扱いを説明できる

## 学ぶポイント

- セキュリティレビューは指摘の数でなく是正可能性が重要である
- 例外を管理しないとレビューは形だけになる
- 実務では `止める基準` と `直す順番` の両方が必要である

## この回の宿題

- high と判定した問題を 3 つ書く
- それぞれの暫定対策と恒久対策を書く

次は [handson62.md](handson62.md) で capacity と cost をレビューします。