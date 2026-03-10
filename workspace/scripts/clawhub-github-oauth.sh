#!/bin/bash
# clawhub-github-oauth.sh - 使用GitHub账号登录ClawHub

# GitHub Token（已有）
GITHUB_TOKEN="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"

# 步骤1: 尝试GitHub OAuth登录ClawHub
echo "🔄 尝试GitHub OAuth登录ClawHub..."

# 检查ClawHub是否支持GitHub OAuth登录
curl -s -X POST "https://clawhub.ai/api/v1/auth/github" \
  -H "Content-Type: application/json" \
  -d "{
    \"access_token\": \"$GITHUB_TOKEN\",
    \"provider\": \"github\"
  }" 2>&1

echo ""
echo "---"

# 如果上面的不行，尝试获取ClawHub Session
echo "🔄 尝试获取ClawHub Session..."

# 检查是否有其他认证方式
curl -s "https://clawhub.ai/api/v1/auth/providers" 2>&1

echo ""
echo "✅ 测试完成"
