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

## この分割にした理由

- 学ぶ対象が毎回明確になる
- 途中で止めても再開しやすい
- 実務に必要な論点を、順番に積み上げられる

必要であれば次の段階で handson11 以降を追加し、Helm、Kustomize、HPA、NetworkPolicy、CI/CD に拡張できます。