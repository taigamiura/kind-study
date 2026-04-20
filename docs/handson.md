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
- [release-runbook.md](release-runbook.md): handson18 で使う canary 観測、切り戻し、昇格の実務向け runbook

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

## この分割にした理由

- 学ぶ対象が毎回明確になる
- 途中で止めても再開しやすい
- 実務に必要な論点を、順番に積み上げられる

このシリーズは handson18 まで用意してあり、Helm、Kustomize、HPA、NetworkPolicy、CI/CD、HTTPS、サービスメッシュ、mTLS、カナリアリリース、切り戻し運用まで拡張できます。

用語が分からなくなったら、都度 [glossary.md](glossary.md) に戻って確認しながら進めてください。