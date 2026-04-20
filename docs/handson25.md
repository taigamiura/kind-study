# Handson 25

## テーマ

Grafana の dashboard と panel の見方を学ぶ。

## 今回のゴール

- 目的に応じて開く dashboard を選べる
- `この障害ならこの dashboard` と紐付けて考えられる
- panel を見ても意味が分からない状態から抜け出す

## この回で先に押さえる用語

- Namespace Dashboard: namespace 単位で見る dashboard
- Pod Dashboard: Pod 単位で深掘る dashboard
- Node Dashboard: Node 側の問題を見る dashboard
- Resource Saturation: CPU / Memory が詰まり気味の状態
- Correlation: 複数の panel を関連づけて見ること

## 対応ファイル

- [grafana-dashboard-guide.md](grafana-dashboard-guide.md)

## この回で実際にやること

1. [grafana-dashboard-guide.md](grafana-dashboard-guide.md) を読み、最初に開く dashboard を決める
2. 各 dashboard で見る panel を整理する
3. `namespace で見る問題`, `pod で見る問題`, `node で見る問題` を分ける
4. 1 つの panel だけで判断せず、どの panel と組み合わせるか考える

## 完了条件

- 目的別に dashboard を選べる
- `この症状ならこの dashboard` を説明できる
- panel の値を単独でなく関連づけて読める

## 実務で見る観点

- dashboard を開く順序と、深掘りの順序が分かれているか
- Pod 問題なのか Node 問題なのかを切り分けられるか
- DB や exporter 側の確認が必要な場面を理解しているか

## よくある失敗

- すべて Pod dashboard だけで見ようとして切り分けが遅れる
- Node 問題をアプリ問題だと誤認する
- 1 つの panel の瞬間値だけを見て結論を出す

## 学ぶポイント

- dashboard は役割ごとに使い分けると強い
- panel 単体ではなく複数を組み合わせて読む必要がある
- `どこで見るか` が決まると障害調査の速度が上がる

## 学ぶポイントの解説

Grafana の扱いでつまずく理由の 1 つは、dashboard の粒度が違うことです。namespace 全体を見る画面と Pod 個別を見る画面では、分かることが違います。だからこそ、異常の大きさを把握してから深掘る順番が必要です。

実務では、まず namespace で全体傾向を見て、怪しい Pod を絞り、その後に Pod や Node の dashboard へ降りていきます。この `広く見てから狭く見る` 流れが定着すると、Grafana の情報量に飲まれにくくなります。

## この回の宿題

- `canary 側の Pod が怪しい`, `Node が詰まっている`, `DB が遅い` の 3 パターンで最初に開く dashboard を決める
- 自分が一番迷いやすい panel を 1 つ挙げ、何と組み合わせれば判断しやすいか書く

次は [handson26.md](handson26.md) でリリース判断の記録を学びます。