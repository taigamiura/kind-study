# Handson 22

## テーマ

障害初動、情報整理、ポストモーテムを学ぶ。

## 今回のゴール

- 障害時に最初の 10 分で何を確認するか説明できる
- 技術確認とチーム共有を並行して進められる
- 復旧後に postmortem を残して次の改善へつなげられる

## この回で先に押さえる用語

- Incident: 通常運用では吸収できない障害
- Triage: 優先度と影響を素早く見る初動整理
- Mitigation: 影響を抑える行動
- Timeline: 何がいつ起きたかの時系列
- Postmortem: ふりかえり文書

## 対応ファイル

- [incident-response-checklist.md](incident-response-checklist.md)
- [postmortem-template.md](postmortem-template.md)
- [release-communication-template.md](release-communication-template.md)
- [rollback-investigation-template.md](rollback-investigation-template.md)
- [preventive-action-template.md](preventive-action-template.md)
- [scripts/cluster-ops-snapshot.sh](../scripts/cluster-ops-snapshot.sh)

## この回で実際にやること

1. 障害を検知した想定で [incident-response-checklist.md](incident-response-checklist.md) を上から実施する
2. `bash scripts/cluster-ops-snapshot.sh` でクラスタ状態を保存する
3. 影響範囲、利用者影響、暫定対応を短文で共有する
4. 復旧後に [postmortem-template.md](postmortem-template.md) を埋める
5. preventive action と rerelease 条件へつなぐ

## 実行コマンド例

```bash
bash scripts/cluster-ops-snapshot.sh
ls -1 artifacts/cluster-snapshots
kubectl get pods -A
kubectl get events -A --sort-by=.lastTimestamp | tail -n 30
```

## 完了条件

- 障害初動の確認順序を説明できる
- snapshot を保存し、後から見返せる状態にできる
- postmortem に `事実`, `判断`, `改善` を分けて書ける

## 実務で見る観点

- 初動で原因断定しすぎていないか
- 利用者影響の共有が技術話だけになっていないか
- 復旧後に `誰が何を直すか` まで落としているか

## よくある失敗

- いきなり深掘りログ調査に入り、影響抑制が遅れる
- 時系列を残さず、後から判断理由を再現できない
- 復旧した瞬間に postmortem を書かず、学びを失う

## 学ぶポイント

- 障害初動は `原因究明` より `影響把握と抑制` を先に行う
- 時系列と共有文を残すことで、後から判断を説明できる
- postmortem は犯人探しではなく、再発防止の設計資料である

## 学ぶポイントの解説

実務の障害対応で一番大きい差は、知識量だけではなく初動の順番です。まずは影響範囲と緊急度を見て、必要なら rollback やスケール調整などの mitigation を打ちます。そのうえで snapshot を取り、ログやイベントを後から追えるようにします。

復旧後は、`何が起きたか`, `なぜそう判断したか`, `次に何を直すか` を postmortem に落とします。この流れが回るようになると、単発対応ではなく運用改善が進むようになります。

## この回の宿題

- 1 つ障害シナリオを決めて、最初の 10 分の行動を時系列で書く
- postmortem に書くべきでない内容と、必ず書くべき内容を分ける

次は [handson23.md](handson23.md) で、リリース中に何のメトリクスを見て判断するかをより実務寄りに固めます。