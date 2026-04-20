# Multi Cluster DR Guide

この資料は、環境分離と DR を cluster 単位でどう設計するかの最小ガイドです。

## 基本の観点

- blast radius を小さくする
- environment ごとに責務を分ける
- compute だけでなく data と DNS も考える

## 実務で学ぶこと

- multi-cluster は目的から逆算して選ぶべきである