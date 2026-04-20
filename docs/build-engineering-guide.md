# Build Engineering Guide

この資料は、container build を release engineering の一部として扱うための最小ガイドです。

## 主な論点

- build cache と再現性
- multi-stage build
- multi-arch build
- immutable artifact と promotion
- scan、sign、SBOM の組み込み