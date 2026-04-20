# Release Decision Template

このテンプレートは、canary の昇格または切り戻しを判断したときに、根拠を短く記録するためのものです。目的は、判断を属人化させず、後から見ても説明できる状態を作ることです。

## 基本情報

- 実施日時:
- 対象機能:
- stable / canary の比率:
- 判断者:
- 観測時間:

## 事前確認

- `bash scripts/mesh-release-preflight.sh` 実施: Yes / No
- sidecar 注入確認: Yes / No
- smoke test 実施: Yes / No

## 観測結果

- restart: 例 `stable/canary とも増加なし`
- CPU: 例 `canary は stable 比で大きな差なし`
- Memory: 例 `canary 側で右肩上がりなし`
- 5xx / timeout: 例 `増加なし`
- ログ: 例 `istio-proxy に目立つ接続失敗なし`

## 判断

- 結論: Promote / Rollback / Hold
- 理由:
- 追加で確認したこと:

## 次のアクション

- Promote の場合: 例 `bash scripts/mesh-canary-promote.sh を実行`
- Rollback の場合: 例 `bash scripts/mesh-canary-rollback.sh を実行`
- Hold の場合: 例 `観測を 10 分延長し、15:40 に再判断`
- Promote / Rollback 後: 例 `bash scripts/mesh-release-postcheck.sh を実行して 10 分追跡監視`
- Rollback 後の調査: 例 `bash scripts/mesh-rollback-evidence.sh を実行し、rollback-investigation-template.md に初動メモを残す`

## 実務での書き方の例

### Promote 例

- 結論: Promote
- 理由: `15 分観測し、restart 増加なし、CPU/Memory に大きな差なし、5xx 増加なし。利用者影響なしと判断。`

### Rollback 例

- 結論: Rollback
- 理由: `canary 側だけ restart が増加し、istio-proxy に upstream 接続失敗が継続したため。利用者影響拡大前に戻す。`

### Hold 例

- 結論: Hold
- 理由: `即時異常はないが観測時間が短く、Memory 傾向を追加確認したいため。15:40 に再判断する。`

## 使い方

1. canary 前に基本情報を埋める
2. `release-metrics.md` と `grafana-canary-checklist.md` を見ながら観測結果を記録する
3. promote / rollback / hold のいずれかを短文で明記する
4. Hold の場合は再判断時刻を必ず書く
5. Promote / Rollback の場合は追跡監視の有無も書く

## このテンプレートで学ぶこと

- 観測結果をそのまま判断につなげること
- 昇格や切り戻しを感覚でなく文章で説明すること
- 実務では `何を見たか` と `なぜそう決めたか` の両方が必要なこと