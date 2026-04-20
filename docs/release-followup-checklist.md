# Release Follow-up Checklist

この資料は、promote または rollback の直後に行う追跡監視のチェックリストです。目的は、判断した瞬間で終わらせず、その判断が正しかったかを短時間で確認することです。

## Promote 後に見ること

- 5 分から 10 分は監視を継続する
- restart が増えていないか
- 5xx や timeout が増えていないか
- CPU、Memory が全量配布後に急増していないか
- team へ `継続監視中` または `監視完了` を共有したか

## Rollback 後に見ること

- stable 側で restart が増えていないか
- 5xx や timeout が収束したか
- rollback 後の通信が安定しているか
- 影響抑制を確認したことを team へ共有したか
- 次の原因調査タスクを切り出したか
- `bash scripts/mesh-rollback-evidence.sh` で証跡を回収したか
- [rollback-investigation-template.md](rollback-investigation-template.md) に初動メモを残したか
- [preventive-action-template.md](preventive-action-template.md) に改善アクションを残したか
- [rerelease-readiness-checklist.md](rerelease-readiness-checklist.md) で再リリース前条件を整理したか

## Hold 後に見ること

- 何分延長するか決めたか
- 再判断時刻を共有したか
- 延長観測で何を見るかを絞ったか
- 再判断後に Promote / Rollback / Hold を更新したか

## 最低限の確認コマンド

```bash
bash scripts/mesh-release-postcheck.sh
bash scripts/mesh-release-summary.sh 50
bash scripts/mesh-rollback-evidence.sh
```

## 終了条件

- Promote 後: 追跡監視で異常なしを確認した
- Rollback 後: 影響抑制を確認し、証跡と初動調査メモと改善アクションを残した
- 再リリース前: 前回の失敗条件が潰れていることを確認した
- Hold 後: 再判断時刻までの観測計画が明確になった

## このチェックリストで学ぶこと

- リリースは判断した瞬間で終わらないこと
- promote / rollback / hold のそれぞれに後続作業があること
- 実務では `決めた後に確認する` までが運用であること
- rollback 後は `戻した` だけでなく `何を残したか` も重要なこと
- 実務では `調査した` だけでなく `次の改善を決めた` までが重要なこと
- 実務では `直したつもり` ではなく `再リリースしてよい条件を満たした` と言えることが重要なこと