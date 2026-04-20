# Terraform IaC Guide

この資料は、manifest 管理だけでなく基盤そのものをコードで扱うための最小ガイドです。

## まず押さえること

- cluster の外側もコード管理する
- state は厳密に扱う
- plan review を必ず通す
- drift は manifest だけの問題ではない