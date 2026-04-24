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

## この回だけで押さえる整理

この回で最初に押さえるべきことは、`replica を増やす` と `安全に分散される` は別だという点です。3 replica あっても同じ Node に 3 つ載れば、その Node が落ちた瞬間に 3 つとも消えます。逆に、分散を厳しくしすぎると今度は `置きたいのに置けない` 状態になります。配置制御は、この 2 つの失敗の間でバランスを取るための仕組みです。

使い分けは次のように考えると整理しやすいです。

- `nodeSelector`: 単純に `このラベルの Node にしか置かない` と決める。GPU Node や専用 Node のような明確な置き先があるときに使う
- `podAffinity`: `この Pod の近くに置きたい` を表現する。キャッシュとアプリを同じ Node や同じ zone に寄せたいときに使う
- `podAntiAffinity`: `同じ種類の Pod を離したい` を表現する。Node 障害で同時に落ちるのを避けたいときに使う
- `topologySpreadConstraints`: `全体として偏りすぎない` を表現する。3 replica を 2 Node や 3 Node へ均等に近く置きたいときに使う
- `taint / toleration`: `この Node は条件を満たす Pod だけ受け入れる` を表現する。高価な Node や運用専用 Node を予約したいときに使う

`anti-affinity` と `topology spread` は似て見えますが役割が違います。anti-affinity は `同じ種類を近づけない` に強く、topology spread は `全体の偏りをそろえる` に強いです。前者は `できるだけ離したい`、後者は `偏差を一定以下にしたい` と覚えると混同しにくくなります。

## 対応ファイルをこの場で読むポイント

- [manifests/extensions/scheduling/user-service-affinity-patch.yaml](../manifests/extensions/scheduling/user-service-affinity-patch.yaml): `podAntiAffinity` と `topologyKey: kubernetes.io/hostname` があり、user-service を同じ Node に固めない方向へ寄せている
- `preferredDuringSchedulingIgnoredDuringExecution` を使っているため、`必須ではないが強くそうしたい` 設定になっている。Node 数が足りないときに deploy 自体は止めにくい
- [manifests/extensions/scheduling/item-service-topologyspread-patch.yaml](../manifests/extensions/scheduling/item-service-topologyspread-patch.yaml): `maxSkew: 1` と `whenUnsatisfiable: ScheduleAnyway` があり、item-service の偏りを 1 以内に抑えたい意図が読める
- `ScheduleAnyway` は `理想どおりでなくてもまず置く` という意味で、可用性と配置可能性のバランスを取っている

この repo の設定は、`完全に理想配置を強制して deploy を詰まらせる` のではなく、`まず動かしつつ偏りを減らす` 方向です。学習用途としても実務の初期設計としても妥当な落とし所です。

## このコマンドで確認するのはここ

- `bash scripts/scheduling-observe.sh apps`: 各 Pod の `NODE` を見て、同種 Pod が同じ Node に偏っていないか確認する
- anti-affinity や topology spread を考えるとき: 3 replica が 1 台に固まっていないか、分散の偏りを見る

コマンド結果を読むときは、次の順で見ると判断しやすいです。

1. まず user-service や item-service の replica 数を見る
2. 次に `NODE` 列を見て、同じアプリの Pod が何台の Node に散っているか数える
3. そのあと `なぜその偏りになったか` を affinity / topology spread の設定へ戻って確認する

例えば 3 replica なのに 2 台の Node に `2,1` で載っているなら、現実的にはかなり良い配置です。逆に `3,0,0` なら、Node 障害時に全滅するので配置設計が弱いと判断できます。

## 完了条件

- affinity / anti-affinity / topology spread の違いを説明できる
- 可用性のために配置制御が必要な理由を説明できる
- taint / toleration がいつ必要になるか説明できる

完了条件を満たしたかは、次の 3 問に自力で答えられるかで確認できます。

- `user-service` に anti-affinity が向くのはなぜか
- `topology spread` を使うと anti-affinity だけの場合より何が読みやすくなるか
- 高価な専用 Node を通常ワークロードから守るとき、なぜ taint / toleration が必要になるか

## 実務で見る観点

- 同一種類の Pod が 1 Node へ寄りすぎていないか
- Node 障害時に一気に落ちる設計になっていないか
- 高価な Node と汎用 Node を意図的に使い分けられているか
- replica 数だけで安心せず、zone や hostname 単位で偏りを見ているか
- `理想配置を強制する厳しさ` と `スケジュールできる現実性` のバランスを取れているか

## よくある失敗

この回の失敗は、配置制御を `何となく分散されそう` で入れると起きやすいです。箇条書きは別々に見えても、背景には `どの偏りを防ぎたいか` の明確化不足があります。

- replica は増やしたが同じ Node に固まる
- anti-affinity を厳しくしすぎてスケジュールできない
- topology spread の前提となる label 設計が曖昧

## 学ぶポイント

- 可用性は replica 数だけでなく配置でも決まる
- scheduling 設計は障害耐性とコストに直結する
- `置ける` と `よい場所に置ける` は別である
- anti-affinity と topology spread は似て見えるが、意図する制御が違う
- taint / toleration は分散のためではなく、Node 側の受け入れ制御に使う

## 学ぶポイントの解説

Kubernetes は自動で Pod を置いてくれますが、実務では `どこでもよい` とは限りません。同じ Node に user-service の Pod が固まると、Node 障害でまとめて落ちます。ここで anti-affinity や topology spread が効きます。

一方で、条件を厳しくしすぎると今度は配置できなくなります。実務で重要なのは、理想配置と配置可能性のバランスを取ることです。

特に初学者がつまずきやすいのは、`spread させたい` と `Node を制限したい` を同じものだと思う点です。spread は偏り制御、Node 制限は置き先制御であり、問題が違います。GPU Node を予約したいなら taint / toleration や nodeSelector が中心で、同じアプリを散らしたいなら anti-affinity や topology spread が中心です。

また、`requiredDuringSchedulingIgnoredDuringExecution` を多用すると理想配置は守りやすくなりますが、Node 数不足や一時障害で `Pending` が増えやすくなります。この repo が `preferred` と `ScheduleAnyway` を使っているのは、学習環境や小規模環境で `止めないこと` を優先しているからです。ここを読めると、YAML を丸暗記でなく設計判断として理解できます。

## この回だけで説明できるようにしておきたいこと

- replica を増やしても同じ Node に固まれば可用性は十分ではない
- anti-affinity は `近づけない`, topology spread は `偏りを抑える`, taint / toleration は `受け入れ先を制御する`
- 厳しく守る設定は安全性を上げるが、配置不能リスクも上げる

## この回の宿題

- user-service を 3 replica にしたとき理想的な配置を図にする
- anti-affinity を厳しくしすぎた場合の副作用を 2 つ挙げる

次は [handson42.md](handson42.md) で logging / tracing を学びます。