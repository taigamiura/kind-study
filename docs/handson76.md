# Handson 76

## テーマ

非機能要件と業種別本番要件の詰め方を学ぶ。

## 今回のゴール

- NFR を性能、可用性、監査性、保守性、分離性に分けて考えられる
- 金融、EC、B2B SaaS などで重くなる要件差を理解できる
- `技術選定` と `業務要求` を結び付けて説明できる

## この回で先に押さえる用語

- NFR
- tenant isolation
- RTO / RPO
- auditability
- availability target

## 対応ファイル

- [non-functional-requirements-guide.md](non-functional-requirements-guide.md)

## この回で実際にやること

1. [non-functional-requirements-guide.md](non-functional-requirements-guide.md) を読む
2. 3 つの業種シナリオで要件差を整理する
3. それぞれに必要な Kubernetes / クラウド設計を結び付ける
4. `同じクラスタ構成でも要件が変わると判断が変わる` ことを言語化する

## 完了条件

- NFR の主要分類を説明できる
- 業種別に重くなる要件差を説明できる
- 設計判断が業務要件に依存することを説明できる

## 実務で見る観点

- 技術的に正しくても業務要求に足りているか
- tenant isolation や監査要件が十分か
- 高可用構成のコストと要件の釣り合いが取れているか


## 詰まったときの確認ポイント

- 技術要件と業務要件を分けて整理できているか
- 業種ごとの監査性や分離性の重さを理解しているか
- 高可用構成が本当に要求に見合っているか判断できるか

## この回の後に必ずやること

1. 1 業種を選んで NFR を表形式で整理する
2. その要求に対して今の構成の不足を洗い出す
3. [non-functional-requirements-guide.md](non-functional-requirements-guide.md) を見て見落としている要件を補う

## この回の宿題

- 1 業種を選び、その本番要件を文章で整理する
- その要件に対して今の構成で不足する点を書く

## 学ぶポイント

- 最終的な設計判断は業務要件から逆算するべきである
- NFR は性能だけでなく監査性、分離性、保守性を含む
- 同じ Kubernetes 構成でも業種が変われば最適解は変わる

## 学ぶポイントの解説

技術的に優れた構成でも、業務要求に合っていなければ実務では不十分です。金融では監査性や権限証跡が重くなり、EC ではピーク時性能と可用性が重くなり、B2B SaaS では tenant isolation や契約上の運用要件が重くなります。

ここまで理解すると、Kubernetes の知識をそのまま当てはめるのではなく、業務要件に応じて構成や運用を調整する発想が持てます。

この handson76 までで、Kubernetes の中だけでなく、クラウド基盤、IaC、build、observability 実装、アプリ設計、Node 深掘り、監査、外部依存、platform engineering、NFR まで一続きで学べる構成になります。