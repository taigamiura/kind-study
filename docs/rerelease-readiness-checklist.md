# Re-release Readiness Checklist

このチェックリストは、rollback 後に修正を入れたあと、再度 canary を出してよいかを確認するためのものです。目的は、`直したつもり` ではなく、`前回の失敗条件が潰れている` と説明できる状態を作ることです。

## 変更内容の確認

- 前回の失敗に関係する修正が明確か
- 何を直したかを 1 行で説明できるか
- 修正対象が Deployment / ConfigMap / VirtualService / Probe のどこか整理できているか

## 再リリース前に必須な確認

- [preventive-action-template.md](preventive-action-template.md) の `再リリース前に必須な対策` が完了しているか
- rollback 原因として疑ったポイントを再確認したか
- `bash scripts/mesh-rerelease-precheck.sh` を実行したか
- rollback 条件を前回より明確にしたか
- 観測時間を前回より適切に見直したか

## 監視と運用の見直し

- どの指標を最優先で見るか決まっているか
- Hold に入る条件を明文化したか
- rollback の担当者を決めたか
- team への開始連絡文を更新したか

## 再リリースを止める条件

- 前回の失敗原因がまだ仮説のまま
- 修正は入れたが再現確認や差分確認が終わっていない
- rollback 条件が曖昧なまま
- 監視対象や観測時間が前回と同じで、改善がない

## 最低限の確認コマンド

```bash
bash scripts/mesh-rerelease-precheck.sh
bash scripts/mesh-release-preflight.sh
```

## go の目安

- 何を直したか説明できる
- 前回の失敗条件をどう潰したか説明できる
- rollback 条件と観測時間を前回より明確にできる
- 10% canary を再開しても、止める基準が共有されている

## このチェックリストで学ぶこと

- rollback 後の修正は再リリース判定まで含めて考える必要があること
- 実務では `修正した` と `再度出してよい` は別の判断であること
- 再リリース前には技術修正だけでなく運用条件の見直しも必要なこと