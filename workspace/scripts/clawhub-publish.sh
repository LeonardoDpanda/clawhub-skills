#!/bin/bash
# clawhub-publish.sh - 批量发布Skills到ClawHub

CLAWHUB_TOKEN="clh_1fCyGAxj2bNgAqc3UmhZZJ9z4F0dbHAAVFlyzIEOPaA"
CLAWHUB_API="https://api.clawhub.com/v1"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🚀 ClawHub 批量发布工具"
echo "========================"

# 检查参数
if [ $# -eq 0 ]; then
    echo "用法: $0 <skill-directory>"
    echo "示例: $0 skills/config-format-converter-pro"
    exit 1
fi

SKILL_DIR=$1
SKILL_FILE="$SKILL_DIR/SKILL.md"

# 检查文件是否存在
if [ ! -f "$SKILL_FILE" ]; then
    echo -e "${RED}✗ 错误: 找不到 $SKILL_FILE${NC}"
    exit 1
fi

# 提取Skill名称
SKILL_NAME=$(grep "^name:" "$SKILL_FILE" | head -1 | cut -d':' -f2 | xargs)
if [ -z "$SKILL_NAME" ]; then
    SKILL_NAME=$(basename "$SKILL_DIR")
fi

echo "📦 正在发布: $SKILL_NAME"
echo "📄 文件: $SKILL_FILE"

# 读取文件内容
SKILL_CONTENT=$(cat "$SKILL_FILE" | base64 -w0)

# 发布到ClawHub
echo "🌐 上传到ClawHub..."

RESPONSE=$(curl -s -X POST "$CLAWHUB_API/skills" \
    -H "Authorization: Bearer $CLAWHUB_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
        \"name\": \"$SKILL_NAME\",
        \"content\": \"$SKILL_CONTENT\",
        \"source\": \"github\",
        \"visibility\": \"public\"
    }" 2>&1)

# 检查响应
if echo "$RESPONSE" | grep -q "success\|created\|updated"; then
    echo -e "${GREEN}✓ 发布成功!${NC}"
    echo "🔗 URL: https://clawhub.com/skills/$SKILL_NAME"
    exit 0
else
    echo -e "${YELLOW}⚠ 响应: $RESPONSE${NC}"
    echo -e "${RED}✗ 发布可能失败，请检查API响应${NC}"
    exit 1
fi
