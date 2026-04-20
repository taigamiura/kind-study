# Handson 47

## テーマ

Container と Linux の基礎を Kubernetes 文脈で学ぶ。

## 今回のゴール

- container が仮想マシンではないことを説明できる
- PID 1、signal、filesystem 権限、non-root 実行の意味を説明できる
- `Pod が再起動する`, `終了しない`, `書き込みできない` を container 基礎で切り分けられる

## この回で先に押さえる用語

- PID 1
- cgroup
- namespace Linux
- non-root
- distroless

## 対応ファイル

- [container-linux-guide.md](container-linux-guide.md)
- [scripts/container-runtime-check.sh](../scripts/container-runtime-check.sh)

## この回で実際にやること

1. [container-linux-guide.md](container-linux-guide.md) を読み、VM と container の違いを整理する
2. `bash scripts/container-runtime-check.sh apps` を実行して Pod の image、user、securityContext を観察する
3. `PID 1 が signal を受ける` と rollout stop の関係を自分の言葉で説明する
4. distroless と debug 性の trade-off を整理する

## 完了条件

- container が OS を丸ごと持つわけではないと説明できる
- non-root 実行の意味を説明できる
- signal と graceful shutdown の関係を説明できる

## 実務で見る観点


## よくある失敗


## 学ぶポイント


## 学ぶポイントの解説

Kubernetes を使っていると Pod や Deployment の概念へ意識が向きますが、実際に動く単位は container です。ここで Linux の基本を外すと、securityContext を設定してもなぜ壊れるのか分からず、調査が浅くなります。

実務では `この Pod がなぜ止まらないのか`, `なぜ readOnlyRootFilesystem で壊れるのか` を説明できることが強みになります。

## 詰まったときの確認ポイント

- image は何の user で動く想定か
- write が必要な場所はどこか
- graceful shutdown に必要な signal 処理はあるか
- debug 性と攻撃面削減のどちらを優先した設計か

## この回の後に必ずやること

1. 今の app を non-root で動かすと詰まりそうな点を 3 つ書く
2. root 前提の実装がないか manifest と image 設計を見直す
3. 説明に迷う点が残ったら [container-linux-guide.md](container-linux-guide.md) を読み直す

## この回の宿題

- distroless image を採用する利点と欠点を 2 つずつ書く
- graceful shutdown に必要なアプリ実装要素を整理する

次は [handson48.md](handson48.md) で Kubernetes 内部構造を学びます。