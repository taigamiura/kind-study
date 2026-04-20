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
- [glossary.md](glossary.md) は handson 本編の前後で何度も参照する辞書として使う

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

## この分割にした理由

- 学ぶ対象が毎回明確になる
- 途中で止めても再開しやすい
- 実務に必要な論点を、順番に積み上げられる

このシリーズは handson37 まで用意してあり、Helm、Kustomize、HPA、NetworkPolicy、CI/CD、HTTPS、サービスメッシュ、mTLS、カナリアリリース、切り戻し運用に加え、バックアップ / 復旧、Secret 更新、SLO / Alert、障害ふりかえり、再リリース判断まで順番に扱えます。

用語が分からなくなったら、都度 [glossary.md](glossary.md) に戻って確認しながら進めてください。