# Handson 4

## テーマ

Ingress と入口設計を学ぶ。

## 今回のゴール

- Ingress の役割を説明できる
- web-app と API の入口をどう統一するか理解できる
- localhost へのポートマッピングが何のためか説明できる

## 今回の構成

- / -> web-app
- /api/users -> user-service
- /api/items -> item-service

## 目的

- ブラウザやクライアントがアクセスする入口を 1 つにまとめる

## 実務上のメリット

- パスやドメインでルーティングを集中管理できる
- TLS 終端や認証連携の拡張先になる

## 学ぶポイント

- Pod を直接公開しない理由
- Service と Ingress の役割分担
- kind の extraPortMappings がローカル学習で重要な理由

## 観察コマンド例

```bash
kubectl get svc -A
kubectl get ingress -A
kubectl describe ingress -n apps
```

## この回で理解すべきこと

- Service は内部向けの安定した宛先
- Ingress は外部入口のルーティング定義

## この回の宿題

- もし Ingress がなければ、どんな URL 設計になるか考える
- API が増えたときに入口を 1 つにまとめる価値を説明する

次は [handson5.md](handson5.md) で PostgreSQL を永続化します。