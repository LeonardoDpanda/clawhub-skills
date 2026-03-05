#!/bin/bash
#
# 自动化链路验证脚本
# Usage: ./verify-pipeline.sh

WORKSPACE="/workspace/projects/workspace"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "=========================================="
echo "🧪 Skill Auto-Publisher 链路验证"
echo "=========================================="
echo ""

PASS=0
FAIL=0
WARNING=0

check_pass() {
    echo -e "${GREEN}✅${NC} $1"
    ((PASS++))
}

check_fail() {
    echo -e "${RED}❌${NC} $1"
    ((FAIL++))
}

check_warn() {
    echo -e "${YELLOW}⚠️${NC} $1"
    ((WARNING++))
}

# 1. 检查必要文件
echo "📁 检查文件结构..."

files=(
    "scripts/auto-skill-pipeline.sh"
    "scripts/daily-skill-generator.sh"
    "scripts/query-registry.sh"
    "skills/skill-auto-publisher/SKILL.md"
    "memory/skill-registry.json"
    "HEARTBEAT.md"
)

for file in "${files[@]}"; do
    if [[ -f "$WORKSPACE/$file" ]]; then
        check_pass "文件存在: $file"
    else
        check_fail "文件缺失: $file"
    fi
done

echo ""

# 2. 检查脚本可执行权限
echo "🔐 检查脚本权限..."

scripts=(
    "scripts/auto-skill-pipeline.sh"
    "scripts/daily-skill-generator.sh"
    "scripts/query-registry.sh"
)

for script in "${scripts[@]}"; do
    if [[ -x "$WORKSPACE/$script" ]]; then
        check_pass "可执行: $script"
    else
        check_warn "不可执行: $script (运行: chmod +x $script)"
    fi
done

echo ""

# 3. 检查 GitHub 认证
echo "🐙 检查 GitHub CLI..."

if command -v gh &>/dev/null; then
    check_pass "GitHub CLI 已安装"
    
    if gh auth status &>/dev/null; then
        USER=$(gh api user -q '.login' 2>/dev/null || echo "unknown")
        check_pass "GitHub 已认证 (用户: $USER)"
    else
        check_fail "GitHub 未认证 (运行: gh auth login)"
    fi
else
    check_fail "GitHub CLI 未安装"
fi

echo ""

# 4. 检查 ClawHub CLI
echo "🐾 检查 ClawHub CLI..."

if command -v clawhub &>/dev/null; then
    check_pass "ClawHub CLI 已安装"
    
    if clawhub whoami &>/dev/null; then
        check_pass "ClawHub 已登录"
    else
        check_fail "ClawHub 未登录 (运行: clawhub login)"
    fi
else
    check_fail "ClawHub CLI 未安装 (运行: npm install -g clawhub)"
fi

echo ""

# 5. 检查通知配置
echo "📱 检查通知配置..."

if [[ -f "$WORKSPACE/config/telegram_bot.conf" ]]; then
    if grep -q "BOT_TOKEN=" "$WORKSPACE/config/telegram_bot.conf" && \
       grep -q "CHAT_ID=" "$WORKSPACE/config/telegram_bot.conf"; then
        check_pass "Telegram 配置已设置"
    else
        check_warn "Telegram 配置不完整"
    fi
else
    check_warn "Telegram 配置未设置 (可选)"
fi

if [[ -f "$WORKSPACE/config/email.conf" ]]; then
    check_pass "邮件配置已设置"
else
    check_warn "邮件配置未设置 (可选)"
fi

echo ""

# 6. 检查 GitHub 仓库访问
echo "🔗 检查仓库连接..."

if gh repo view LeonardoDpanda/clawhub-skills &>/dev/null; then
    check_pass "可访问目标仓库"
else
    check_warn "无法访问仓库 (可能未创建或无权限)"
fi

echo ""

# 7. 检查定时任务
echo "⏰ 检查定时任务..."

if crontab -l 2>/dev/null | grep -q "daily-skill-generator"; then
    check_pass "Cron 任务已配置"
else
    check_warn "Cron 任务未配置 (运行: crontab -e 添加定时任务)"
fi

echo ""

# 8. 检查台账文件格式
echo "📊 检查台账文件..."

if [[ -f "$WORKSPACE/memory/skill-registry.json" ]]; then
    if python3 -c "import json; json.load(open('$WORKSPACE/memory/skill-registry.json'))" 2>/dev/null; then
        check_pass "台账 JSON 格式正确"
    else
        check_fail "台账 JSON 格式错误"
    fi
else
    check_warn "台账文件不存在"
fi

echo ""
echo "=========================================="
echo "📈 验证结果"
echo "=========================================="
echo -e "${GREEN}通过: $PASS${NC}"
echo -e "${YELLOW}警告: $WARNING${NC}"
echo -e "${RED}失败: $FAIL${NC}"
echo ""

if [[ $FAIL -eq 0 ]]; then
    echo -e "${GREEN}🎉 验证完成！系统已就绪。${NC}"
    echo ""
    echo "你可以："
    echo "  1. 立即测试: 发送指令 '立即生成并发布1个高价值Skill'"
    echo "  2. 查询台账: ./scripts/query-registry.sh stats"
    echo "  3. 等待定时: 系统将在每天凌晨1点自动运行"
    exit 0
else
    echo -e "${RED}⚠️ 存在失败的检查项，请修复后重试。${NC}"
    echo ""
    echo "配置指南: docs/AUTO_SKILL_SETUP.md"
    exit 1
fi
