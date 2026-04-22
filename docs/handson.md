# Hands-on Index

このハンズオンは、小さい単位で確実に進めるために連番ファイルへ分割しています。1 つ終えるごとに確認し、理解できてから次へ進んでください。

## 進め方

- 1 回のハンズオンで 1 つか 2 つの概念だけを学ぶ
- 各回の最後に、自分の言葉で説明できるか確認する
- マニフェストを作る段階に入ったら、必ず Pod と Service の状態を観察する

## 前提

- kind クラスタは作成済み
- クラスタ構成は control plane 1、worker 3
- ホストの 80 / 443 は kind にマッピング済み
- Docker と kubectl が使える

クラスタ設定は [kind-study.yaml](../kind-study.yaml) です。

## 先に読むと詰まりにくい資料

- [glossary.md](glossary.md): このシリーズで頻出する Kubernetes 用語の先読み用ガイド
- [kubectl-inspection-guide.md](kubectl-inspection-guide.md): `kubectl get` や `kubectl describe` でどこを見ればよいかをまとめた確認ガイド
- 分からない用語が出たら [glossary.md](glossary.md) に戻る

## 連番ハンズオン

1. [handson1.md](handson1.md): 何を作るのかと全体像を理解する
2. [handson2.md](handson2.md): kind クラスタと Node を観察する
3. [handson3.md](handson3.md): Namespace 設計と責務分離を学ぶ
4. [handson4.md](handson4.md): Ingress と入口設計を学ぶ
5. [handson5.md](handson5.md): PostgreSQL の永続化を学ぶ
6. [handson6.md](handson6.md): user-service と item-service を理解する
7. [handson7.md](handson7.md): web-app と API 連携を理解する
8. [handson8.md](handson8.md): Ridgepole とスキーマ運用を学ぶ
9. [handson9.md](handson9.md): Grafana と監視の基礎を学ぶ
10. [handson10.md](handson10.md): Argo CD と GitOps、最後の障害訓練を行う
11. [handson11.md](handson11.md): Helm でアドオンを安全に導入する
12. [handson12.md](handson12.md): Kustomize で base と overlay を使い分ける
13. [handson13.md](handson13.md): HPA で自動スケールを学ぶ
14. [handson14.md](handson14.md): NetworkPolicy で通信制御を学ぶ
15. [handson15.md](handson15.md): CI/CD で manifest 品質を継続検証する
16. [handson16.md](handson16.md): HTTPS 化と TLS 証明書運用を学ぶ
17. [handson17.md](handson17.md): Sidecar とサービスメッシュを学ぶ
18. [handson18.md](handson18.md): mTLS の STRICT 化、カナリアリリース、切り戻しを学ぶ
19. [handson19.md](handson19.md): PostgreSQL のバックアップ、復旧、DR の基本を学ぶ
20. [handson20.md](handson20.md): Secret と TLS 証明書の更新運用を学ぶ
21. [handson21.md](handson21.md): SLO、Alert、運用閾値の作り方を学ぶ
22. [handson22.md](handson22.md): 障害初動、情報整理、ポストモーテムを学ぶ
23. [handson23.md](handson23.md): リリース中に見るメトリクスの意味を学ぶ
24. [handson24.md](handson24.md): Grafana での確認順序を学ぶ
25. [handson25.md](handson25.md): Grafana の dashboard と panel の見方を学ぶ
26. [handson26.md](handson26.md): リリース判断の記録方法を学ぶ
27. [handson27.md](handson27.md): チームへの共有文の作り方を学ぶ
28. [handson28.md](handson28.md): promote / rollback 後の追跡監視を学ぶ
29. [handson29.md](handson29.md): rollback 後の初動調査メモを学ぶ
30. [handson30.md](handson30.md): 再発防止アクションの整理を学ぶ
31. [handson31.md](handson31.md): 再リリース可否の判定を学ぶ
32. [handson32.md](handson32.md): canary リリース runbook を通しで学ぶ
33. [handson33.md](handson33.md): PostgreSQL の backup / restore runbook を通しで学ぶ
34. [handson34.md](handson34.md): Secret / Certificate rotation の確認を学ぶ
35. [handson35.md](handson35.md): SLO / Alert テンプレートの作り方を学ぶ
36. [handson36.md](handson36.md): 障害初動チェックリストを実践する
37. [handson37.md](handson37.md): Postmortem を書いて運用改善へつなげる
38. [handson38.md](handson38.md): RBAC と ServiceAccount で最小権限を設計する
39. [handson39.md](handson39.md): ResourceQuota と LimitRange で共有クラスタ運用を学ぶ
40. [handson40.md](handson40.md): PodDisruptionBudget と node drain を学ぶ
41. [handson41.md](handson41.md): affinity、anti-affinity、topology spread で配置設計を学ぶ
42. [handson42.md](handson42.md): logging と tracing の実務的な使い分けを学ぶ
43. [handson43.md](handson43.md): Pod Security、securityContext、admission の基礎を学ぶ
44. [handson44.md](handson44.md): クラスタ upgrade とメンテナンス運用を学ぶ
45. [handson45.md](handson45.md): StorageClass、VolumeSnapshot、状態を持つ運用の深掘りを学ぶ
46. [handson46.md](handson46.md): 変更管理、緊急変更、運用統制を学ぶ
47. [handson47.md](handson47.md): Container と Linux の基礎を Kubernetes 文脈で学ぶ
48. [handson48.md](handson48.md): Kubernetes 内部構造と control plane の役割を学ぶ
49. [handson49.md](handson49.md): Authentication、SSO、Audit の実務を学ぶ
50. [handson50.md](handson50.md): Policy as Code と例外統制を学ぶ
51. [handson51.md](handson51.md): Supply Chain Security と image 信頼性を学ぶ
52. [handson52.md](handson52.md): CRD と Operator の仕組みを学ぶ
53. [handson53.md](handson53.md): Autoscaling、capacity planning、cost の考え方を学ぶ
54. [handson54.md](handson54.md): External Secrets と KMS を前提にした Secret 運用を学ぶ
55. [handson55.md](handson55.md): Stateful HA、replication、DB 運用判断を学ぶ
56. [handson56.md](handson56.md): Multi-cluster、environment 分離、DR 設計を学ぶ
57. [handson57.md](handson57.md): 性能試験、profiling、性能劣化の詰め方を学ぶ
58. [handson58.md](handson58.md): Platform Team、SRE、運用当番の実務を学ぶ
59. [handson59.md](handson59.md): 変更要求の受付から本番反映までを通しで実践する
60. [handson60.md](handson60.md): 障害注入から初動、緩和、復旧、ふりかえりまでを通しで実践する
61. [handson61.md](handson61.md): セキュリティレビューと是正計画を実践する
62. [handson62.md](handson62.md): capacity、cost、scaling のレビューを実践する
63. [handson63.md](handson63.md): production readiness review を実践する
64. [handson64.md](handson64.md): cluster 再構築と復旧訓練を実践する
65. [handson65.md](handson65.md): 30 日運用計画と on-call 改善を実践する
66. [handson66.md](handson66.md): 卒業試験として総合審査と弱点つぶしを行う
67. [handson67.md](handson67.md): Managed Kubernetes とクラウド周辺設計を学ぶ
68. [handson68.md](handson68.md): Terraform と基盤 IaC を学ぶ
69. [handson69.md](handson69.md): Build pipeline と container build engineering を学ぶ
70. [handson70.md](handson70.md): OpenTelemetry と log pipeline の実装設計を学ぶ
71. [handson71.md](handson71.md): Kubernetes 前提のアプリ実装規約を学ぶ
72. [handson72.md](handson72.md): Node、runtime、eviction、OOM の深掘りを学ぶ
73. [handson73.md](handson73.md): 監査、データ保護、コンプライアンス対応を学ぶ
74. [handson74.md](handson74.md): 外部依存と egress 設計、連携障害対応を学ぶ
75. [handson75.md](handson75.md): Platform Engineering と self-service 設計を学ぶ
76. [handson76.md](handson76.md): 非機能要件と業種別本番要件の詰め方を学ぶ

## この分割にした理由

- 学ぶ対象が毎回明確になる
- 途中で止めても再開しやすい
- 実務に必要な論点を、順番に積み上げられる

このシリーズは handson76 まで用意してあり、Helm、Kustomize、HPA、NetworkPolicy、CI/CD、HTTPS、サービスメッシュ、mTLS、カナリアリリース、切り戻し運用に加え、バックアップ / 復旧、Secret 更新、SLO / Alert、障害ふりかえり、再リリース判断、RBAC、Quota、PDB、配置制御、logging / tracing、Pod Security、upgrade、storage 運用、変更管理、container / Linux 基礎、Kubernetes 内部構造、Authentication / Audit、Policy as Code、Supply Chain Security、CRD / Operator、autoscaling / cost、external secrets、stateful HA、multi-cluster / DR、性能改善、team 運用、総合変更運用、障害訓練、セキュリティ審査、capacity / cost 審査、本番審査、再構築訓練、30 日運用計画、卒業審査に加えて、managed Kubernetes、Terraform、build engineering、OpenTelemetry、Kubernetes 前提のアプリ実装、node 深掘り、監査 / データ保護、外部依存設計、platform engineering、非機能要件まで順番に扱えます。

## このシリーズの使い切り方

- 各 handson の完了条件を満たしたあとに、`まだ説明できないこと`, `まだ手順化できないこと`, `まだ自信なく戻せないこと` を 3 つ書く
- その 3 つに対応する前の handson と補助資料へ戻り、確認し直す
- handson59 以降は知識追加ではなく、`残課題がないかを自分で発見して埋める` 総合演習として使う
- handson66 で弱点が出たら、弱かった章へ戻って再実施し、再度 handson66 で確認する

用語が分からなくなったら、都度 [glossary.md](glossary.md) に戻って確認しながら進めてください。