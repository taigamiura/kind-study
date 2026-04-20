# Change Execution Scenario

この資料は、変更要求を受けてから本番反映後の追跡監視までを 1 本の流れで練習するためのシナリオです。

## 想定変更

- user-service の image 更新
- requests / limits の見直し
- canary で段階配布

## 確認すること

- 変更理由
- 影響範囲
- rollback plan
- 観測項目
- 共有文面