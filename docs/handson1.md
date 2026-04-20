# Handson 1

## テーマ

この学習で何を作るのかを理解する。

## 今回のゴール

- 最終構成を説明できる
- なぜその構成が Kubernetes 学習に向いているか説明できる
- 何をどの順で学ぶのか把握できる

## 作るもの

kind 上に次の小さな業務システムを作ります。

- PostgreSQL
- user-service
- item-service
- web-app
- Grafana
- Argo CD
- Ridgepole によるスキーマ管理

## 想定アーキテクチャ

- 入口: Ingress NGINX
- フロント: web-app
- API: user-service, item-service
- DB: PostgreSQL
- 監視: Prometheus, Grafana
- GitOps: Argo CD
- スキーマ変更: Ridgepole Job または CI

## なぜこの構成にするのか

目的:

- stateless と stateful の違いを同じ環境で比較する
- 本番運用で必要になる監視と GitOps まで一気通貫で学ぶ

実務上のメリット:

- 単にアプリを動かすだけでなく、運用の論点まで触れられる
- 小さいが現実的なシステム境界を学べる

## この回で確認すること

- PostgreSQL は stateful workload だと理解できるか
- API と Web は stateless として扱いやすいと理解できるか
- Grafana 単体ではなく Prometheus と組み合わせる理由を説明できるか
- Argo CD を使うと Git が正になる意味を説明できるか

## この回の宿題

次の問いに自分の言葉で答えてください。

- なぜ DB と API を同じ Deployment にしないのか
- なぜ最初から監視と GitOps まで含めて学ぶ価値があるのか

次は [handson2.md](handson2.md) でクラスタ自体を観察します。