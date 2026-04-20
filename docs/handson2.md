# Handson 2

## テーマ

kind クラスタと Node の役割を理解する。

## 今回のゴール

- control plane と worker の違いを説明できる
- Pod が Node にどう配置されるか観察できる
- 1 台構成ではなく複数 Node を使う意味を理解する

## 事前確認

クラスタ設定は [kind-study.yaml](../kind-study.yaml) です。

Node 構成:

- control plane 1 台
- worker 3 台

## やること

```bash
kubectl get nodes -o wide
kubectl get pods -A -o wide
kubectl describe node study-k8s-worker
```

## 観察ポイント

- どの Node が control plane か
- 各 Pod がどの Node に乗っているか
- Node にどんな情報が載っているか

## 目的

- Kubernetes が複数 Node にまたがってスケジューリングする仕組みだと理解する

## 実務上のメリット

- 障害の切り分けがしやすくなる
- 今後のスケールや高可用性の考え方につながる

## この回で理解すべきこと

- Pod は Node 上で動く
- Service は Pod の前段に立つ抽象化である
- 将来 Node が増減しても Kubernetes が吸収しやすい

## 深掘りポイント

- taint と toleration
- scheduler の役割
- requests と limits が配置に与える影響

## この回の宿題

- なぜ worker を 3 台用意しているのか説明する
- もし 1 台しかなかったら何が学びにくくなるか整理する

次は [handson3.md](handson3.md) で Namespace を設計します。