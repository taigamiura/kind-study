# Handson 14

## テーマ

NetworkPolicy で通信制御を学ぶ。

## 今回のゴール

- default deny の意味を説明できる
- 必要な通信だけを許可する設計を理解できる
- 監視や DNS を忘れると壊れる理由を理解できる

## この回で先に押さえる用語

- NetworkPolicy: Pod 間通信の許可条件を定義する resource
- Default Deny: まず全部止めて必要な通信だけ開ける考え方
- DNS: 名前解決の仕組み
- Namespace: 通信元、通信先の境界としても使う単位

用語に迷ったら [glossary.md](glossary.md) の Namespace と、NetworkPolicy に関係する章を確認しながら進めてください。

## 対応ファイル

- [manifests/extensions/networkpolicy/apps-default-deny.yaml](../manifests/extensions/networkpolicy/apps-default-deny.yaml)
- [manifests/extensions/networkpolicy/infra-default-deny.yaml](../manifests/extensions/networkpolicy/infra-default-deny.yaml)
- [manifests/extensions/networkpolicy/observability-default-deny.yaml](../manifests/extensions/networkpolicy/observability-default-deny.yaml)
- [manifests/extensions/networkpolicy/allow-dns-egress-apps.yaml](../manifests/extensions/networkpolicy/allow-dns-egress-apps.yaml)
- [manifests/extensions/networkpolicy/allow-apps-to-postgres.yaml](../manifests/extensions/networkpolicy/allow-apps-to-postgres.yaml)
- [manifests/extensions/networkpolicy/allow-observability-to-postgres.yaml](../manifests/extensions/networkpolicy/allow-observability-to-postgres.yaml)

## この回で実際にやること

1. default deny の policy を開いて意味を確認する
2. DNS、Ingress、DB 接続の許可 policy を順に読む
3. NetworkPolicy を apply する
4. apps、infra、observability の通信制御がどうなったか確認する
5. どの通信を許可し、どの通信を止めているかを説明する

## 実行コマンド例

```bash
kubectl apply -k manifests/extensions/networkpolicy
kubectl get networkpolicy -A
kubectl describe networkpolicy default-deny -n apps
kubectl describe networkpolicy allow-apps-to-postgres -n infra
kubectl describe networkpolicy allow-ingress-controller-to-apps -n apps
```

各コマンドの目的:

- `kubectl apply -k manifests/extensions/networkpolicy`: NetworkPolicy 群をまとめて反映する
- `kubectl get networkpolicy -A`: namespace ごとに policy が作成されたか確認する
- `kubectl describe networkpolicy default-deny -n apps`: apps 側の default deny の中身を確認する
- `kubectl describe networkpolicy allow-apps-to-postgres -n infra`: DB 接続許可の条件を確認する
- `kubectl describe networkpolicy allow-ingress-controller-to-apps -n apps`: ingress-nginx から apps への許可条件を確認する

このコマンドで確認するのはここ:

- `kubectl get networkpolicy -A`: namespace ごとに policy が作成されているか、名前が想定どおりかを見る
- `kubectl describe networkpolicy default-deny -n apps`: `PodSelector` が apps 全体を想定どおり選んでいるか、`Policy Types` が Ingress/Egress のどちらかを見る
- `kubectl describe networkpolicy allow-apps-to-postgres -n infra`: `PodSelector` が postgres を選んでいるか、`Ingress` の `From` が apps namespace、`Ports` が 5432 になっているかを見る
- `kubectl describe networkpolicy allow-ingress-controller-to-apps -n apps`: `From` が ingress-nginx 側になっているか、許可先 port が期待どおりかを見る

## この回だけで押さえる整理

NetworkPolicy では、許可したい通信経路を先に言語化してから YAML を読むことが重要です。`誰から誰へどの port を許可するか` を ingress と egress で分けて説明できると、この回の理解が安定します。

## 完了条件

- 3 つの namespace に NetworkPolicy が作成されている
- default deny と例外許可の関係を説明できる
- DNS、Ingress、DB 接続をなぜ明示許可する必要があるか理解できる

## 実務で見る観点

- 通信要件を文章で定義してから policy に落とし込めるか
- セキュリティ強化と可用性のバランスを見ながら段階導入できるか

## よくある失敗

NetworkPolicy は `何を止めるか` より先に `何を生かすか` を言語化しないと壊しやすいです。DNS、Ingress、DB 接続のような基礎通信を先に洗い出してから閉じていく方が安全です。

- default deny を入れた直後に DNS や監視まで止めて原因が分からなくなる
- 許可元を広く取りすぎて policy の意味が薄くなる
- どの Service がどこへ通信するかを整理しないまま NetworkPolicy を書き始める

## 詰まったときの確認コマンド

```bash
kubectl get networkpolicy -A
kubectl describe networkpolicy default-deny -n apps
kubectl describe networkpolicy allow-apps-to-postgres -n infra
kubectl get pods -n apps -o wide
kubectl get pods -n infra -o wide
```

## 障害シナリオと復旧の考え方

想定シナリオ:

- policy 追加後に API から DB 接続できなくなる
- 監視や DNS まで止まり、どこで詰まっているか分からない

復旧の考え方:

- default deny と例外許可を分けて順番に適用する
- 通信元 namespace、宛先 Pod、port の 3 点で許可漏れを確認する
- 一度に厳しくしすぎず、段階的に閉じていく

## レビュー観点と運用判断ポイント

- 通信要件が policy より先に文章化されているか
- 許可範囲が広すぎず、保守不能になっていないか
- 可用性を落とさずに段階導入できる順序になっているか

## 模擬インシデント演習

演習内容:

- default deny 適用後に API から DB へ接続できなくなり、監視も一部見えなくなった状況を想定する

考えること:

- DNS、Ingress、DB 接続のどこが止まっているかをどう順番に確認するか
- 例外許可を最小限で戻すには何が必要か

## レビューコメント例

- 「default deny を入れる方針は良いですが、DNS と監視の許可が抜けると学習者が詰まりやすいので確認手順を前に出したいです。」
- 「許可元が広すぎると policy の意味が薄れるので、namespace と port を絞る観点をレビューに入れたいです。」

## 目的

- なんでも通信できる状態から、必要な通信だけ許可する状態に寄せる

## 実務上のメリット

- 万一侵入されても横展開を防ぎやすい
- どの通信が必要か構成理解が深まる

## 学ぶポイント

- いきなり厳しくすると DNS や監視が壊れやすい
- DB は apps と observability からの通信だけ許可する
- ingress-nginx から apps への通信も許可が必要

## 学ぶポイントの解説

NetworkPolicy は、Kubernetes 上でゼロトラストに近い発想を学ぶのにとても良い題材です。何も設定しなければ通信できる環境では、構成が見えづらく、侵入時の横展開も防ぎにくくなります。default deny から必要な通信だけ許可する設計は、面倒ですが、構成を明確にする強力な方法です。

ただし、現実には DNS、監視、Ingress Controller など、つい見落としやすい通信がたくさんあります。そのため、いきなり厳しくすると「なぜか動かない」状態になりやすいです。この回では、通信を止める技術を学ぶだけでなく、必要な通信を言語化する訓練だと考えてください。

実務で重要なのは、NetworkPolicy を書けることより、どの Pod がどこへ話すべきか説明できることです。通信要件が曖昧なまま policy を足すと、後から例外だらけになります。まず通信経路を整理し、その後で policy に落とす順番を意識してください。

## この回の宿題

- もし item-service から user-service への通信が必要になったら、どんな policy を足すべきか考える
- default allow と default deny のどちらから設計すべきか整理する

## 宿題の考え方

item-service から user-service への通信を許可する場合は、「誰から」「誰へ」「どのポートで」の 3 点を明確にしてください。通信要件を文章で定義できれば、NetworkPolicy に落とし込むのは比較的容易です。逆に、要件が曖昧だと広すぎる許可になりやすく、設計意図が崩れます。

default allow と default deny の比較では、最初の作りやすさではなく、長期運用の安全性を見ることが大切です。default allow は始めやすい一方で、不要な通信が残りやすく、あとから締めるのが大変です。宿題では、短期の手軽さと長期の安全性のどちらを優先すべきかを考えてください。

次は [handson15.md](handson15.md) で CI/CD を学びます。