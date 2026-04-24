# Handson 17

## テーマ

Sidecar とサービスメッシュを学ぶ。

## 今回のゴール

- sidecar proxy が何をしているか説明できる
- サービスメッシュが east-west traffic に何を提供するか理解できる
- retries、timeouts、mTLS、可観測性の入口を説明できる

## この回で先に押さえる用語

- Sidecar: アプリ横で動く補助コンテナ
- Service Mesh: サービス間通信を共通化する仕組み
- East-West Traffic: クラスタ内部のサービス間通信
- VirtualService: routing を定義する resource
- DestinationRule: 宛先ごとの通信ポリシーを定義する resource

用語に迷ったら [glossary.md](glossary.md) の Sidecar、Service Mesh、East-West Traffic、VirtualService を先に確認してください。

## 対応ファイル

- [manifests/helm/istio-base-values.yaml](../manifests/helm/istio-base-values.yaml)
- [manifests/helm/istiod-values.yaml](../manifests/helm/istiod-values.yaml)
- [scripts/install-istio.sh](../scripts/install-istio.sh)
- [manifests/extensions/servicemesh/apps-namespace-label.yaml](../manifests/extensions/servicemesh/apps-namespace-label.yaml)
- [manifests/extensions/servicemesh/sleep-deployment.yaml](../manifests/extensions/servicemesh/sleep-deployment.yaml)
- [manifests/extensions/servicemesh/peer-authentication.yaml](../manifests/extensions/servicemesh/peer-authentication.yaml)
- [manifests/extensions/servicemesh/user-service-virtualservice.yaml](../manifests/extensions/servicemesh/user-service-virtualservice.yaml)
- [manifests/extensions/servicemesh/user-service-destinationrule.yaml](../manifests/extensions/servicemesh/user-service-destinationrule.yaml)

## この回で実際にやること

1. Istio control plane をインストールする
2. apps namespace に sidecar 自動注入ラベルを付ける
3. user-service と item-service を再起動して sidecar を付与する
4. sleep Pod から mesh 内通信を試す
5. VirtualService と DestinationRule を apply し、mesh でトラフィック制御できることを理解する

## 実行コマンド例

```bash
bash scripts/install-istio.sh
kubectl apply -k manifests/extensions/servicemesh
kubectl rollout restart deployment user-service -n apps
kubectl rollout restart deployment item-service -n apps
kubectl rollout restart deployment web-app -n apps
kubectl get pods -n istio-system
kubectl get pods -n apps
kubectl exec -n apps deploy/sleep -c sleep -- curl -s http://user-service:9898/healthz
kubectl exec -n apps deploy/sleep -c sleep -- curl -s http://item-service:9898/healthz
```

各コマンドの目的:

- `bash scripts/install-istio.sh`: Istio control plane を導入する
- `kubectl apply -k manifests/extensions/servicemesh`: mesh 用 manifest を反映する
- `kubectl rollout restart deployment user-service -n apps`: sidecar 注入を反映するため user-service を再起動する
- `kubectl rollout restart deployment item-service -n apps`: sidecar 注入を反映するため item-service を再起動する
- `kubectl rollout restart deployment web-app -n apps`: sidecar 注入を反映するため web-app を再起動する
- `kubectl get pods -n istio-system`: Istio 本体が起動しているか確認する
- `kubectl get pods -n apps`: apps 側 Pod に sidecar が入ったか確認する
- `kubectl exec -n apps deploy/sleep -c sleep -- curl -s http://user-service:9898/healthz`: mesh 内から user-service へ疎通できるか確認する
- `kubectl exec -n apps deploy/sleep -c sleep -- curl -s http://item-service:9898/healthz`: mesh 内から item-service へ疎通できるか確認する

このコマンドで確認するのはここ:

- `kubectl get pods -n istio-system`: control plane Pod の `READY/STATUS` を見る
- `kubectl get pods -n apps`: sidecar 注入後にコンテナ数が増えているかを `READY` で見る
- `kubectl exec ... user-service`: healthz が成功応答するかを見る
- `kubectl exec ... item-service`: healthz が成功応答するかを見る

## この回だけで押さえる整理

サービスメッシュの入口では、sidecar が何を増やし、アプリ間通信にどう介入するかを理解することが重要です。アプリ本体のコードを書き換えずに通信面の制御を足せる理由を説明できれば、この回の理解は十分です。

## 完了条件

- istio-system namespace に control plane Pod が起動している
- apps namespace の Pod が 2 コンテナ以上になり、sidecar が注入されている
- sleep Pod から user-service と item-service に疎通できる
- mesh の中で traffic policy を宣言できることを説明できる

## 実務で見る観点

- sidecar を使うことで、アプリコードを大きく変えずに通信制御や可観測性を追加できるか
- retries、timeouts、mTLS をアプリ実装から分離して運用できるか

## よくある失敗

サービスメッシュでは、設定を入れたあと Pod を入れ替えないと sidecar が反映されないことが多いです。`manifest を apply した` だけで終わらず、注入結果と通信結果の両方を確認する必要があります。

- namespace へ injection label を付けた後に Pod 再起動をせず、sidecar が入らない
- sidecar 注入後のコンテナ数や logs を見ずに mesh 化できたと思い込む
- mesh の traffic policy を入れたが、どの通信に効くのか説明できない

## 詰まったときの確認コマンド

```bash
kubectl get pods -n istio-system
kubectl get ns apps --show-labels
kubectl get pods -n apps
kubectl describe pod <pod-name> -n apps
kubectl logs <pod-name> -c istio-proxy -n apps
kubectl get peerauthentication,destinationrule,virtualservice -n apps
```

## 障害シナリオと復旧の考え方

想定シナリオ:

- apps namespace を mesh 化したが Pod に sidecar が入っていない
- mesh policy 追加後に内部通信が不安定になる
- Istio 本体は動いているが、期待した retry や timeout が効いていない

復旧の考え方:

- まず namespace label、Pod 再起動、sidecar 注入有無を確認する
- 次に DestinationRule と VirtualService が対象 host に正しく紐付いているかを確認する
- control plane の問題とアプリ疎通の問題を分けて切り分ける

## レビュー観点と運用判断ポイント

- サービスメッシュ導入理由が「流行」ではなく、通信制御や可観測性の要件に基づいているか
- sidecar 注入範囲が必要以上に広くないか
- retry や timeout がアプリ特性に合っており、かえって負荷を悪化させないか

## 模擬インシデント演習

演習内容:

- apps namespace に injection label を付けたのに user-service Pod が 1 コンテナのままという状況を想定する

考えること:

- label、Pod 再作成、sidecar コンテナ、istiod のどこから確認するか
- 何をもって mesh 化できたと判断するか

## レビューコメント例

- 「service mesh の導入手順はありますが、sidecar が実際に注入された確認を完了条件に含めると、学習者が結果を判定しやすいです。」
- 「retry と timeout を mesh 側で扱う意図が明確で良いです。アプリコードに通信制御を散らさない実務上のメリットが見えます。」

## 学ぶポイント

- sidecar proxy はアプリの横で通信を中継し、観測や制御を担う
- サービスメッシュは east-west traffic の標準化レイヤーである
- retries、timeouts、mTLS、可観測性をアプリ実装から切り離せる

## 学ぶポイントの解説

サービスメッシュは、アプリケーション間通信に共通する課題を、アプリコードではなくインフラ側で扱うための仕組みです。sidecar proxy が各 Pod の横で通信を仲介することで、retry、timeout、mTLS、メトリクス収集などを統一的に入れられます。

実務で重要なのは、サービスメッシュを入れること自体ではなく、「何を mesh に任せ、何をアプリで持つべきか」を切り分けることです。通信制御や相互認証は mesh に寄せやすい一方、業務ロジックやアプリ固有のリトライ戦略はアプリで持つべきこともあります。

## この回の宿題

- sidecar proxy に任せるべき責務と、アプリ側で持つべき責務を整理する
- サービスメッシュを導入する価値が高い組織やシステムの条件を考える

## 宿題の考え方

sidecar に任せるべきかを考えるときは、複数サービスで共通し、アプリから切り離しても意味が変わらないものに注目してください。retry、timeout、mTLS、メトリクスはその代表です。一方で、業務的なリトライ条件やドメイン固有のエラーハンドリングはアプリに残すべきことが多いです。

サービスメッシュの導入価値は、サービス数、組織規模、通信制御の複雑さ、セキュリティ要件で高まります。小規模な 1 サービス構成では過剰でも、多数のサービスがある環境では標準化の価値が大きくなります。

次は [handson18.md](handson18.md) で mTLS の STRICT 化とカナリアリリースを学びます。