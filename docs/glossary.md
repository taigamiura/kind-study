# Glossary

このファイルは、このシリーズで頻出する Kubernetes 用語を短くつかむための用語ガイドです。厳密な定義を丸暗記するためではなく、「今なぜその仕組みが必要なのか」を追いやすくするために使ってください。

## 読み方のコツ

- まず「クラスタ全体の話か」「アプリ配備の話か」「通信の話か」「運用の話か」で分けて考える
- 似た用語は 1 つずつではなく比較で覚える
- 1 回で全部覚えようとせず、分からなくなったら戻る辞書として使う

## クラスタの基本用語

### Cluster

Kubernetes 全体の実行環境です。Node、API Server、Scheduler などを含む全体を指します。

### Node

Pod が実際に動くマシンです。kind では Docker コンテナの中に Node が作られます。

### Namespace

リソースを論理的に分ける仕組みです。環境分離や責務分離の単位として使います。

### Resource

Kubernetes で管理する対象の総称です。Pod、Service、Deployment、Secret などはすべて resource です。

## アプリ配備の用語

### Pod

コンテナを実行する最小単位です。通常は 1 つ以上のコンテナをまとめて持ちます。

### Deployment

stateless なアプリを安全に更新、増減させるための仕組みです。Web や API でよく使います。

### StatefulSet

DB のように順序、名前、永続ストレージが重要な workload を扱う仕組みです。

### ReplicaSet

Deployment の裏側で Pod 数を維持する resource です。通常は Deployment 経由で使います。

### Container Image

コンテナ実行に必要なファイル一式をまとめたものです。Deployment などから参照されます。

### Probe

アプリの健康状態を Kubernetes が確認する仕組みです。

### livenessProbe

アプリが壊れていたら再起動すべきかを見る probe です。

### readinessProbe

リクエストを受けてよい状態かを見る probe です。失敗すると Service の配信先から外れます。

## 通信と公開の用語

### Service

Pod の前段に置く安定した接続先です。Pod が入れ替わっても同じ名前で接続できます。

### Service Discovery

どの Pod にどう接続するかを名前解決で見つける仕組みです。Kubernetes では Service 名が重要です。

### Ingress

クラスタ外からの HTTP/HTTPS アクセスをまとめて受ける入口です。

### Ingress Controller

Ingress resource の内容を実際の通信制御に変換して動かす本体です。このシリーズでは ingress-nginx を使います。

### East-West Traffic

クラスタ内部のサービス間通信です。service mesh で主に扱う対象です。

### North-South Traffic

利用者や外部システムとクラスタ間の通信です。Ingress や Load Balancer で扱うことが多いです。

## 設定と機密情報の用語

### ConfigMap

アプリ設定のような機密でない値を渡す resource です。

### Secret

パスワードやトークン、証明書のような機密情報を扱う resource です。

### Rotation

Secret や認証情報を定期的に更新する運用です。漏えい対策や期限管理で重要です。

### Renewal

証明書や認証情報を期限切れ前に更新することです。

### Environment Variable

コンテナへ設定値を渡す方法の 1 つです。ConfigMap や Secret から流し込むことが多いです。

## 永続化の用語

### PersistentVolumeClaim

永続ストレージを「これだけ欲しい」と要求する resource です。PVC と略されます。

### PersistentVolume

実体となるストレージ resource です。PVC はこれに結びつきます。

### Stateful Workload

データや識別子を持ち、Pod の作り直しだけでは済まない workload です。DB が代表例です。

### Stateless Workload

Pod が入れ替わっても本質的な状態を持たない workload です。Web や API が代表例です。

### Backup

障害時に備えてデータを別の場所へ退避することです。

### Restore

backup したデータを使って元の状態へ戻すことです。

### RPO

Recovery Point Objective の略です。どこまでのデータ損失を許容するかを表します。

### RTO

Recovery Time Objective の略です。どのくらいの時間で復旧すべきかを表します。

### DR

Disaster Recovery の略です。大きな障害から戻すための設計や運用を指します。

## 運用と変更管理の用語

### Manifest

Kubernetes resource を YAML で宣言したファイルです。

### Kustomize

YAML を base と overlay で組み立てる仕組みです。環境差分管理に向いています。

### Helm

Kubernetes 向けのパッケージ管理ツールです。アドオンの導入でよく使います。

### GitOps

Git の内容を正としてクラスタ状態を管理する運用です。手作業変更を減らし、再現性を上げます。

### Argo CD

GitOps を実現するためのツールです。Git とクラスタの差分を見て同期します。

### Drift

Git や manifest と、実クラスタの状態がずれていくことです。

### Rollout

新しいバージョンへ段階的に切り替えることです。

### Rollback

問題が起きたときに前の安全な状態へ戻すことです。

### Runbook

障害対応や運用手順を定型化した手順書です。

## 監視と可観測性の用語

### Observability

システムの内部状態を外から推測しやすくする考え方です。metrics、logs、traces が中心です。

### SLI

Service Level Indicator の略です。成功率やレイテンシのように、サービス品質を測る具体的な指標です。

### Metrics

CPU 使用率、リクエスト数、エラー率のように数値で継続観測する情報です。

### Latency

リクエストを受けてから応答するまでの時間です。利用者が遅いと感じる問題に直結しやすい指標です。

### Error Rate

リクエスト全体のうち失敗した割合です。5xx の増加を把握するときに重要です。

### SLO

Service Level Objective の略です。どの程度の成功率や応答時間を目標とするかを表す運用上の基準です。

### Error Budget

SLO から逆算した、許容できる失敗の余地です。変更速度と安定性のバランスを考えるときに使います。

### Alert

人の対応が必要な異常を通知する仕組みです。

### Noise

通知が多すぎて価値が下がっている状態です。alert fatigue の原因になります。

### Grafana

metrics を可視化するダッシュボードツールです。

### Prometheus

metrics を収集、保存、検索する監視基盤です。

### ServiceMonitor

Prometheus Operator 系で、どの Service から metrics を集めるか定義する resource です。

### Smoke Test

本格試験の前に、最低限の疎通や重要機能だけを手早く確認するテストです。

### Incident

通常運用では吸収できず、利用者影響や緊急対応が必要な障害です。

### Triage

障害時に影響範囲、優先度、緊急度を素早く整理することです。

### Mitigation

障害の根本原因を直す前に、まず影響を抑えるための行動です。rollback や一時的な scale 変更などが含まれます。

### Timeline

障害時に何がいつ起きたかを時系列で整理した記録です。

### Postmortem

障害後に、事実、判断、改善を整理して次に生かすふりかえり文書です。

## セキュリティと service mesh の用語

### Sidecar

アプリ本体の横で一緒に動く補助コンテナです。service mesh では proxy が sidecar として入ります。

### Service Mesh

サービス間通信の制御、認証、観測を共通化する仕組みです。

### Istio

代表的な service mesh 実装です。このシリーズでは学習用に利用します。

### mTLS

相互 TLS のことです。通信相手がお互いを証明しながら暗号化通信します。

### PeerAuthentication

Istio で mTLS の受け入れ方を決める resource です。

### PERMISSIVE

平文通信と mTLS 通信の両方を許す移行モードです。

### STRICT

mTLS のみを許可する強いモードです。sidecar 未注入通信は失敗します。

### VirtualService

Istio でリクエストの routing を定義する resource です。canary の重み付けにも使います。

### DestinationRule

Istio で宛先サービスごとの通信ポリシーを定義する resource です。

### Canary Release

新バージョンを一部の流量だけに流し、問題がないかを見ながら段階的に広げるリリース手法です。

## DB とスキーマ運用の用語

### Schema Migration

DB スキーマ変更を安全に進めるための手順や仕組みです。

### Ridgepole

Ruby 系で使われる schema-as-code ツールです。このシリーズでは DB スキーマ管理の例として扱います。

## 迷ったときの見分け方

- Pod / Deployment / StatefulSet で迷ったら: 何を動かすか、どう更新するか、状態を持つかで分ける
- Service / Ingress で迷ったら: 内部接続先か、外部入口かで分ける
- ConfigMap / Secret で迷ったら: 機密情報かどうかで分ける
- Deployment / StatefulSet で迷ったら: Pod を入れ替えても困らないかで分ける
- PERMISSIVE / STRICT で迷ったら: 移行中か、本番寄りの強制状態かで分ける