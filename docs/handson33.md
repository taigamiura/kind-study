# Handson 33

## テーマ

PostgreSQL の backup / restore runbook を通しで学ぶ。

## 今回のゴール

- DB 復旧を `運用の保険` として説明できる
- backup と restore を別工程として捉えられる
- RPO / RTO を前提に復旧手順を見る発想を持てる

## この回で先に押さえる用語

- Backup: データ退避
- Restore: 復旧操作
- RPO: 許容できるデータ損失
- RTO: 許容できる復旧時間
- Consistency: データ整合性

## 対応ファイル

- [backup-restore-runbook.md](backup-restore-runbook.md)

## この回で実際にやること

1. [backup-restore-runbook.md](backup-restore-runbook.md) を読み、backup と restore を分けて整理する
2. RPO / RTO を前提に運用手順を見直す
3. `backup があっても復旧できない状況` を考える
4. 復旧後に何を確認して完了とするかを整理する

## 完了条件

- DB 復旧の流れを説明できる
- RPO / RTO の観点で手順を見直せる
- restore 後の確認項目を説明できる

## 実務で見る観点

- backup 頻度が業務の重要度と合っているか
- restore 訓練が定期的にできているか
- 復旧後にアプリ接続確認まで含めているか

## よくある失敗

この回の失敗は、backup / restore を 1 つの作業として見てしまうと起きやすいです。箇条書きは別々に見えても、背景には `取得`, `保管`, `復旧確認` を別工程として捉える視点の不足があります。

- backup だけ取って restore 演習をしていない
- dump の取得時刻や保存場所が曖昧
- restore 後に DB が戻っただけでアプリ確認をしない

## 学ぶポイント

- DB 運用では `取る` より `戻せる` が重要である
- RPO / RTO があると backup / restore の設計が具体化する
- stateful workload の運用は deployment より深い確認が必要である

## 学ぶポイントの解説

Kubernetes を使っていても、DB 運用の本質は変わりません。PVC があるだけでは論理破損は戻せないため、backup と restore は別の能力として鍛える必要があります。特に開発エンジニアは、Pod が動くこととデータが守られることを混同しやすいため、この違いを意識するのが重要です。

runbook として読むことで、復旧の流れが手元のコマンドから業務要求へつながります。ここまで理解すると、DB を `置いているだけ` から `運用している` へ進みます。

## この回の宿題

- 自分のシステムで許容できる RPO / RTO を 1 組書く
- restore 完了後に確認すべき項目を 5 つ挙げる

次は [handson34.md](handson34.md) で Secret / Certificate rotation を学びます。