# Handson 50

## テーマ

Policy as Code と例外統制を学ぶ。

## 今回のゴール

- review だけで安全を守る限界を理解する
- policy engine で `禁止する`, `警告する`, `修正を促す` という考え方を説明できる
- 例外申請が必要な理由を説明できる

## この回で先に押さえる用語

- Policy as Code
- Admission Controller
- Kyverno
- Gatekeeper
- Exception Process

## 対応ファイル

- [policy-as-code-guide.md](policy-as-code-guide.md)
- [manifests/extensions/policy/require-requests-limits-policy.yaml](../manifests/extensions/policy/require-requests-limits-policy.yaml)
- [scripts/policy-gap-check.sh](../scripts/policy-gap-check.sh)

## この回で実際にやること

1. [policy-as-code-guide.md](policy-as-code-guide.md) を読む
2. requests / limits 強制の policy 例を読む
3. `bash scripts/policy-gap-check.sh apps` を実行して current deployment を確認する
4. `何を人の review に任せ, 何を admission で止めるべきか` を整理する

## この回だけで押さえる整理

Policy as Code の目的は `何でも自動で止める` ことではありません。人の review では毎回見落としやすいものを、Admission で機械的に守ることです。逆に、文脈判断が必要なものまで全部禁止すると、現場が回らず例外だらけになります。

考え方は `即禁止`, `警告`, `人の review`, `期限付き例外` の 4 段階に分けると整理しやすいです。例えば privileged や requests / limits 未設定は Admission で止めやすい一方、業務理由のある一時例外は期限付きで管理する方が現実的です。

## このコマンドで確認するのはここ

- `bash scripts/policy-gap-check.sh apps`: requests / limits、securityContext、image tag などで policy に引っかかりそうな gap がないかを見る
- policy 化候補を考えるとき: `毎回 review で見落としやすいもの` が何かを確認する

## 完了条件

- Policy as Code の必要性を説明できる
- admission で止めるべき代表例を説明できる
- 例外運用を期限付きにすべき理由を説明できる

## 実務で見る観点

- requests / limits, non-root, image tag, privileged などを自動検査できているか
- 例外が無期限化していないか
- 監査可能な policy 変更フローがあるか

## よくある失敗

この回の失敗は、policy を厳しくすること自体が目的になると起きやすいです。箇条書きは別々に見えても、背景には `何を review に任せ, 何を admission で止めるか` の役割分担不足があります。

- review だけで統制できると思う
- policy を厳しくしすぎて現場が回らない
- 例外管理がなく抜け道だらけになる

## 学ぶポイント

- Policy as Code は review の代替ではなく、繰り返し守るべき最低線を自動化する仕組みである
- 何でも禁止すると強いのではなく、禁止・警告・例外の使い分けが重要である
- 例外運用を期限と責任者なしで放置すると、policy は形だけになる

## 学ぶポイントの解説

人の review は文脈判断に強いですが、毎回同じチェックを漏れなく繰り返すのは苦手です。そこで Policy as Code を使い、requests / limits、non-root、privileged のような `毎回守るべき最低線` を機械に持たせます。これにより、review はより設計的な論点へ集中できます。

一方で、Admission は強力すぎると運用を止めます。だからこそ `本当に止めるべきものか`, `警告で十分か`, `例外の出口があるか` を設計しないと、現場では policy を無効化したくなります。このバランス感覚まで含めて理解できると、この回のゴールに届きます。


## 詰まったときの確認ポイント

- 人の review だけで本当に守れるルールか
- admission で止めるべきものと警告でよいものを分けられているか
- 例外に期限と責任者があるか

## この回の後に必ずやること

1. 今の repo で policy 化したい項目を 5 つ選ぶ
2. そのうち `即禁止`, `警告`, `例外付き許可` に分類する
3. [policy-as-code-guide.md](policy-as-code-guide.md) を見て漏れている観点を確認する

## この回の宿題

- admission で止めたいルールを 5 つ書く
- 例外申請に最低限必要な項目を整理する

次は [handson51.md](handson51.md) で Supply Chain Security を学びます。