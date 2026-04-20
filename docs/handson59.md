# Handson 59

## テーマ

変更要求の受付から本番反映までを通しで実践する。

## 今回のゴール

- 変更要求を受けたあとに何を確認し、どの順番で進めるか説明できる
- 設計、review、テスト、観測、共有、rollback 準備を 1 本の流れでつなげられる
- `作業した` ではなく `安全に出せる根拠を持って進めた` と説明できる

## この回で先に押さえる用語

- Change Request
- Risk Assessment
- Go / No-Go
- Rollback Plan
- Evidence

## 対応ファイル

- [change-execution-scenario.md](change-execution-scenario.md)
- [production-readiness-review.md](production-readiness-review.md)
- [release-runbook.md](release-runbook.md)

## この回で実際にやること

1. [change-execution-scenario.md](change-execution-scenario.md) を読み、想定変更を理解する
2. 変更前確認、影響調査、rollback plan、観測項目を書き出す
3. handson15、18、26、27、28、46 の内容を使い、変更実行手順を自分の言葉で組み立てる
4. 実施後に何を確認し、誰へどう共有するかまで書く

## 完了条件

- 変更要求を安全に処理する手順を時系列で説明できる
- 変更前に必要な確認項目を列挙できる
- rollback plan と観測項目をセットで説明できる

## 実務で見る観点

- 変更の目的とリスクが結び付いているか
- 実施直前に再確認する項目が明確か
- 実施後の追跡監視まで設計されているか

## よくある失敗

- 変更内容だけ見て影響範囲を見ない
- rollback plan が抽象的すぎて使えない
- 実施後の監視と共有が抜ける

## 詰まったときの確認ポイント

- 何を変えるのか
- 何が壊れうるのか
- いつ止めるのか
- 何を見て成功とするのか
- 失敗したらどこまで戻すのか

## この回の後に必ずやること

1. 変更要求を 1 つ自分で作り、同じ流れをもう一度書く
2. 前提 handson のうち説明が弱い章へ戻って確認する
3. [production-readiness-review.md](production-readiness-review.md) を使って審査観点を確認する

## 本番前チェックリスト

- 変更目的が明確
- 影響範囲が整理済み
- rollback plan が具体的
- 監視項目が決まっている
- 共有文面が準備できている

## 学ぶポイント

- 実務の変更は apply 前よりも前段の確認で差が出る
- 変更と rollback はセットで設計するべきである
- `安全に進める根拠` を残せる人が実務で強い

## この回の宿題

- 自分で別の変更要求を 1 つ作り、同じ手順で実施計画を書く
- どこで Go / No-Go を判断するかを書き出す

次は [handson60.md](handson60.md) で障害訓練を行います。