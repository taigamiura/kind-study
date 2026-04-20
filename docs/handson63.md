# Handson 63

## テーマ

production readiness review を実践する。

## 今回のゴール

- 本番投入前に何を審査すべきかを体系的に説明できる
- 監視、復旧、権限、セキュリティ、変更管理、運用体制を一体で確認できる
- `動く` と `本番に出せる` の差を説明できる

## 対応ファイル

- [production-readiness-review.md](production-readiness-review.md)

## この回で実際にやること

1. [production-readiness-review.md](production-readiness-review.md) の全項目を確認する
2. 未充足項目を一覧化する
3. `本番投入可`, `条件付き可`, `不可` の 3 段階で判定する
4. 判定理由と未充足項目の改善順序を書く

## 完了条件

- readiness review の観点を説明できる
- 判定と根拠を文章で残せる
- 本番投入前の不足を改善タスクへ落とせる

## 学ぶポイント

- readiness review は技術レビューより広い
- 本番投入可否は単一の観点で決めない
- 未充足事項を言語化できるほど実務に強い

## この回の宿題

- 自分の想定サービスに対する readiness review 結果を書く
- `不可` と判断する基準を明確に書く

次は [handson64.md](handson64.md) で再構築訓練を行います。