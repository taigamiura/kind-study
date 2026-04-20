# Release Communication Template

このテンプレートは、canary リリース中にチームへ状況共有するための文面例です。目的は、技術的には正しい判断を、周囲にも短く正確に伝えられるようにすることです。

## 基本方針

- 何をしているか
- 今の割合は何か
- 何を見ているか
- 次に何をするか

この 4 つが入っていれば、共有文は短くても実務では十分通用します。

## 1. 開始連絡

例:

`user-service の canary を 10% で開始します。15 分観測し、restart / CPU / Memory / 5xx を確認します。異常があれば stable 100% へ戻します。`

## 2. 観測中の共有

例:

`10% canary を継続観測中です。現時点では restart 増加なし、CPU/Memory に大きな差なし、5xx 増加なしです。予定どおり 15 分まで監視を継続します。`

## 3. Hold の共有

例:

`即時 rollback は不要ですが、canary 側の Memory 傾向を追加確認したいため昇格を保留します。観測を 10 分延長し、その後に再判断します。`

## 4. Rollback の共有

例:

`canary 側で restart 増加と upstream 接続失敗を確認したため、stable 100% へ rollback します。利用者影響の抑制を優先し、原因調査は切り戻し後に行います。`

## 5. Promote 完了の共有

例:

`10% canary を 15 分観測し、restart 増加なし、CPU/Memory 差分なし、5xx 増加なしを確認したため、canary を全量へ promote します。引き続き短時間監視を継続します。`

## 6. 追跡監視完了の共有

例:

`promote 後の追跡監視を 10 分実施し、restart 増加なし、5xx 増加なしを確認しました。今回のリリース監視はここでクローズします。`

rollback 後の例:

`rollback 後の追跡監視を 10 分実施し、stable 側で restart 増加なし、5xx 収束を確認しました。影響抑制を確認したため、次は原因調査へ移ります。`

## 書き方のコツ

- 判断だけでなく根拠も 1 行入れる
- `様子見します` ではなく、何分見るかを書く
- Hold のときは再判断時刻を書く
- rollback 時は `原因調査は後、影響抑制を先` を明確にする
- promote 時も `監視終了` とせず、短時間の継続監視を書く

## 悪い例

- `とりあえず大丈夫そうなので進めます`
- `何かおかしいので戻します`

これでは、何を見てそう判断したのかが伝わりません。

## 一緒に使う資料

- [release-runbook.md](release-runbook.md)
- [release-decision-template.md](release-decision-template.md)
- [release-metrics.md](release-metrics.md)
- [grafana-canary-checklist.md](grafana-canary-checklist.md)