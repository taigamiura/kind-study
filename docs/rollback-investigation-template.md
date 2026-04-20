# Rollback Investigation Template

このテンプレートは、rollback 実施後の初動調査メモです。目的は、影響を止めたあとに、何が起きていたかを最小限の情報で残し、次の調査を始めやすくすることです。

## 基本情報

- 発生日時:
- 対象機能:
- rollback 実施者:
- 影響が出た時間帯:
- 利用者影響の概要:

## まず残すこと

- どの症状を検知したか: 例 `5xx 増加`, `restart 増加`, `timeout`, `upstream connect error`
- どのタイミングで rollback したか
- rollback 後に収束したか

## 回収した証跡

- `bash scripts/mesh-rollback-evidence.sh` 実施: Yes / No
- Pod 状態:
- restart 回数:
- CPU / Memory:
- VirtualService の状態:
- istio-proxy ログの要点:

## 最初の仮説

- 例 `canary 側だけ upstream 接続失敗が継続していた`
- 例 `VirtualService の重みは正しいが、canary Pod の readiness が不安定だった`
- 例 `STRICT 化の影響で sidecar 未注入経路が失敗した`

## 次に確認すること

- アプリログと proxy ログの相関確認
- readiness / liveness probe の見直し
- Deployment 差分の確認
- VirtualService / DestinationRule の設定差分確認
- 必要なら再現条件を手元で作る

## 担当と期限

- 誰が調べるか:
- いつまでに一次報告するか:
- 再リリース前に確認する条件:

## 再発防止へつなぐこと

- [preventive-action-template.md](preventive-action-template.md) を作成したか
- すぐやる対策と後でやる対策を分けたか
- 再リリース前に必須な対策を決めたか

## 書き方のコツ

- 原因を断定しない
- `観測した事実` と `仮説` を分ける
- rollback で収束したかどうかを必ず書く
- 次の担当と期限を空欄のままにしない

## このテンプレートで学ぶこと

- rollback 後の初動は原因断定ではなく証跡保全が重要なこと
- 障害対応では `事実`, `仮説`, `次の調査` を分けて整理すること
- 実務では技術的復旧の後に、調査の出発点を残す必要があること
- 実務では調査メモを改善アクションへつなげる必要があること