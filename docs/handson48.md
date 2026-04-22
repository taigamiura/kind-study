# Handson 48

## テーマ

Kubernetes 内部構造と control plane の役割を学ぶ。

## 今回のゴール

- apiserver、scheduler、controller-manager、etcd、kubelet の役割を説明できる
- `kubectl apply してから Pod が動くまで` の流れを追える
- 障害時にどのレイヤから疑うべきか整理できる

## この回で先に押さえる用語

- API Server
- Scheduler
- Controller Manager
- Etcd
- Kubelet

## 対応ファイル

- [kubernetes-internals-guide.md](kubernetes-internals-guide.md)
- [scripts/cluster-components-check.sh](../scripts/cluster-components-check.sh)

## この回で実際にやること

1. [kubernetes-internals-guide.md](kubernetes-internals-guide.md) を読む
2. `bash scripts/cluster-components-check.sh` を実行して kube-system の構成要素を見る
3. Deployment 作成から Pod 実行までの control loop を図にする
4. `Pod が Pending`, `Service に名前解決できない`, `PVC が bound しない` の原因レイヤを分ける

## 完了条件

- control plane の主要コンポーネントを説明できる
- kubelet と scheduler の役割差を説明できる
- 問題の切り分け順序を説明できる

## 実務で見る観点

- control plane 障害と workload 障害を混同しないか
- DNS、network、storage の責務境界を意識できるか
- `見えている症状` と `壊れているレイヤ` を分けて考えられるか

## よくある失敗

この回の失敗は、control plane の部品名を覚えるだけで役割のつながりを持たないと起きやすいです。箇条書きは別々に見えても、背景には `どのコンポーネントが何を決めるか` の流れが曖昧なことがあります。

- すべてアプリ障害として扱う
- scheduler や CNI の問題を Deployment 設定のせいだと誤解する
- etcd や apiserver の重要性を見落とす

## 学ぶポイント


## 詰まったときの確認ポイント

- apply 後に最初に状態を持つのは何か
- Node を選ぶのは誰か
- Pod を実行するのは誰か
- storage や network の問題をどのレイヤで疑うか

## この回の後に必ずやること

1. `Pod が Pending`, `DNS 解決失敗`, `PVC 未割当` の 3 例で疑うコンポーネントを書く
2. kube-system の主要 Pod を見て役割を説明できるか確認する
3. 説明が曖昧なら [kubernetes-internals-guide.md](kubernetes-internals-guide.md) を読み直す

## この回の宿題

- kubectl apply から Pod Running までの処理を説明する
- 自分が遭遇しそうな障害を 3 つ挙げて、疑うコンポーネントを書く

次は [handson49.md](handson49.md) で Authentication と Audit を学びます。