# Handson 44

## テーマ

クラスタ upgrade とメンテナンス運用を学ぶ。

## 今回のゴール

- Kubernetes の upgrade がアプリ deploy と違う理由を説明できる
- `version を上げる前に見るべきもの` を整理できる
- add-on、Node、API version 互換の観点を持てる

## この回で先に押さえる用語

- Upgrade: version 更新
- Version Skew: 互換差
- Deprecation: 将来使えなくなるもの
- Drain: Node メンテナンス操作
- Maintenance Window: 計画停止時間帯

## 対応ファイル

- [cluster-upgrade-runbook.md](cluster-upgrade-runbook.md)
- [scripts/cluster-upgrade-precheck.sh](../scripts/cluster-upgrade-precheck.sh)

## この回で実際にやること

1. [cluster-upgrade-runbook.md](cluster-upgrade-runbook.md) を読み、upgrade 前後の確認項目を整理する
2. `bash scripts/cluster-upgrade-precheck.sh` で Node version、PDB、Pod 状態を確認する
3. `アプリ deploy` と `クラスタ upgrade` の違いを整理する
4. deprecation と addon 追従が必要な理由を言語化する

## この回だけで押さえる整理

cluster upgrade はアプリ deploy より広い変更で、control plane、node、addon、API 互換を一緒に見ます。version を上げる前提条件と戻し方まで含めて話せると、この回は実務で使える理解になります。

## このコマンドで確認するのはここ

- `bash scripts/cluster-upgrade-precheck.sh`: Node の version 差、NotReady Node の有無、PDB、`CrashLoopBackOff` や `Pending` Pod がないかを見る
- upgrade 前判断では: 既に不安定な workload がある状態で進めていないか確認する

## 完了条件

- upgrade 前に何を確認すべきか説明できる
- version skew や deprecation の意味を説明できる
- drain と PDB が upgrade にどう関係するか説明できる

## 実務で見る観点

- addon と cluster version の互換を確認しているか
- Node を順番に安全に更新できる設計か
- API deprecation を事前に潰しているか

## よくある失敗

この回の失敗は、upgrade を単なるバージョン更新として扱うと起きやすいです。箇条書きは別々に見えても、背景には `事前確認`, `互換性`, `戻し方` を一体で考えていないことがあります。

- アプリ upgrade と同じ感覚で cluster upgrade を進める
- addon 互換を見ずに monitoring や ingress が壊れる
- drain で想定外停止を起こす

## 学ぶポイント

- cluster upgrade は control plane、node、addon、workload の全体運用である
- upgrade 前の precheck が失敗を大きく減らす
- deprecation 追従は地味だが実務では必須である

## 学ぶポイントの解説

Kubernetes の upgrade は `version を上げるだけ` ではありません。API の廃止、addon の互換、Node メンテナンス、PDB との整合まで含めて考える必要があります。ここが分かると、クラスタ運用の解像度が一段上がります。

特に kind のような学習環境でも、upgrade の思考手順を持つこと自体に価値があります。実務では、この準備不足が監視停止や ingress 断につながります。

## この回の宿題

- cluster upgrade 前の確認項目を 7 つ書く
- addon upgrade を見落とすと困るコンポーネントを 3 つ挙げる

次は [handson45.md](handson45.md) で storage 運用を学びます。