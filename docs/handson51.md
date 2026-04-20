# Handson 51

## テーマ

Supply Chain Security と image 信頼性を学ぶ。

## 今回のゴール

- `動く image` と `信頼できる image` の違いを説明できる
- scan、SBOM、署名、provenance の役割を説明できる
- deploy 前に見るべき安全性の観点を整理できる

## この回で先に押さえる用語

- SBOM
- image signature
- provenance
- registry
- vulnerability scan

## 対応ファイル

- [supply-chain-security-guide.md](supply-chain-security-guide.md)
- [manifests/extensions/supply-chain/image-sign-policy-sample.yaml](../manifests/extensions/supply-chain/image-sign-policy-sample.yaml)
- [scripts/image-inventory.sh](../scripts/image-inventory.sh)

## この回で実際にやること

1. [supply-chain-security-guide.md](supply-chain-security-guide.md) を読む
2. image 署名検証 policy のサンプルを読む
3. `bash scripts/image-inventory.sh apps` を実行して current image を確認する
4. `誰が build したか`, `何が含まれるか`, `本当にその image か` をどう担保するか整理する

## 完了条件

- SBOM と vulnerability scan の違いを説明できる
- image 署名の必要性を説明できる
- mutable tag を避ける理由を説明できる

## 実務で見る観点

- image scan が CI に組み込まれているか
- digest pinning や署名検証を行っているか
- どの base image を使うかに基準があるか

## よくある失敗

- latest tag で本番運用する
- 脆弱性 scan だけで十分だと思う
- registry へ push できる主体が広すぎる

## 学ぶポイント


## 詰まったときの確認ポイント

- image がどこで build され、どこへ push されるか追えるか
- mutable tag を使っていないか
- scan と署名を同じものだと思っていないか

## この回の後に必ずやること

1. 現在使っている image で provenance を説明できるか確認する
2. CI に入れるべき scan、SBOM、署名検証を整理する
3. [supply-chain-security-guide.md](supply-chain-security-guide.md) を見て不足観点を補う

## この回の宿題

- CI で入れるべき supply chain check を列挙する
- mutable tag が危険な理由を 2 つ書く

次は [handson52.md](handson52.md) で CRD と Operator を学びます。