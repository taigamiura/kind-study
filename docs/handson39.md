# Handson 39

## テーマ

ResourceQuota と LimitRange で共有クラスタ運用を学ぶ。

## 今回のゴール

- 複数チームが同居するクラスタで quota が必要な理由を説明できる
- requests / limits と quota の関係を理解できる
- `1 アプリの暴走がクラスタ全体へ波及する` 問題をイメージできる

## この回で先に押さえる用語

- ResourceQuota: namespace ごとの総量制限
- LimitRange: container 単位の標準制限
- Burst: 一時的な急増
- Fairness: 複数チーム間の公平性
- Shared Cluster: 複数用途が同居するクラスタ

## 対応ファイル

- [quota-governance-guide.md](quota-governance-guide.md)
- [manifests/extensions/governance/apps-resourcequota.yaml](../manifests/extensions/governance/apps-resourcequota.yaml)
- [manifests/extensions/governance/apps-limitrange.yaml](../manifests/extensions/governance/apps-limitrange.yaml)
- [scripts/quota-observe.sh](../scripts/quota-observe.sh)

## この回で実際にやること

1. [quota-governance-guide.md](quota-governance-guide.md) を読み、quota と limitrange の役割を整理する
2. apps namespace 用の ResourceQuota と LimitRange を読む
3. `bash scripts/quota-observe.sh apps` で quota 状態を確認する
4. requests / limits / quota がどの順で効くか説明する

## このコマンドで確認するのはここ

- `bash scripts/quota-observe.sh apps`: ResourceQuota の `used / hard`、LimitRange の default requests / limits、Pod 側 requests / limits の有無を見る
- quota が厳しすぎるか考えるとき: `used` が `hard` に近すぎないか、逆に余裕がありすぎないかを見る

## 完了条件

- ResourceQuota と LimitRange の違いを説明できる
- shared cluster で quota が必要な理由を説明できる
- requests / limits だけでは足りない理由を説明できる

## 実務で見る観点

- namespace ごとの予算や責務に応じた quota があるか
- default の requests / limits が雑すぎないか
- HPA や burst と矛盾しない上限設計になっているか

## よくある失敗

この回の失敗は、制限値を入れること自体が目的になると起きやすいです。箇条書きは別々に見えても、背景には `共有クラスタで何を守りたいか` の運用意図が薄いことがあります。

- quota を厳しくしすぎて deploy が詰まる
- quota がなく、1 チームの暴走が全体に波及する
- LimitRange の default 値が業務負荷に合っていない

## 学ぶポイント

- quota はリソース節約だけでなく共有クラスタ統制の道具である
- LimitRange は `書き忘れ防止`, ResourceQuota は `使いすぎ防止` に効く
- requests / limits / quota は別レイヤの制御である

## 学ぶポイントの解説

小規模学習環境では quota がなくても動きますが、実務では複数アプリや複数チームが共存します。そのとき `誰かの deploy がクラスタ全体を食い尽くす` 事故を防ぐために quota が必要になります。

また、LimitRange があると requests / limits の書き忘れを減らせます。これにより HPA や scheduling の前提も安定しやすくなります。

## この回の宿題

- apps namespace に適切だと思う CPU / memory quota を考える
- `厳しすぎる quota` で起こる問題を 2 つ挙げる

次は [handson40.md](handson40.md) で PDB と node drain を学びます。