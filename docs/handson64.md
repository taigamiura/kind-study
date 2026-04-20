# Handson 64

## テーマ

cluster 再構築と復旧訓練を実践する。

## 今回のゴール

- `壊れた環境を直す` だけでなく `新しく作り直して戻す` 発想を持てる
- Git、manifest、backup、runbook から環境復元する流れを説明できる
- 復旧訓練の不足を自分で見つけられる

## 対応ファイル

- [cluster-rebuild-drill.md](cluster-rebuild-drill.md)
- [backup-restore-runbook.md](backup-restore-runbook.md)

## この回で実際にやること

1. [cluster-rebuild-drill.md](cluster-rebuild-drill.md) を読む
2. `ゼロから cluster を戻す` 前提で必要な情報を列挙する
3. handson10、19、32、33、44、56 を使って復元手順を書く
4. 復元できないもの、手順化されていないものを洗い出す

## 完了条件

- cluster 再構築の大まかな流れを説明できる
- 復旧に必要な材料を列挙できる
- 現状の復旧手順の穴を指摘できる

## 学ぶポイント

- 復旧力は runbook と訓練でしか育たない
- Git と backup があっても手順が弱ければ戻せない
- 再構築訓練は運用成熟度を測る実務的な方法である

## この回の宿題

- 復元に必要な情報が repo に足りているか確認する
- 復旧不能になりそうな論点を 3 つ書く

次は [handson65.md](handson65.md) で 30 日運用計画を作ります。