---
name: skill-auto-publisher
description: Automated Skill generation and publishing pipeline for ClawHub platform. Use when the system needs to automatically generate new Skills based on market analysis, publish them to GitHub, submit to ClawHub, auto-publish to Gumroad for monetization, and update the Skill registry. This Skill encapsulates the complete workflow from market research to multi-platform publication and monetization.
---

# Skill Auto-Publisher

Complete automated pipeline for Skill generation, publishing, registry management, and multi-platform monetization.

## Workflow Overview

```
1. Market Analysis 
   ↓
2. Generate 5 Skills
   ↓
3. GitHub Push
   ↓
4. ClawHub Publish
   ↓
5. Gumroad Monetization (Auto)
   ↓
6. Registry Update
   ↓
7. Multi-Channel Notify
```

---

## Step 1: Market Analysis

Analyze current ClawHub marketplace to identify **5 distinct high-value opportunities**:
- High-demand categories with few offerings
- Emerging technology trends
- Practical utility gaps
- Avoid oversaturated areas (image generation, weather, basic web search)

**Analysis Prompt Template:**
```
Analyze the ClawHub Skill marketplace. Consider:
- Productivity & workflow automation
- Data processing & analysis (CSV, Excel, JSON)
- Developer tools & code quality
- Communication & collaboration
- Security & monitoring
- Content creation & media processing
- Business & finance tools
- Education & learning aids

Identify 5 high-value Skill opportunities that:
1. Each solves a different real problem
2. Have minimal competition on ClawHub
3. Can be implemented with available tools
4. Appeal to broad or niche user bases
5. Cover different categories (don't overlap)

Return for each:
- skill_name
- target_problem
- unique_value
- implementation_approach
- suggested_price_usd (2-10 range)
- category_tag
```

---

## Step 2: Skill Content Generation (Batch × 5)

Generate **5 complete SKILL.md files** following ClawHub specifications:

**Frontmatter Requirements:**
- `name`: lowercase, hyphens, <64 chars, verb-led
- `description`: Comprehensive triggering description including what and when

**Body Requirements:**
- Concise, practical instructions
- Code examples for common tasks
- Clear "When to Use / When NOT to Use" sections
- Progressive disclosure for complex features

**Quality Checklist (per Skill):**
- [ ] Name is action-oriented and memorable
- [ ] Description triggers appropriately
- [ ] Examples are copy-paste ready
- [ ] No filler content or marketing fluff
- [ ] Under 500 lines (use references/ for details)
- [ ] Pricing determined ($2-$10 range based on complexity)

**Batch Output Structure:**
```
skills_batch/
├── 01-{skill-name-1}_SKILL.md
├── 02-{skill-name-2}_SKILL.md
├── 03-{skill-name-3}_SKILL.md
├── 04-{skill-name-4}_SKILL.md
└── 05-{skill-name-5}_SKILL.md
```

---

## Step 3: GitHub Publication (Batch)

Push all 5 Skills to: `https://github.com/LeonardoDpanda/clawhub-skills`

**Naming Convention:**
- Files: `{skill-name}_SKILL.md`
- Commit message: `feat: add 5 new Skills - {date} batch`

**Commands:**
```bash
# Clone if not exists
git clone https://github.com/LeonardoDpanda/clawhub-skills.git /tmp/clawhub-skills

# Copy all 5 generated Skills
cp skills_batch/*_SKILL.md /tmp/clawhub-skills/

# Commit and push
cd /tmp/clawhub-skills
git add .
git commit -m "feat: add 5 new Skills - $(date +%Y-%m-%d) batch"
git push origin main
```

---

## Step 4: ClawHub Publication (Batch)

Publish all 5 Skills via ClawHub CLI:

```bash
# Login (if not already)
clawhub login

# Publish each Skill
for skill in skill-1 skill-2 skill-3 skill-4 skill-5; do
  clawhub publish ./clawhub-skills/${skill} \
    --slug ${skill} \
    --name "{Human Readable Name}" \
    --version 1.0.0 \
    --changelog "Initial release"
done
```

---

## Step 5: Gumroad Monetization (Auto-Publish)

**New: Automatic Gumroad product creation for each Skill**

### 5.1 Gumroad API Setup

**Prerequisites:**
- Gumroad account with Creator access
- Access Token from https://gumroad.com/settings/advanced

**Configuration:**
```bash
# Store token securely
echo "GUMROAD_ACCESS_TOKEN=your_token_here" > /workspace/projects/workspace/config/gumroad.env
chmod 600 /workspace/projects/workspace/config/gumroad.env
```

### 5.2 Auto-Create Products via API

**API Endpoint:** `POST https://api.gumroad.com/v2/products`

**Request per Skill:**
```bash
#!/bin/bash
source /workspace/projects/workspace/config/gumroad.env

# For each of the 5 Skills
curl -X POST "https://api.gumroad.com/v2/products" \
  -H "Authorization: Bearer $GUMROAD_ACCESS_TOKEN" \
  -d "product[name]={Skill Display Name}" \
  -d "product[description]={Skill description + ClawHub link}" \
  -d "product[price]={price}00" \
  -d "product[currency]=usd" \
  -d "product[is_physical]=false" \
  -d "product[tags][]=openclaw" \
  -d "product[tags][]=skill" \
  -d "product[tags][]=automation"
```

**Product Content (Auto-generated):**
- **Name**: `{Skill Name} - OpenClaw Skill`
- **Description**: 
  ```
  {Skill description}
  
  🔗 Get this Skill on ClawHub: {clawhubUrl}
  📦 Includes: Complete SKILL.md with examples
  🆘 Support: GitHub Issues or ClawHub community
  
  Perfect for: {target_audience}
  ```
- **Price**: $2-$10 (based on complexity)
- **File**: Link to GitHub raw file or packaged ZIP

### 5.3 Gumroad Product Structure

```json
{
  "gumroad_products": [
    {
      "skill_name": "{skill-name}",
      "gumroad_id": "abc123",
      "gumroad_url": "https://9708247063907.gumroad.com/l/{slug}",
      "price_usd": 5,
      "created_at": "2026-03-04T15:30:00Z"
    }
  ]
}
```

---

## Step 6: Registry Update

Update `/workspace/projects/workspace/memory/skill-registry.json` with all 5 Skills:

```json
{
  "batchRuns": [
    {
      "batchId": "batch-2026-03-04",
      "runDate": "2026-03-04",
      "skillsGenerated": 5,
      "skills": [
        {
          "name": "{skill-name}",
          "description": "{description}",
          "marketRationale": "{why chosen}",
          "category": "{category}",
          "priceUSD": 5,
          "createdAt": "2026-03-04 HH:MM",
          "publishStatus": "已发布",
          "githubPath": "https://github.com/LeonardoDpanda/clawhub-skills/blob/main/{skill-name}_SKILL.md",
          "clawhubUrl": "https://clawhub.com/skills/{skill-name}",
          "gumroadUrl": "https://9708247063907.gumroad.com/l/{slug}",
          "monetizationStatus": "已上线"
        }
      ]
    }
  ],
  "stats": {
    "totalGenerated": 25,
    "totalPublished": 25,
    "totalFailed": 0,
    "totalBatches": 5,
    "totalSKUs": 25,
    "totalRevenuePotential": "$100+/sale",
    "gumroadProducts": 25,
    "lastUpdated": "2026-03-04 HH:MM"
  }
}
```

---

## Step 7: Multi-Channel Notification

**Enhanced notification with batch summary:**

```
🎯 Skill 批量生成完成 - 第 {batchNumber} 批

📦 本次生成: 5 个 Skills
📊 累计生成: {totalGenerated} 个
💰 Gumroad上架: 5 个

┌─ 本次 Skills ─┐
│ 1. {name-1} - ${price}
│ 2. {name-2} - ${price}
│ 3. {name-3} - ${price}
│ 4. {name-4} - ${price}
│ 5. {name-5} - ${price}
└───────────────┘

🔗 GitHub: {githubRepo}
🌐 ClawHub: https://clawhub.com
💵 Gumroad: https://9708247063907.gumroad.com

⏰ 下次运行: 明天 01:00 (北京时间)
```

---

## Additional Monetization Platforms

### Primary (Auto-Integrated)
1. **Gumroad** ✅ - Automated via API

### Secondary (Manual / Future Integration)

| 平台 | 特点 | 适合类型 | 集成难度 |
|-----|------|---------|---------|
| **Lemon Squeezy** | 更好的开发者体验，自动税费处理 | 数字产品、软件 | 中 |
| **Paddle** | 企业级，订阅+一次性付款 | B2B、SaaS | 高 |
| **Ko-fi** | 简单，支持会员制 | 创作者、小额 | 低 |
| **Buy Me a Coffee** | 社交属性强 | 个人创作者 | 低 |
| **Product Hunt** | 流量大，适合发布 | 新产品发布 | 中 |
| **GitHub Sponsors** | 开源友好 | 开源项目 | 低 |

### 推荐扩展计划

**Phase 1 (当前)**: Gumroad 自动发布 ✅
**Phase 2**: 
- Lemon Squeezy 集成（更好的国际化支持）
- Ko-fi 会员层（提供 Skill 合集订阅）
**Phase 3**:
- Paddle（处理企业客户订阅）
- Product Hunt 自动发布（获取初始流量）

---

## Error Handling

**Per-Skill Error Tracking:**
```json
{
  "skill_name": "{name}",
  "status": "部分成功",
  "github": "✅ 成功",
  "clawhub": "✅ 成功",
  "gumroad": "❌ 失败 - API限制",
  "error": "Rate limited, retry in 1 hour"
}
```

**Recovery Strategies:**
1. **GitHub 失败**: 重试 fresh clone
2. **ClawHub 失败**: 标记"待手动发布"，继续其他
3. **Gumroad 失败**: 加入队列，下次 batch 优先重试
4. **部分成功**: 记录成功项，失败项单独重跑

---

## Manual Override Commands

| 指令 | 功能 |
|-----|------|
| `立即生成并发布5个高价值Skill` | 手动触发一次完整 batch |
| `查询Skill台账` | 显示 registry 统计和 batch 历史 |
| `验证自动化链路` | 测试 GitHub/ClawHub/Gumroad 连接 |
| `重试失败的Gumroad发布` | 仅重试 monetization 步骤 |

---

## Configuration Files

```
/workspace/projects/workspace/config/
├── telegram_bot.conf      # Telegram 通知
├── email.conf             # 邮件配置
├── gumroad.env            # Gumroad API Token (chmod 600)
└── monetization.json      # 平台优先级和定价策略
```

## Pricing Strategy (Auto)

**自动定价规则：**
```
基础价格 = $3
+ $1 (代码示例 > 3 个)
+ $1 (有外部 API 调用)
+ $1 (复杂配置需求)
+ $2 (企业/开发工具类)
+ $2 (独家功能，无竞品)

范围: $2 - $10
```
