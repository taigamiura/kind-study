# Handson 45

## テーマ

StorageClass、VolumeSnapshot、状態を持つ運用の深掘りを学ぶ。

## 今回のゴール

- PVC だけで stateful 運用が完成しない理由を説明できる
- StorageClass と VolumeSnapshot の役割を理解する
- backup / restore と snapshot の使い分けを説明できる

## この回で先に押さえる用語

- StorageClass: ストレージの種類
- VolumeSnapshot: PVC の時点切り出し
- Provisioning: ストレージ確保
- Stateful Workload: 状態を持つ workload
- Data Plane: 実データを扱う層

## 対応ファイル

- [storage-operations-guide.md](storage-operations-guide.md)
- [scripts/storage-observe.sh](../scripts/storage-observe.sh)

## この回で実際にやること

1. [storage-operations-guide.md](storage-operations-guide.md) を読み、backup / restore と snapshot の差を整理する
2. `bash scripts/storage-observe.sh` で PVC / PV / StorageClass の状態を見る
3. `どの障害なら snapshot が効き、どの障害なら dump restore が必要か` を分ける
4. stateful 運用で `保存先`, `世代管理`, `復旧訓練` が必要な理由を説明する

## この回だけで押さえる整理

stateful 運用では、PVC があることと戻せることは別問題です。StorageClass、snapshot、論理 backup、restore の役割差を分けて説明できるようになることが、この回の中心です。

## このコマンドで確認するのはここ

- `bash scripts/storage-observe.sh`: PVC の `STATUS`, `CAPACITY`, `STORAGECLASS`、PV との対応、利用中の StorageClass 名を見る
- snapshot / restore を考えるとき: どの PVC が重要データを持つか、保存先が 1 系統しかないかを見る

## 完了条件

- StorageClass と VolumeSnapshot の役割を説明できる
- backup / restore と snapshot の差を説明できる
- stateful workload の運用が stateless より難しい理由を説明できる

## 実務で見る観点

- ストレージ種別ごとの性能や特性を理解しているか
- snapshot と論理 backup を混同していないか
- 復旧訓練が定期的に行われているか

## よくある失敗

この回の失敗は、ストレージ機能を知識として覚えるだけで、障害時の使い道まで結び付けないと起きやすいです。箇条書きは別々に見えても、背景には `どの状態をどう戻すか` の整理不足があります。

- PVC があるから安全だと思い込む
- snapshot だけで論理破損まで戻せると思う
- 保存世代や保持期間を決めない

## 学ぶポイント

- stateful 運用は `保存される` だけでなく `戻せる`, `切り戻せる`, `比較できる` が必要である
- snapshot と backup は役割が違う
- ストレージ運用はアプリ設計と切り離せない

## 学ぶポイントの解説

Kubernetes を学んでいると PVC までで満足しやすいですが、実務ではそこからが本番です。どのクラスのストレージを使うか、snapshot をどう取るか、論理 backup とどう組み合わせるかまで考える必要があります。

ここを理解すると、stateful workload の難しさと設計の勘所がかなり明確になります。

## この回の宿題

- `snapshot が向く障害` と `dump restore が向く障害` を 2 つずつ挙げる
- PostgreSQL の stateful 運用で最も怖いシナリオを 1 つ挙げる

次は [handson46.md](handson46.md) で変更管理を学びます。