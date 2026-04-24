# Handson 15

## テーマ

CI/CD で manifest 品質を継続検証する。

## 今回のゴール

- マニフェストを push 前に検証する流れを理解できる
- レンダリング確認とスキーマ検証の違いを説明できる
- GitOps の前段として CI が重要な理由を理解できる

## この回の前提

- この workflow はローカル保存だけでは動かず、GitHub で pull request を作るか `main` へ push したときに動く
- そのため `GitHub Actions が失敗した` と `ローカルでまだ再現していない` は別問題として切り分ける
- 先に手元で `kustomize build` と `kubeconform` を再現しておくと、push 後の調査がかなり速くなる

この回は `workflow ファイルを読んで終わり` ではありません。`ローカルで再現できる検証` と `GitHub 上で自動実行される検証` の境界を理解するのが重要です。

## この回で先に押さえる用語

- CI: 変更を継続的に検証する仕組み
- Manifest: Kubernetes resource を宣言する YAML
- Render: Kustomize や Helm で最終 YAML を組み立てること
- Schema Validation: YAML が期待形式に合っているか確認すること

用語に迷ったら [glossary.md](glossary.md) の Manifest、GitOps を先に確認してください。

## 対応ファイル

- [.github/workflows/validate-manifests.yml](../.github/workflows/validate-manifests.yml)

workflow の発火条件も先に見ておきます。

- `pull_request`: pull request を作成または更新したとき
- `push` to `main`: `main` ブランチへ push したとき

つまり、ローカルで YAML を直しただけでは CI はまだ動きません。`push しないと何も起きない` のではなく、`push 前に自分で再現し、push 後に GitHub が同じ検証を自動で繰り返す` という 2 段構えだと捉えてください。

## この回で実際にやること

1. GitHub Actions workflow を開き、どの順番で何を検証しているか読む
2. ローカルで kustomize build を実行して workflow と同じ検証を手元で試す
3. kubeconform で schema validate の意味を理解する
4. 可能なら GitHub の Actions タブで実際の実行結果を確認する
5. CI が fail したときに何を見ればよいか整理する

## 実行コマンド例

```bash
kubectl kustomize manifests/overlays/local > rendered.yaml
kubeconform -summary -ignore-missing-schemas rendered.yaml
kubeconform -summary -ignore-missing-schemas manifests/extensions/hpa/*.yaml
kubeconform -summary manifests/extensions/networkpolicy/*.yaml
```

各コマンドの目的:

- `kubectl kustomize manifests/overlays/local > rendered.yaml`: overlay を最終 YAML に展開して保存する
- `kubeconform -summary -ignore-missing-schemas rendered.yaml`: build 結果全体の schema 整合性を確認する
- `kubeconform -summary -ignore-missing-schemas manifests/extensions/hpa/*.yaml`: HPA 拡張 manifest 単体の schema を確認する
- `kubeconform -summary manifests/extensions/networkpolicy/*.yaml`: NetworkPolicy 拡張 manifest 単体の schema を確認する

このコマンドで確認するのはここ:

- `kubectl kustomize manifests/overlays/local > rendered.yaml`: 出力された YAML に想定外の kind や namespace が混ざっていないかを見る
- `kubeconform ... rendered.yaml`: `Summary` にエラー件数が出ていないかを見る
- `kubeconform ... manifests/extensions/hpa/*.yaml`: HPA manifest 単体が schema 的に妥当かを見る
- `kubeconform ... manifests/extensions/networkpolicy/*.yaml`: NetworkPolicy manifest 単体が schema 的に妥当かを見る

## この回だけで押さえる整理

CI/CD で重要なのは、`apply 前にどこまで壊れ方を検出するか` です。render error と schema error を分け、ローカル再現と GitHub Actions の役割差を説明できれば、この回のポイントを押さえています。

## 完了条件

- workflow が何を検証しているか順番に説明できる
- 手元でも最低限の manifest 検証を再現できる
- render error と schema error の違いを説明できる
- `ローカルでは通るが GitHub Actions では失敗する` ときに、まずどこを見るか説明できる

## 実務で見る観点

- CI をデプロイ自動化だけでなく、品質ゲートとして設計できるか
- 壊れ方の種類ごとに検証段階を分けて考えられるか

## よくある失敗

CI では `render できた` と `Kubernetes として妥当` を混同すると事故につながります。ローカル再現、CI の失敗段階、どの入力で壊れたかを分けて見ると理解しやすくなります。

- ローカルでファイルを保存しただけで GitHub Actions も動くと思い込む
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

GitHub 側の結果を見るときは、repository の Actions 画面で `validate-manifests` の run を開き、どの step で落ちたかを最初に確認します。`Render local overlay` で落ちたのか、`Validate built manifests` で落ちたのかで見るべきポイントが変わります。

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

初学者が混乱しやすいのは、`ローカル確認` と `GitHub Actions` を同じものだと感じやすい点です。実際には、ローカル確認は自分が失敗を早く見つけるためのもの、GitHub Actions はチーム全体で同じ品質ゲートを必ず通すためのものです。前者は学習や調査の速度を上げ、後者は main に壊れた変更を入れないためにあります。

さらに実務では、構文が正しいだけでは足りません。簡単な smoke test や、少なくとも apply 前提の軽い動作確認を追加することで、設定値ミスや依存関係の崩れを早めに見つけられます。CI は速さも大切ですが、どこまで品質を担保するかの設計が本質です。

## この回の宿題

- 本番向け CI で secrets をどう扱うか考える
- lint、schema validate、integration test の責務を分けて整理する

## 宿題の考え方

secrets の扱いを考えるときは、Git に平文を置かないことを前提に、どこで注入し、誰が参照でき、監査できるかを整理してください。実務では、Secret 管理基盤、GitHub Actions の secret、External Secrets など複数の選択肢があります。宿題では、便利さよりも漏えい時の影響と運用統制を重視して考えてください。

lint、schema validate、integration test の責務分離は、異なる種類の失敗をどの段階で止めるかという話です。書式の乱れ、Kubernetes API 的な不整合、実際に動かしたときの問題は、同じテストでは拾いきれません。宿題では、それぞれが何を守るために存在するのかを言語化してみてください。

この次は、実際に handson ごとに apply して動作確認するフェーズです。