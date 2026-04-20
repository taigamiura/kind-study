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

### ServiceAccount

Pod や Job が Kubernetes API を呼ぶときの実行主体です。人の権限と分けて考えることが重要です。

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

### RBAC

Role Based Access Control の略です。誰が何をできるかを Role と Binding で制御します。

### Role

特定 namespace 内で何をできるかを定義する権限セットです。

### RoleBinding

Role を user や ServiceAccount に結びつける resource です。

### ResourceQuota

namespace ごとの resource 使用量上限を定義する仕組みです。

### LimitRange

container ごとの requests / limits の下限や既定値を決める仕組みです。

### PodDisruptionBudget

メンテナンスや drain 時に同時に落としてよい Pod 数の上限を定義する resource です。

### Cordon

Node へ新しい Pod をスケジュールしないようにする操作です。

### Drain

Node 上の Pod を安全に退避させてメンテナンスできる状態にする操作です。

### Affinity

Pod をどこへ寄せるかの配置ルールです。

### Anti-Affinity

同じ種類の Pod を同じ Node へ寄せすぎないための配置ルールです。

### Topology Spread Constraints

Pod を Node や zone へ偏らせすぎないための分散ルールです。

### Node Selector

特定 label を持つ Node へ Pod を配置する単純な条件です。

### Taint

特定の Pod 以外を寄せ付けないように Node 側へ付ける制約です。

### Toleration

Taint が付いた Node へ Pod を配置してよいことを示す設定です。

## 監視と可観測性の用語

### Observability

システムの内部状態を外から推測しやすくする考え方です。metrics、logs、traces が中心です。

### Logging

アプリや基盤が出すログを集めて検索、分析できるようにする運用です。

### Tracing

1 つのリクエストが複数サービスをどう通ったかを追跡する仕組みです。

### OpenTelemetry

metrics、logs、traces を共通の形式で収集、送信するための標準仕様と実装群です。

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

### SecurityContext

コンテナや Pod をどの権限で実行するかを決める設定です。

### Admission Controller

resource 作成や更新時に検証や変更を行う仕組みです。

### Pod Security Standards

Pod の権限や危険な設定をどこまで許すかを整理した Kubernetes の標準指針です。

### StorageClass

PVC がどの種類のストレージを使うかを決めるクラスです。

### VolumeSnapshot

PVC のある時点の状態を切り出して保存する snapshot resource です。

### Change Management

本番変更をどう承認し、どう記録し、どう例外運用するかを決める運用です。

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

## 実務を深める追加用語

### PID 1

コンテナの中で最初に起動するプロセスです。signal の受け取りや zombie process の回収に影響します。

### Distroless

不要な OS ツールを減らした軽量 image の考え方です。攻撃面を減らせますが debug は難しくなります。

### Cgroup

Linux で CPU や memory の使用量を制御する仕組みです。container の resource 制御の土台です。

### Linux Namespace

process や network を分離する Linux の仕組みです。Kubernetes の container 分離の基礎です。

### API Server

kubectl や controller からの要求を受け取り、resource 状態を管理する control plane の入口です。

### Scheduler

新しい Pod をどの Node に置くかを決める control plane コンポーネントです。

### Controller Manager

Deployment や Node など多くの controller を動かし、望ましい状態へ近づける control plane です。

### Etcd

Kubernetes の状態を保存する key-value store です。control plane の中核です。

### Kubelet

各 Node で Pod を実行、監視する agent です。

### CNI

Pod network をつなぐための plugin 仕様です。

### CSI

storage を Kubernetes へ接続するための plugin 仕様です。

### Authentication

誰として Kubernetes に入るかを確認する仕組みです。RBAC より前段にあります。

### Authorization

認証された主体が何をできるかを判定する仕組みです。RBAC はその代表です。

### OIDC

外部 ID 基盤と Kubernetes を連携するためによく使われる認証方式です。

### Audit Log

誰がいつどの resource を触ったかを記録するログです。監査や調査に重要です。

### Policy As Code

組織ルールや安全基準を YAML やルール定義としてコード化し、自動判定する運用です。

### Kyverno

Kubernetes resource へルールを適用しやすい policy engine の 1 つです。

### Gatekeeper

OPA を Kubernetes policy 運用へ使うための代表的な仕組みです。

### Exception Process

標準ルールから外れる変更をどう承認し、期限管理するかの運用です。

### SBOM

Software Bill of Materials の略です。image や artifact に何が含まれるかの一覧です。

### Image Signature

その image が正しい作成元から来たことを検証するための署名です。

### Provenance

artifact がどの source と build 手順から作られたかを示す来歴情報です。

### Registry

container image を保管して配布する場所です。

### CRD

CustomResourceDefinition の略です。Kubernetes に独自 resource 型を追加する仕組みです。

### Operator

独自 resource を監視して自動運用を行う controller パターンです。

### Reconcile

実状態を望ましい状態へ近づける controller の反復処理です。

### Finalizer

resource 削除前に後始末を保証するための仕組みです。

### OwnerReference

resource 同士の親子関係を示し、連動削除や管理関係に使う情報です。

### Cluster Autoscaler

Pod が載り切らないときに Node 数を増減する仕組みです。

### VPA

Vertical Pod Autoscaler の略です。Pod の requests を推奨、または更新する仕組みです。

### Capacity Planning

必要な Node 数や resource 量を事前に見積もる活動です。

### Bin Packing

Node へ workload を効率よく詰めてコストを抑える考え方です。

### External Secrets

外部 Secret Manager の値を Kubernetes Secret へ同期する仕組みです。

### KMS

Key Management Service の略です。暗号鍵を安全に管理する仕組みです。

### Replication

stateful workload のデータを別ノードや別系統へ複製することです。

### Failover

主系が使えなくなったときに待機系へ切り替えることです。

### Managed Database

DB の冗長化や保守をクラウド側サービスに任せる方式です。

### Multi-Cluster

複数の Kubernetes クラスタを役割分担して運用する構成です。

### Blast Radius

ある障害や誤操作がどこまで影響を広げるかの範囲です。

### Profiling

CPU や memory をどこが消費しているかを詳細に調べる手法です。

### Load Test

意図的に負荷をかけて性能や限界を確認する試験です。

### CPU Throttling

CPU limit により処理が抑制されて遅くなる現象です。

### Platform Team

アプリチームが安全に使える共通基盤を整備するチームです。

### SRE

Site Reliability Engineering の略です。信頼性を設計と運用の両面から高める考え方です。

### On-Call

障害時に一次対応を担う当番運用です。

### Managed Kubernetes

control plane の運用をクラウド事業者が担う Kubernetes サービスです。EKS、GKE、AKS などが代表例です。

### VPC

クラウド内でネットワーク境界を分ける仮想ネットワークです。

### IAM

誰がどのクラウド資源を操作できるかを制御する仕組みです。

### Terraform

クラウド資源や基盤設定をコードで管理する代表的な IaC ツールです。

### State File

Terraform が管理対象の実状態を追跡するために持つ状態ファイルです。

### Plan

IaC の変更差分を事前に確認する手順です。

### Apply

IaC の変更内容を実環境へ反映する手順です。

### Build Cache

container image build 時に再利用して時間短縮する仕組みです。

### Multi-Stage Build

build 用と runtime 用の image を分けて最終 image を小さくする build 手法です。

### Multi-Arch

amd64 や arm64 のように複数 CPU architecture 向けの artifact を扱うことです。

### Artifact Promotion

同じ build artifact を環境ごとに昇格させて利用する運用です。

### Collector

OpenTelemetry で telemetry を受け取り、加工、送信する中継コンポーネントです。

### Sampling

trace や log を一部だけ収集してコストと負荷を抑える考え方です。

### Retention

log や trace、監査データをどれだけ保持するかの期間設計です。

### PII

個人を識別できる情報です。log や trace に混入させない設計が重要です。

### Graceful Shutdown

処理中リクエストを急に壊さず安全に停止する設計です。

### Idempotency

同じ操作を複数回実行しても結果が壊れにくい性質です。

### Connection Draining

停止前に新規接続を止め、既存処理を流し切る考え方です。

### Backward Compatible Change

旧バージョンと新バージョンが共存しても壊れにくい変更です。

### OOM Kill

memory 不足時に kernel が process を強制終了することです。

### Eviction

Node 圧迫時に Kubernetes が Pod を退避させる動作です。

### Node Pressure

Node の CPU、memory、disk などが逼迫している状態です。

### Inode Exhaustion

disk 容量ではなく inode 枯渇で file 作成不能になる状態です。

### Compliance

法令、契約、社内規程へ適合するための要求全般です。

### Audit Trail

誰がいつ何を変更したかを後から追える記録です。

### Data Classification

データを機密度や規制要件で分類して扱いを変えることです。

### Egress Control

クラスタ外への通信先や通信方法を制御する設計です。

### Circuit Breaker

外部依存先の異常時に無制限な呼び出しを止めて影響拡大を防ぐ仕組みです。

### Bulkhead

障害の影響範囲を分離して全体巻き込みを防ぐ考え方です。

### Golden Path

開発者が安全に標準的なやり方を選びやすくする推奨導線です。

### Self-Service Platform

開発者が platform team に毎回依頼せず、自分で標準基盤を利用できる仕組みです。

### NFR

Non-Functional Requirement の略です。性能、可用性、監査性など機能以外の要求を指します。

### Tenant Isolation

複数顧客や複数組織のデータや負荷を分離する設計です。