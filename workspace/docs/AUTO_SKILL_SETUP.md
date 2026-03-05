# Skill Auto-Publisher 配置指南

## 📋 配置清单

### 1. GitHub 配置（已确认 ✅）
- [x] 仓库已创建: `https://github.com/LeonardoDpanda/clawhub-skills`
- [ ] 配置 GitHub CLI 认证

```bash
# 执行以下命令
gh auth login
# 选择 HTTPS 或 SSH，按提示完成认证

# 验证
gh auth status
```

---

### 2. ClawHub 配置（已确认有账号 ✅）
- [ ] 安装 ClawHub CLI
- [ ] 登录认证

```bash
# 安装 CLI
npm install -g clawhub

# 登录
clawhub login
# 按提示输入账号和 Token

# 验证
clawhub whoami
```

---

### 3. Gumroad 配置（新增 - 自动变现）

#### 3.1 获取 Access Token
1. 访问 https://gumroad.com/settings/advanced
2. 生成新的 Personal Access Token
3. 复制 Token（格式: `abc123...`）

#### 3.2 配置 Token
```bash
# 创建配置文件
mkdir -p /workspace/projects/workspace/config
cat > /workspace/projects/workspace/config/gumroad.env << 'EOF'
GUMROAD_ACCESS_TOKEN=your_token_here
GUMROAD_CREATOR_ID=9708247063907
EOF
chmod 600 /workspace/projects/workspace/config/gumroad.env
```

#### 3.3 验证配置
```bash
source /workspace/projects/workspace/config/gumroad.env
curl -s "https://api.gumroad.com/v2/products" \
  -H "Authorization: Bearer $GUMROAD_ACCESS_TOKEN" | head -20
```

---

### 4. Telegram 配置（通知渠道）
- [ ] 创建 Bot 并获取 Token
- [ ] 获取 Chat ID

#### 步骤:
1. 打开 Telegram，搜索 `@BotFather`
2. 发送 `/newbot`
3. 按提示输入 Bot 名称和用户名
4. 保存返回的 Token（格式: `123456789:ABCdefGHI...`）
5. 搜索你的新 Bot，发送 `/start`
6. 访问: `https://api.telegram.org/bot<你的Token>/getUpdates`
7. 找到 `chat.id` 值（纯数字，如 `123456789`）

#### 配置文件:
```bash
# 创建配置文件
cat > /workspace/projects/workspace/config/telegram_bot.conf << 'EOF'
BOT_TOKEN="你的BotToken"
CHAT_ID="你的ChatID"
EOF
```

---

### 5. 邮件配置（可选）

#### 方案 A: 使用本地 mail/mailx
```bash
# 安装
apt update && apt install -y mailutils

# 配置发送邮箱
cat > /workspace/projects/workspace/config/email.conf << 'EOF'
EMAIL_TO="你的邮箱@example.com"
EOF
```

#### 方案 B: 使用 Python smtplib（推荐）
```bash
# 创建邮件发送脚本
cat > /workspace/projects/workspace/scripts/send-email.py << 'PYEOF'
#!/usr/bin/env python3
import smtplib
import sys
from email.mime.text import MIMEText

SMTP_SERVER = "smtp.gmail.com"
SMTP_PORT = 587
SMTP_USER = "your_email@gmail.com"
SMTP_PASS = "your_app_password"
EMAIL_TO = "your_email@example.com"

msg = MIMEText(sys.stdin.read())
msg['Subject'] = sys.argv[1] if len(sys.argv) > 1 else 'Notification'
msg['From'] = SMTP_USER
msg['To'] = EMAIL_TO

with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
    server.starttls()
    server.login(SMTP_USER, SMTP_PASS)
    server.send_message(msg)
PYEOF
chmod +x /workspace/projects/workspace/scripts/send-email.py
```

---

### 6. 定时任务配置（每天凌晨1点执行5个Skills）

由于 systemd 不可用，使用 HEARTBEAT 机制:

编辑 `HEARTBEAT.md`:
```markdown
# Daily Skill Auto-Generation

## Schedule
- Check time: Every 30 minutes
- Trigger condition: Beijing time 01:00 (UTC 17:00)
- Batch size: 5 Skills per run

## Tasks
1. If current time is 01:00-01:30 Beijing time:
   - Spawn subagent with task "生成并发布5个高价值Skill"
   - Include: GitHub + ClawHub + Gumroad auto-publish

2. Check execution log from last run
3. Report any failures
4. Track Gumroad monetization status

## State Tracking
Track in memory/heartbeat-state.json:
{
  "lastDailySkillRun": "2026-03-04",
  "lastCheckTime": "2026-03-04T18:30:00",
  "batchConfig": {
    "skillsPerBatch": 5,
    "platforms": ["github", "clawhub", "gumroad"]
  }
}
```

---

## 💰 变现平台扩展计划

### 当前集成（Phase 1）
| 平台 | 状态 | 特点 | 自动发布 |
|-----|------|------|---------|
| **Gumroad** | ✅ Active | 创作者友好，低手续费 | ✅ 已集成 |

### 计划集成（Phase 2）
| 平台 | 优先级 | 特点 | 适合场景 |
|-----|--------|------|---------|
| **Lemon Squeezy** | ⭐ 高 | 自动税费/VAT，更好国际化 | 全球销售 |
| **Ko-fi** | ⭐ 中 | 会员订阅制，社区友好 | 粉丝支持 |
| **Buy Me a Coffee** | ⭐ 中 | 社交属性，小额打赏 | 个人创作者 |

### 未来考虑（Phase 3）
| 平台 | 优先级 | 特点 |
|-----|--------|------|
| **Paddle** | ⭐ 中 | 企业级，B2B友好 |
| **Product Hunt** | ⭐ 高 | 发布日流量大 |
| **Gumroad Memberships** | ⭐ 低 | Skill合集订阅 |

### 平台对比

```
┌─────────────────┬──────────┬──────────┬──────────┐
│     平台        │  手续费  │  结算    │  特点    │
├─────────────────┼──────────┼──────────┼──────────┤
│ Gumroad         │ 10%+费用 │ 周/月    │ 简单易用 │
│ Lemon Squeezy   │ 5%+50¢   │ 即时     │ 自动税务 │
│ Ko-fi           │ 0-5%     │ 即时     │ 会员制   │
│ Paddle          │ 5%+费用  │ 月       │ B2B首选  │
└─────────────────┴──────────┴──────────┴──────────┘
```

---

## 🔧 验证流程

配置完成后，运行验证:

```bash
# 1. 验证 GitHub
cd /tmp && git clone https://github.com/LeonardoDpanda/clawhub-skills.git && echo "✅ GitHub OK"

# 2. 验证 ClawHub
clawhub whoami && echo "✅ ClawHub OK"

# 3. 验证 Gumroad
source /workspace/projects/workspace/config/gumroad.env
curl -s "https://api.gumroad.com/v2/products" \
  -H "Authorization: Bearer $GUMROAD_ACCESS_TOKEN" | grep -q "products" && echo "✅ Gumroad OK"

# 4. 验证 Telegram
source /workspace/projects/workspace/config/telegram_bot.conf
curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getMe" | grep -q "username" && echo "✅ Telegram OK"

# 5. 验证脚本
/workspace/projects/workspace/scripts/auto-skill-pipeline.sh check

# 6. 查询台账
/workspace/projects/workspace/scripts/query-registry.sh stats
```

---

## 📁 文件结构

```
/workspace/projects/workspace/
├── scripts/
│   ├── auto-skill-pipeline.sh      # 主自动化脚本
│   ├── gumroad-publish.sh          # Gumroad API发布脚本 ⭐新增
│   └── query-registry.sh           # 台账查询工具
├── skills/
│   └── skill-auto-publisher/
│       └── SKILL.md                # Skill生成器技能
├── memory/
│   ├── skill-registry.json         # 台账数据（含batch记录）
│   ├── skill-pipeline.log          # 执行日志
│   └── heartbeat-state.json        # 定时任务状态
├── config/
│   ├── telegram_bot.conf           # Telegram配置
│   ├── email.conf                  # 邮件配置
│   └── gumroad.env                 # Gumroad API Token ⭐新增
└── docs/
    └── AUTO_SKILL_SETUP.md         # 本文件
```

---

## ✅ 配置完成检查表

### 基础配置
- [ ] GitHub CLI 认证完成
- [ ] ClawHub CLI 安装并登录

### 变现平台
- [ ] Gumroad Access Token 配置
- [ ] Gumroad API 测试通过
- [ ] 自动定价策略确认

### 通知渠道
- [ ] Telegram Bot 创建并配置
- [ ] 邮件通知配置完成（可选）

### 验证
- [ ] 运行 `验证自动化链路` 全部通过
- [ ] 测试手动触发一次 batch（5个Skills）
- [ ] 确认 Gumroad 产品自动创建

配置完成后，系统将在每天凌晨1点自动生成并发布 **5个Skills**，同时自动上架到 Gumroad 变现！
