# 🎯 Skill 全自动发布系统

基于 OpenClaw 的「Skill 生成 - 发布 - 台账管理」零手动干预自动化方案。

## ✨ 核心功能

- **⏰ 定时触发**: 每天凌晨1点（北京时间）自动执行
- **🤖 AI 生成**: 自主市场分析 + Skill 内容生成
- **📤 自动发布**: GitHub 同步 + ClawHub 上架
- **📊 云端台账**: OpenClaw Memory 自动记录
- **📱 多渠道通知**: WebChat + Telegram + Email

## 🚀 快速开始

### 1. 一键配置（按顺序执行）

```bash
# Step 1: GitHub 认证
gh auth login

# Step 2: ClawHub 认证
npm install -g clawhub
clawhub login

# Step 3: Telegram Bot（可选）
# 见 docs/AUTO_SKILL_SETUP.md 详细步骤

# Step 4: 添加定时任务
crontab -e
# 添加: 0 17 * * * /workspace/projects/workspace/scripts/daily-skill-generator.sh

# Step 5: 验证
/workspace/projects/workspace/scripts/auto-skill-pipeline.sh check
```

### 2. 手动触发

```bash
# 立即生成并发布一个 Skill
openclaw sessions spawn --task "生成并发布1个高价值Skill" --agent-id main
```

或直接发送指令:
- `立即生成并发布1个高价值Skill`
- `查询Skill台账`
- `验证自动化链路`

## 📁 项目结构

```
scripts/
├── auto-skill-pipeline.sh      # 主自动化脚本
├── daily-skill-generator.sh    # 定时任务入口
└── query-registry.sh           # 台账查询

skills/skill-auto-publisher/
└── SKILL.md                    # Skill 生成器

memory/
├── skill-registry.json         # 台账数据
└── skill-pipeline.log          # 执行日志

docs/
└── AUTO_SKILL_SETUP.md         # 详细配置指南
```

## 📋 台账字段

| 字段 | 说明 |
|-----|------|
| name | 技能名称（英文） |
| description | 功能简介 |
| marketRationale | 市场选择理由 |
| createdAt | 生成时间 |
| publishStatus | 发布状态 |
| githubPath | GitHub 文件路径 |
| clawhubUrl | ClawHub 页面链接 |

## 🔧 查询台账

```bash
# 查看统计
./scripts/query-registry.sh stats

# 查看最新
./scripts/query-registry.sh last

# 查看全部
./scripts/query-registry.sh list
```

## 📝 配置详情

详见 [docs/AUTO_SKILL_SETUP.md](./docs/AUTO_SKILL_SETUP.md)

---

**状态**: 系统已就绪，等待配置完成后自动运行 ✅
