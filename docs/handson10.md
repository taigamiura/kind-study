# Handson 10

## テーマ

Argo CD による GitOps と、最後の障害訓練を学ぶ。

## 今回のゴール

- Argo CD を入れる意味を説明できる
- Git が正である状態の価値を理解できる
- Kubernetes の自己修復や差分管理を体感できる

## 目的

- kubectl の手作業運用から卒業し、宣言的運用へ移る

## 実務上のメリット

- 設定ドリフトを減らせる
- 誰が何を変えたか追跡しやすい
- rollback と再現性が高くなる

## 推奨分割

- infra Application: ingress, postgres, monitoring
- apps Application: user-service, item-service, web-app

## 最後にやる障害訓練

- API Pod を削除する
- web-app を 3 replica に増やす
- PostgreSQL Pod を再作成する
- Secret の値を壊す
- readinessProbe を失敗させる

## この回で理解すべきこと

- Kubernetes は壊れても戻す仕組みを持つ
- GitOps は変更を残し、比較し、戻しやすくする
- 正常系だけでなく異常系を見ると理解が深まる

## この回の宿題

- kubectl apply を続ける運用の弱さを整理する
- GitOps を導入するとレビューと監査がどう変わるか説明する

## このシリーズの次

次の超大作として、handson11 以降で以下に拡張できます。

- Kustomize
- Helm
- HPA
- NetworkPolicy
- CI/CD
- Blue/Green と Canary