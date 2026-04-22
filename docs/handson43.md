# Handson 43

## テーマ

Pod Security、securityContext、admission の基礎を学ぶ。

## 今回のゴール

- `動く Pod` と `本番へ出せる Pod` の違いを説明できる
- securityContext の主要設定を説明できる
- Pod Security と admission が `後から止める仕組み` である理由を理解する

## この回で先に押さえる用語

- SecurityContext: Pod / container の権限設定
- Pod Security Standards: 標準的な安全基準
- Admission: 作成時に止める仕組み
- Privileged: 強い権限で動く状態
- Capabilities: Linux 権限の細かな単位

## 対応ファイル

- [pod-security-guide.md](pod-security-guide.md)
- [manifests/extensions/security/apps-pod-security-labels.yaml](../manifests/extensions/security/apps-pod-security-labels.yaml)
- [manifests/extensions/security/user-service-securitycontext-patch.yaml](../manifests/extensions/security/user-service-securitycontext-patch.yaml)
- [scripts/security-posture-check.sh](../scripts/security-posture-check.sh)

## この回で実際にやること

1. [pod-security-guide.md](pod-security-guide.md) を読み、restricted に寄せる考え方を整理する
2. namespace label と securityContext patch を読む
3. `bash scripts/security-posture-check.sh apps` で securityContext の有無を確認する
4. `なぜ admission で止める必要があるのか` を考える

## 完了条件

- securityContext の主要設定を説明できる
- Pod Security label の役割を説明できる
- privileged を避ける理由を説明できる

## 実務で見る観点

- runAsNonRoot、readOnlyRootFilesystem、capabilities drop が入っているか
- namespace 単位で最低限の基準を強制できるか
- 例外運用を無制限に許していないか

## よくある失敗

この回の失敗は、セキュリティ設定を `インフラの細かい話` として後回しにすると起きやすいです。箇条書きは別々に見えても、背景には `安全に動かす前提をアプリ実装と切り離して考えている` ことがあります。

- root 実行のまま本番へ出す
- 例外的に privileged を許した設定が常態化する
- securityContext の意味を理解せずコピペする

## 学ぶポイント

- セキュリティは導入後に気合で守るのでなく、作成時に制約をかける方が強い
- securityContext はインフラ担当だけでなくアプリ側も理解すべき設定である
- admission は `危ないものを最初から入れない` ためにある

## 学ぶポイントの解説

Kubernetes は自由度が高い反面、危険な設定でも動いてしまいます。そのため本番運用では、あとから気を付けるより、最初から admission や Pod Security で止める方が実務的です。

特に開発エンジニアに必要なのは、securityContext を `インフラの細かい話` と切り離さないことです。これはアプリを本番で安全に動かすための前提です。

## この回の宿題

- user-service に最低限必要だと思う securityContext を書く
- `一時的な例外` が恒久化すると危険な理由を 2 つ挙げる

次は [handson44.md](handson44.md) で cluster upgrade を学びます。