# Security Review Checklist

## 確認項目

- 強すぎる権限はないか
- non-root、readOnlyRootFilesystem、capabilities drop が設定されているか
- Secret の原本管理が明確か
- image の scan / 署名 / SBOM があるか
- privileged や latest tag が残っていないか