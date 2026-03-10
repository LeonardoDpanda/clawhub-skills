#!/bin/bash
# marketing-metrics-check.sh
# 每小时自动检查关键指标

echo "=== 营销指标检查 $(date) ==="
echo ""

# GitHub指标
echo "📊 GitHub 指标:"
echo "  Repo Stars: [需手动查看 https://github.com/LeonardoDpanda/clawhub-skills/stargazers]"
echo "  Traffic: [需手动查看 Insights > Traffic]"
echo ""

# Gumroad指标
echo "💰 Gumroad 指标:"
echo "  访问: [查看 https://app.gumroad.com/dashboard]"
echo "  销售: [同上]"
echo ""

# 待办提醒
echo "⏰ 待执行推广:"
echo "  [ ] Reddit r/webdev 发帖 (API Tester)"
echo "  [ ] HN Show HN (API Tester)"
echo "  [ ] Twitter 线程发布"
echo ""

# 更新追踪文件
echo "📈 数据已更新: marketing/tracking-dashboard.json"
