# Handson 15

## テーマ

CI/CD で manifest 品質を継続検証する。

## 今回のゴール

- マニフェストを push 前に検証する流れを理解できる
- レンダリング確認とスキーマ検証の違いを説明できる
- GitOps の前段として CI が重要な理由を理解できる

## この回で先に押さえる用語

- CI: 変更を継続的に検証する仕組み
- Manifest: Kubernetes resource を宣言する YAML
- Render: Kustomize や Helm で最終 YAML を組み立てること
- Schema Validation: YAML が期待形式に合っているか確認すること

用語に迷ったら [glossary.md](glossary.md) の Manifest、GitOps を先に確認してください。

## 対応ファイル

- [.github/workflows/validate-manifests.yml](../.github/workflows/validate-manifests.yml)

## この回で実際にやること

1. GitHub Actions workflow を開き、どの順番で何を検証しているか読む
2. ローカルで kustomize build を実行して workflow と同じ検証を手元で試す
3. kubeconform で schema validate の意味を理解する
4. CI が fail したときに何を見ればよいか整理する

## 実行コマンド例

```bash
kubectl kustomize manifests/overlays/local > rendered.yaml
kubeconform -summary -ignore-missing-schemas rendered.yaml
kubeconform -summary -ignore-missing-schemas manifests/extensions/hpa/*.yaml
kubeconform -summary manifests/extensions/networkpolicy/*.yaml
```

## 完了条件

- workflow が何を検証しているか順番に説明できる
- 手元でも最低限の manifest 検証を再現できる
- render error と schema error の違いを説明できる

## 実務で見る観点

- CI をデプロイ自動化だけでなく、品質ゲートとして設計できるか
- 壊れ方の種類ごとに検証段階を分けて考えられるか

## よくある失敗

- render が通っただけで安心し、schema や依存リソース整合性を見ない
- CI だけで確認し、手元で同じ検証を再現できない
- secrets や環境依存値を workflow に直書きしようとする

## 詰まったときの確認コマンド

```bash
kubectl kustomize manifests/overlays/local > rendered.yaml
head -n 80 rendered.yaml
kubeconform -summary -ignore-missing-schemas rendered.yaml
kubeconform -summary manifests/extensions/networkpolicy/*.yaml
```

## 障害シナリオと復旧の考え方

想定シナリオ:

- pull request では通るが main でだけ壊れる
- render は成功するが schema validate や apply 時に失敗する

復旧の考え方:

- 失敗段階が render、schema、runtime のどこかをまず特定する
- CI と同じコマンドを手元で再現し、差分を確認する
- secrets や環境依存値の注入方法を疑う

## レビュー観点と運用判断ポイント

- CI の責務が lint、render、schema、integration で分かれているか
- 手元再現可能なコマンドが定義されているか
- GitOps 前の品質ゲートとして十分か

## 模擬インシデント演習

演習内容:

- pull request では成功したが、本番反映直前に schema validate が失敗した状況を想定する

考えること:

- render success と schema failure の違いをどう説明するか
- 手元で CI と同じ失敗をどう再現するか

## レビューコメント例

- 「CI で render だけでなく schema validate まで見ているのは良いです。次は軽い smoke test を追加すると runtime 問題も拾いやすくなります。」
- 「workflow はありますが、手元再現コマンドが無いと調査が属人化するので、同じコマンドを docs に残すのは有効です。」

## 目的

- 壊れた manifest を main に入れない

## 実務上のメリット

- デプロイ前に構文と整合性の問題を検知できる
- レビューの質が上がる
- GitOps で自動同期する前に安全性を高められる

## 学ぶポイント

- kustomize build でレンダリングできるか確認する
- kubeconform で API スキーマと整合するか確認する
- 可能なら kind 上で軽い smoke test まで回す

## 学ぶポイントの解説

CI/CD の役割は、デプロイを自動化することだけではありません。壊れた manifest や危険な変更を、本番に近づく前に止めることも重要です。特に GitOps を採用する場合、Git に入ったものが自動同期されるので、CI での検証品質がそのまま運用品質につながります。

kustomize build と kubeconform は似て見えて役割が違います。前者は構成を最終形にレンダリングできるかを見るもので、後者はそれが Kubernetes API と整合しているかを見るものです。つまり、レンダリング成功と妥当性確認は別の段階です。ここを分けて理解しておくと、CI の設計が整理しやすくなります。

さらに実務では、構文が正しいだけでは足りません。簡単な smoke test や、少なくとも apply 前提の軽い動作確認を追加することで、設定値ミスや依存関係の崩れを早めに見つけられます。CI は速さも大切ですが、どこまで品質を担保するかの設計が本質です。

## この回の宿題

- 本番向け CI で secrets をどう扱うか考える
- lint、schema validate、integration test の責務を分けて整理する

## 宿題の考え方

secrets の扱いを考えるときは、Git に平文を置かないことを前提に、どこで注入し、誰が参照でき、監査できるかを整理してください。実務では、Secret 管理基盤、GitHub Actions の secret、External Secrets など複数の選択肢があります。宿題では、便利さよりも漏えい時の影響と運用統制を重視して考えてください。

lint、schema validate、integration test の責務分離は、異なる種類の失敗をどの段階で止めるかという話です。書式の乱れ、Kubernetes API 的な不整合、実際に動かしたときの問題は、同じテストでは拾いきれません。宿題では、それぞれが何を守るために存在するのかを言語化してみてください。

この次は、実際に handson ごとに apply して動作確認するフェーズです。