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

## この回だけで押さえる整理

container は `小さな VM` ではありません。host OS の kernel を共有し、process と filesystem の見え方だけを隔離して動くため、Linux の process、signal、権限、書き込み先の理解がそのまま Kubernetes の挙動に出ます。`Pod が止まらない`, `readOnlyRootFilesystem で壊れる`, `non-root で起動しない` は Kubernetes 特有の魔法ではなく、container と Linux の前提から説明できます。

この回で特に重要なのは、PID 1 の役割です。container の中で PID 1 になった process は signal を受ける主体になるため、graceful shutdown が弱いアプリだと rollout や scale down のときにきれいに止まりません。`Deployment の問題` に見えても、根本は application process の止まり方です。

## このコマンドで確認するのはここ

- `bash scripts/container-runtime-check.sh apps`: image 名、実行 user、securityContext、root 前提の設定有無を見る
- container 挙動で詰まるとき: non-root 実行に耐えるか、書き込み先が root filesystem 依存でないかを見る

## 完了条件

- container が OS を丸ごと持つわけではないと説明できる
- non-root 実行の意味を説明できる
- signal と graceful shutdown の関係を説明できる

## 実務で見る観点

- image を変えると動く理由を、`base image 差し替え` ではなく user、filesystem、entrypoint の差として説明できるか
- distroless で攻撃面を減らす判断と、debug しづらさの trade-off を理解しているか
- securityContext を manifest 側だけの設定だと誤解せず、image 設計と一体で見ているか


## よくある失敗

この回の失敗は、コンテナと Linux の前提を Kubernetes の外の話だと思うと起きやすいです。箇条書きは別々に見えても、背景には `なぜその挙動が Pod 上で起きるか` の土台理解不足があります。


## 学ぶポイント


## 学ぶポイントの解説

Kubernetes を使っていると Pod や Deployment の概念へ意識が向きますが、実際に動く単位は container です。ここで Linux の基本を外すと、securityContext を設定してもなぜ壊れるのか分からず、調査が浅くなります。

実務では `この Pod がなぜ止まらないのか`, `なぜ readOnlyRootFilesystem で壊れるのか` を説明できることが強みになります。

## 詰まったときの確認ポイント

- image は何の user で動く想定か
- write が必要な場所はどこか
- graceful shutdown に必要な signal 処理はあるか
- debug 性と攻撃面削減のどちらを優先した設計か

## 学ぶポイント

- container 問題の多くは Linux process と filesystem の前提で説明できる
- non-root 実行は `セキュリティ設定` であると同時に `アプリが root 前提かをあぶり出す検査` でもある
- distroless は安全性を上げやすいが、運用・調査のしやすさとセットで判断する必要がある

## 学ぶポイントの解説

Kubernetes で起こる問題の一部は、実は manifest だけ見ても解けません。例えば Pod が終了しない場合、Deployment の rollout 戦略より先に、container の PID 1 が SIGTERM を受けてどう振る舞うかを疑う必要があります。ここが理解できると、`Kubernetes が悪い` と誤認しにくくなります。

また、non-root 実行は securityContext に 1 行書くだけの設定ではありません。image 側で root 前提のディレクトリへ書いている、port を root 権限前提で bind している、といった実装があると簡単に壊れます。つまり non-root は、アプリ実装の健全性まで含めて見直す入口です。

## この回の後に必ずやること

1. 今の app を non-root で動かすと詰まりそうな点を 3 つ書く
2. root 前提の実装がないか manifest と image 設計を見直す
3. 説明に迷う点が残ったら [container-linux-guide.md](container-linux-guide.md) を読み直す

## この回の宿題

- distroless image を採用する利点と欠点を 2 つずつ書く
- graceful shutdown に必要なアプリ実装要素を整理する

次は [handson48.md](handson48.md) で Kubernetes 内部構造を学びます。