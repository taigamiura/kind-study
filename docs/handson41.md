# Handson 41

## テーマ

affinity、anti-affinity、topology spread で配置設計を学ぶ。

## 今回のゴール

- `どこでも動けばよい` と `どこへ置くべきかを設計する` の差を理解する
- Pod を偏らせない理由を説明できる
- scheduling 設計が可用性とコストの両方に効くことを理解する

## この回で先に押さえる用語

- Affinity: 寄せたい配置条件
- Anti-Affinity: 離したい配置条件
- Topology Spread Constraints: 偏り抑制の条件
- Node Selector: 単純な配置条件
- Taint / Toleration: Node 側の受け入れ制御

## 対応ファイル

- [scheduling-design-guide.md](scheduling-design-guide.md)
- [manifests/extensions/scheduling/user-service-affinity-patch.yaml](../manifests/extensions/scheduling/user-service-affinity-patch.yaml)
- [manifests/extensions/scheduling/item-service-topologyspread-patch.yaml](../manifests/extensions/scheduling/item-service-topologyspread-patch.yaml)
- [scripts/scheduling-observe.sh](../scripts/scheduling-observe.sh)

## この回で実際にやること

1. [scheduling-design-guide.md](scheduling-design-guide.md) を読み、配置制御の使い分けを整理する
2. affinity patch と topology spread patch を読む
3. `bash scripts/scheduling-observe.sh apps` で Pod の Node 偏りを確認する
4. `同じ Node に寄りすぎると何が危ないか` を考える

## 完了条件

- affinity / anti-affinity / topology spread の違いを説明できる
- 可用性のために配置制御が必要な理由を説明できる
- taint / toleration がいつ必要になるか説明できる

## 実務で見る観点

- 同一種類の Pod が 1 Node へ寄りすぎていないか
- Node 障害時に一気に落ちる設計になっていないか
- 高価な Node と汎用 Node を意図的に使い分けられているか

## よくある失敗

この回の失敗は、配置制御を `何となく分散されそう` で入れると起きやすいです。箇条書きは別々に見えても、背景には `どの偏りを防ぎたいか` の明確化不足があります。

- replica は増やしたが同じ Node に固まる
- anti-affinity を厳しくしすぎてスケジュールできない
- topology spread の前提となる label 設計が曖昧

## 学ぶポイント

- 可用性は replica 数だけでなく配置でも決まる
- scheduling 設計は障害耐性とコストに直結する
- `置ける` と `よい場所に置ける` は別である

## 学ぶポイントの解説

Kubernetes は自動で Pod を置いてくれますが、実務では `どこでもよい` とは限りません。同じ Node に user-service の Pod が固まると、Node 障害でまとめて落ちます。ここで anti-affinity や topology spread が効きます。

一方で、条件を厳しくしすぎると今度は配置できなくなります。実務で重要なのは、理想配置と配置可能性のバランスを取ることです。

## この回の宿題

- user-service を 3 replica にしたとき理想的な配置を図にする
- anti-affinity を厳しくしすぎた場合の副作用を 2 つ挙げる

次は [handson42.md](handson42.md) で logging / tracing を学びます。