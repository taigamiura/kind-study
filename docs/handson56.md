# Handson 56

## テーマ

Multi-cluster、environment 分離、DR 設計を学ぶ。

## 今回のゴール

- 単一クラスタ運用の限界を説明できる
- dev / stg / prod 分離と multi-cluster の関係を理解できる
- blast radius を減らす設計を説明できる

## この回で先に押さえる用語

- multi-cluster
- blast radius
- failover
- environment isolation
- regional DR

## 対応ファイル

- [multi-cluster-dr-guide.md](multi-cluster-dr-guide.md)

## この回で実際にやること

1. [multi-cluster-dr-guide.md](multi-cluster-dr-guide.md) を読む
2. `単一クラスタ`, `環境別クラスタ`, `active-standby`, `active-active` を比較する
3. どこまでの障害を DR 対象にするかを整理する
4. `同じクラスタに全部乗せる危険性` を言語化する

## 完了条件

- multi-cluster が必要になる理由を説明できる
- environment 分離と DR の関係を説明できる
- blast radius の考え方を説明できる

## 実務で見る観点

- staging と production の責務分離があるか
- 単一クラスタ障害で全停止しない設計か
- DNS、証明書、data replication まで含めた DR があるか

## よくある失敗

- cluster 数を増やすだけで DR だと思う
- data layer を含めずアプリ側だけ冗長化する
- 運用コストを見ずに multi-cluster を増やしすぎる

## 学ぶポイント

- multi-cluster は正義ではなく、blast radius と運用コストのトレードオフである
- DR は compute だけでなく data と DNS も設計対象である
- environment 分離は安全性と変更速度の両方に効く

## 詰まったときの確認ポイント

- cluster を増やす目的が明確か
- DR 対象に data と DNS が入っているか
- 環境分離と運用負荷の両方を見ているか

## この回の後に必ずやること

1. 単一クラスタの blast radius を自分の言葉で書く
2. dev / stg / prod をどう分離するか整理する
3. [multi-cluster-dr-guide.md](multi-cluster-dr-guide.md) を見て DR 設計の漏れを確認する

## この回の宿題

- staging と production を同一クラスタに置くリスクを書く
- DR 設計でアプリ以外に確認すべき要素を列挙する

次は [handson57.md](handson57.md) で性能改善を学びます。