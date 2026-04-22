# Handson 58

## テーマ

Platform Team、SRE、運用当番の実務を学ぶ。

## 今回のゴール

- Kubernetes 運用が技術だけでなく team 設計でも成り立つと理解する
- Platform Team と application team の責任境界を説明できる
- on-call、error budget、運用当番の考え方を説明できる

## この回で先に押さえる用語

- Platform Team
- SRE
- on-call
- error budget
- service ownership

## 対応ファイル

- [team-operations-guide.md](team-operations-guide.md)

## この回で実際にやること

1. [team-operations-guide.md](team-operations-guide.md) を読む
2. Platform Team と application team の責務を分けて書く
3. on-call と incident commander の違いを整理する
4. error budget が開発速度の意思決定にどう効くか説明する

## 完了条件

- Platform Team の役割を説明できる
- on-call 設計で考えるべき点を説明できる
- error budget の用途を説明できる

## 実務で見る観点

- サービスごとの責任者が明確か
- 障害時の一次対応と意思決定の役割が分かれているか
- platform 側とアプリ側の境界が曖昧で疲弊していないか

## よくある失敗

この回の失敗は、体制設計を役職名の話だけで終わらせると起きやすいです。箇条書きは別々に見えても、背景には `誰がどの判断を持ち, どこで引き継ぐか` の整理不足があります。

- platform 側が全部背負う
- ownership が曖昧でアラートの受け手が不明
- reliability 目標と開発速度の議論がつながっていない

## 学ぶポイント

- 実務即戦力になるには Kubernetes 操作だけでなく組織運用の理解が必要である
- SRE の考え方は技術とチーム運用をつなぐ
- error budget は `止めるため` でなく `判断するため` の道具である

## 学ぶポイントの解説

本番 Kubernetes は YAML を書けるだけでは回りません。誰が面倒を見るか、誰が障害を受けるか、どこまで platform が持ち、どこからアプリ team が責任を持つかが曖昧だと、技術的には正しくても運用は崩れます。

この回まで進めると、単に cluster を触れるだけでなく、実務の現場で何が要求されるかまで視野に入ります。

## 詰まったときの確認ポイント

- ownership が曖昧でないか
- on-call と意思決定の役割が混ざっていないか
- error budget を運用判断へ結び付けられているか

## この回の後に必ずやること

1. Platform Team と application team の境界を文章で書く
2. on-call で困りそうな点を 5 つ挙げる
3. [team-operations-guide.md](team-operations-guide.md) を見て体制設計の不足を確認する

## この回の宿題

- 自分が想定する team で Platform Team と application team の責務境界を書く
- error budget を使って feature 開発を止める判断例を考える

次は [handson59.md](handson59.md) で、ここまでの知識を `変更要求を受けて本番へ出す` という 1 本の実務シナリオにまとめて実践します。