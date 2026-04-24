# Handson 69

## テーマ

Build pipeline と container build engineering を学ぶ。

## 今回のゴール

- `image を作る` と `信頼できる release artifact を作る` の差を説明できる
- multi-stage build、build cache、multi-arch、artifact promotion の意味を説明できる
- build pipeline の設計が速度と安全性の両方に効くと理解する

## この回で先に押さえる用語

- multi-stage build
- build cache
- multi-arch
- artifact promotion
- immutable artifact

## 対応ファイル

- [build-engineering-guide.md](build-engineering-guide.md)

## この回で実際にやること

1. [build-engineering-guide.md](build-engineering-guide.md) を読む
2. `build`, `scan`, `sign`, `promote` の流れを図にする
3. latest tag を避ける理由を build engineering 観点でも整理する
4. 環境ごとに build し直さない理由を説明する

## この回だけで押さえる整理

build engineering で大切なのは、image を作ることより `同じ artifact を安全に昇格できること` です。この回では build、scan、sign、promote を 1 本の release pipeline として説明できるようになることを目指します。

## 確認するとしたらどこを見るか

- build pipeline では cache 効率、artifact の再現性、multi-arch 対応、promotion の境界を見る
- `build できた` だけでなく、同じ artifact を再利用できる流れか確認する

## 完了条件

- artifact promotion の意味を説明できる
- multi-stage build の価値を説明できる
- build pipeline でレビューすべき点を説明できる

## 実務で見る観点

- 本番用 artifact を環境ごとに作り直していないか
- cache と再現性のバランスを取れているか
- build 速度だけでなく traceability があるか

## よくある失敗

この回の失敗は、build を `コンテナ image ができる工程` とだけ見ると起きやすいです。背景には `artifact の再現性と traceability が release 品質を支える` という視点の不足があります。

- 環境ごとに別 build してしまう
- latest tag のまま release artifact を扱う
- build 速度だけを最適化して追跡性を落とす


## 詰まったときの確認ポイント

- build と release artifact を同じ意味で使っていないか
- 環境ごとに別 build していないか
- scan、署名、SBOM の順番と役割を分けられているか

## この回の後に必ずやること

1. build pipeline の時系列を図にする
2. immutable artifact を壊す運用がないか洗い出す
3. [build-engineering-guide.md](build-engineering-guide.md) を見て build engineering 観点の不足を確認する

## この回の宿題

- build pipeline に必要な検査項目を時系列で書く
- immutable artifact を守るべき理由を 3 つ書く

## 学ぶポイント

- release の品質は deploy より前の build 設計でかなり決まる
- 同じ artifact を昇格する方が環境差分事故を減らしやすい
- build pipeline は速さと再現性の両方を満たす必要がある

## 学ぶポイントの解説

本番事故は deploy 手順だけでなく、artifact の作り方でも起きます。環境ごとに別 build すると、何が本番で動いたか追いにくくなり、scan や署名の意味も弱くなります。

そのため実務では、immutable artifact を一度作り、それを promote していく設計が強いです。multi-stage build や cache も、単なる高速化でなく、安全に速く作るための道具として理解する必要があります。

次は [handson70.md](handson70.md) で OpenTelemetry を学びます。