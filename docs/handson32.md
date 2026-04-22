# Handson 32

## テーマ

canary リリース runbook を通しで学ぶ。

## 今回のゴール

- canary 運用全体を 1 本の流れとして説明できる
- preflight、observe、decision、followup、rerelease のつながりを理解する
- `manifest を apply する` だけでは運用にならない理由を説明できる

## この回で先に押さえる用語

- Preflight: 実施前の前提確認
- Observe: 観測
- Decision: Promote / Rollback / Hold の判断
- Follow-up: 判断後の追跡監視
- Re-release: rollback 後に再度出す流れ

## 対応ファイル

- [release-runbook.md](release-runbook.md)

## この回で実際にやること

1. [release-runbook.md](release-runbook.md) を先頭から読み、時系列を整理する
2. `preflight -> observe -> decision -> followup -> rerelease` の流れを 1 枚にまとめる
3. どこで手順を飛ばすと危険かを 3 つ挙げる
4. 自分の言葉で `この runbook が守っているもの` を説明する

## 完了条件

- canary 運用全体を通して説明できる
- 各ステップの目的を説明できる
- `なぜこの順番なのか` を言える

## 実務で見る観点

- runbook が `読む資料` でなく `そのまま使える手順` になっているか
- Promote / Rollback の判断が観測と結び付いているか
- 追跡監視や再リリース判定まで含めた運用になっているか

## よくある失敗

この回の失敗は、runbook を読んだだけで実運用できると思うと起きやすいです。箇条書きは別々に見えても、背景には `事前条件`, `観測`, `判断`, `切り戻し` の流れを通しで理解していないことがあります。

- preflight を飛ばして手順開始する
- decision だけ注目して observe や follow-up を軽く見る
- rerelease 条件を持たずに再実施してしまう

## 学ぶポイント

- canary は 1 つのコマンドではなく複数段階の運用である
- runbook は変更の安全性を上げるために存在する
- 実務では `出す`, `見る`, `戻す`, `学ぶ`, `再度出す` がつながっている

## 学ぶポイントの解説

リリースはアプリのデプロイ操作だけでは終わりません。特に canary は、変更を小さく出し、観測し、判断し、必要なら戻し、その学びを次に生かす一連の運用です。runbook はその流れを人に依存しない形にするための道具です。

この回では、個別の template や checklist を点ではなく線で理解します。ここがつながると、運用は急に実務らしくなります。

## この回の宿題

- runbook の中で `絶対に飛ばしてはいけない工程` を 3 つ選ぶ
- `この runbook がないと起きやすい事故` を 2 つ挙げる

次は [handson33.md](handson33.md) で DB 復旧 runbook を学びます。