# Handson 75

## テーマ

Platform Engineering と self-service 設計を学ぶ。

## 今回のゴール

- platform team が毎回個別対応しなくても回る設計を理解できる
- self-service と golden path の価値を説明できる
- `標準化で速度を上げる` 発想を持てる

## この回で先に押さえる用語

- golden path
- self-service platform
- platform API
- template
- developer experience

## 対応ファイル

- [platform-engineering-guide.md](platform-engineering-guide.md)

## この回で実際にやること

1. [platform-engineering-guide.md](platform-engineering-guide.md) を読む
2. 開発者が毎回依頼している作業を洗い出す
3. template 化、自動化、review 自動化できるものを分ける
4. golden path がない場合の運用負荷を説明する

## この回だけで押さえる整理

Platform Engineering は、platform team が全部やることではなく、開発者が安全な標準経路を自力で選べるようにすることです。この回では golden path、例外経路、ownership、self-service の境界を説明できればゴール達成です。

## 確認するとしたらどこを見るか

- self-service 設計では golden path、例外経路、所有者、サポート境界が明確かを見る
- platform team が毎回手作業しないと進まない部分がどこか確認する

## 完了条件

- self-service の価値を説明できる
- golden path の必要性を説明できる
- platform team が担うべき抽象化を説明できる

## 実務で見る観点

- platform team がチケット処理だけで疲弊していないか
- 標準パターンが開発者に見えているか
- 例外運用が常態化していないか

## よくある失敗

この回の失敗は、self-service を `review なしで自由にやれること` と誤解すると起きやすいです。背景には `標準化と例外統制を同時に設計する` 視点の不足があります。

- platform team が手作業を抱え込んだままになる
- golden path を作らず個別相談で回そうとする
- self-service 化で review や guardrail が不要になると思う


## 詰まったときの確認ポイント

- golden path を定義できているか
- self-service にできるものを platform 側が抱え込みすぎていないか
- 標準化と例外運用の境界を説明できるか

## この回の後に必ずやること

1. 毎回依頼される作業を棚卸しする
2. template 化と例外運用を分けて考える
3. [platform-engineering-guide.md](platform-engineering-guide.md) を見て platform product 観点の不足を確認する

## この回の宿題

- 標準化できる作業を 10 個挙げる
- self-service にした場合の review 点を整理する

## 学ぶポイント

- platform engineering は運用を肩代わりするのでなく標準化する営みである
- golden path があると開発速度と安全性を両立しやすい
- self-service は review 不要化でなく review の自動化と標準化である

## 学ぶポイントの解説

platform team が毎回手作業で対応していると、人数が増えるほどボトルネックになります。そこから抜けるには、標準パターンを明文化し、開発者が自力で安全な道を選べるようにする必要があります。

ここを理解していると、Kubernetes 運用を単なる保守作業でなく、再利用可能な platform product として考えられるようになります。

次は [handson76.md](handson76.md) で非機能要件を学びます。