# Capacity Cost Review Checklist

## 確認項目

- requests / limits が実測と乖離していないか
- replica 数は需要に合っているか
- HPA だけで詰まっていないか
- Node の headroom は十分か
- cost を削りすぎて burst に耐えられなくなっていないか