# Handson 54

## テーマ

External Secrets と KMS を前提にした Secret 運用を学ぶ。

## 今回のゴール

- Kubernetes Secret だけで完結しない理由を説明できる
- 外部 Secret Manager と同期する発想を理解できる
- Secret の保存、配布、暗号化を分けて考えられる

## この回で先に押さえる用語

- External Secrets
- KMS
- Secret Manager
- envelope encryption
- sync interval

## 対応ファイル

- [external-secrets-guide.md](external-secrets-guide.md)
- [manifests/extensions/secrets/external-secret-sample.yaml](../manifests/extensions/secrets/external-secret-sample.yaml)
- [scripts/secret-source-check.sh](../scripts/secret-source-check.sh)

## この回で実際にやること

1. [external-secrets-guide.md](external-secrets-guide.md) を読む
2. ExternalSecret の sample を読む
3. `bash scripts/secret-source-check.sh apps` を実行して現在の Secret 一覧を見る
4. `保管`, `配布`, `rotation`, `暗号化` の責務分離を整理する

## 完了条件

- Kubernetes Secret 単体の限界を説明できる
- External Secrets を使う価値を説明できる
- KMS がどこに効くか説明できる

## 実務で見る観点

- Secret の原本がどこにあるか明確か
- rotation と配布が連動しているか
- Git に secret が混入しない導線になっているか

## よくある失敗

- Secret を Git へ直接置く
- 原本と同期先の責務が曖昧
- KMS を使っていても運用フローが安全でない

## 学ぶポイント

- Secret は `どう保存するか` と `どう渡すか` を分けて考えるべきである
- External Secrets は multi-team 運用と rotation に強い
- KMS は鍵管理の基盤であり、運用設計とセットで考える必要がある

## 詰まったときの確認ポイント

- Secret の原本がどこか明確か
- Git に secret を入れずに配布できるか
- rotation 後の影響確認先が分かっているか

## この回の後に必ずやること

1. 今の Secret を `原本`, `同期先`, `利用先` に分けて整理する
2. rotation 時に確認すべき依存先を書き出す
3. [external-secrets-guide.md](external-secrets-guide.md) を見て運用フローの不足を確認する

## この回の宿題

- Secret の原本をどこに置くかの判断材料を書く
- rotation 時に影響調査が必要な対象を列挙する

次は [handson55.md](handson55.md) で stateful HA を学びます。