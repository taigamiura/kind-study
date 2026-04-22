# Handson 73

## テーマ

監査、データ保護、コンプライアンス対応を学ぶ。

## 今回のゴール

- 監査ログ、保持期間、データ分類、権限証跡の重要性を説明できる
- 技術要件と法令 / 契約要件の差を理解できる
- `動くシステム` と `監査に耐えるシステム` の差を説明できる

## この回で先に押さえる用語

- compliance
- audit trail
- retention
- data classification
- PII

## 対応ファイル

- [compliance-data-protection-guide.md](compliance-data-protection-guide.md)
- [docs/reviews/audit-evidence-template.md](reviews/audit-evidence-template.md)

## この回で実際にやること

1. [compliance-data-protection-guide.md](compliance-data-protection-guide.md) を読む
2. どのログと変更記録を監査証跡にするか整理する
3. データ分類ごとに保護方法を分ける
4. 権限申請、承認、変更記録をどこへ残すか書く

## 確認するとしたらどこを見るか

- 監査対応では audit trail、保持期間、データ分類、アクセス証跡が残るかを見る
- 技術的な安全性だけでなく、あとから説明責任を果たせる記録になっているか確認する

## 完了条件

- 監査証跡として何を残すべきか説明できる
- retention と data classification の意味を説明できる
- コンプライアンス要求が設計へどう効くか説明できる

## 実務で見る観点

- 誰が何を変更したか追えるか
- 個人情報や機密情報の扱いが分類されているか
- 保持期間と削除方針が決まっているか


## 詰まったときの確認ポイント

- 技術ログと監査証跡を同じものだと思っていないか
- data classification によって扱いが変わることを理解しているか
- retention と削除方針がセットで考えられているか

## この回の後に必ずやること

1. 監査で提出できる証跡の保管先を整理する
2. データ分類ごとに保護方法を分ける
3. [compliance-data-protection-guide.md](compliance-data-protection-guide.md) と [audit-evidence-template.md](reviews/audit-evidence-template.md) を見て証跡不足を確認する

## この回の宿題

- 監査で出せるべき証跡を 10 個挙げる
- データ分類ごとの取扱差を整理する

## 学ぶポイント

- 監査に耐える運用は技術だけでなく記録設計で決まる
- data classification を持つと保護レベルを説明しやすい
- retention と削除方針がない運用は後で大きな問題になりやすい

## 学ぶポイントの解説

本番では、動いていること自体より `誰が変えたか`, `どこに記録があるか`, `機密データをどう扱ったか` を問われる場面があります。ここが弱いと、障害対応ができても監査に通りません。

実務で強いのは、技術的な構成だけでなく、証跡、承認、保持期間を設計として説明できる状態です。

次は [handson74.md](handson74.md) で外部依存を学びます。