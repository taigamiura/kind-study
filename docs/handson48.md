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

## この回だけで押さえる整理

`kubectl apply` すると Pod が動く、で止まると内部構造が見えません。実際には、apiserver が desired state を受け取り、controller-manager が不足分を見つけ、scheduler が Node を決め、kubelet がその Node で container を起動します。各コンポーネントは別の責務を持っているため、障害時も `どこで決まる問題か` を分けて考える必要があります。

切り分けの基本は、`作成できない`, `置けない`, `起動できない`, `名前解決できない`, `保存できない` を分けることです。作成できないなら apiserver や admission、置けないなら scheduler、起動できないなら kubelet / runtime、名前解決できないなら DNS、保存できないなら storage の線が濃くなります。

## このコマンドで確認するのはここ

- `bash scripts/cluster-components-check.sh`: kube-system の主要 Pod が `Running` か、apiserver、controller-manager、scheduler、CoreDNS などが見えているか確認する
- レイヤ切り分けでは: control plane 側の不調か、DNS / storage / node 側の不調かを分ける材料が出ているかを見る

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

- Kubernetes は 1 つの巨大な仕組みではなく、役割の違う control loop の集合である
- `apply した` と `Node 上で実行された` の間には、複数の責務境界がある
- 症状の出方から壊れているレイヤを絞ると、調査が速くなる

## 学ぶポイントの解説

初学者が混乱しやすいのは、すべての問題を `Kubernetes` という 1 つの箱で捉えることです。しかし実際には、scheduler は Node を選ぶだけで、container は起動しません。kubelet は Node 上で Pod を起動しますが、PVC を作るわけではありません。この責務の分離を理解すると、`誰に聞くべき問題か` が見えます。

例えば Pod が Pending のままなら、まず scheduler が置けない理由を見るべきです。逆に Running なのに Service で名前解決できないなら、Deployment より DNS や Service のレイヤを先に疑う方が筋が良いです。ここを言語化できると、障害時の初動がかなり強くなります。


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