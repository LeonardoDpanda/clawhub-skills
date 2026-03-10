# 🔍 关键信息索引 (Knowledge Index)

> 快速定位重要信息的位置，避免重复搜索
> 最后更新: 2026-03-10

---

## 📁 核心文件索引

### 身份与配置
| 信息类型 | 文件路径 | 关键内容 |
|---------|---------|---------|
| 我的身份 | `SOUL.md` | 安全规则、行为准则 |
| 用户信息 | `USER.md` | 用户偏好、时区、称呼 |
| 工具配置 | `TOOLS.md` | 本地工具设置 |

### 记忆与状态
| 信息类型 | 文件路径 | 关键内容 |
|---------|---------|---------|
| 长期记忆 | `MEMORY.md` | 核心目标、决策权限、方法论 |
| 每日记录 | `memory/YYYY-MM-DD.md` | 当天事件 |
| 任务状态 | `memory/heartbeat-state.json` | 定时任务状态 |
| Skill台账 | `memory/skill-registry.json` | 35个Skills完整信息 |

### 密钥与账号 (敏感)
| 平台 | 文件路径 | 状态 |
|-----|---------|------|
| GitHub | `config/secrets/github.env` | ✅ 已配置 |
| Gumroad | `config/secrets/gumroad.env` | ✅ 已配置 |
| Reddit | `config/secrets/reddit-credentials.json` | ✅ 已配置 |
| ClawHub | `config/secrets/clawhub.env` | ✅ 已配置 |
| Email | `config/email.conf` | ✅ 已配置 |

### 策略与配置
| 配置项 | 文件路径 |
|-------|---------|
| 推广策略 | `config/preferences/deployment-strategy.json` |
| 系统状态 | `config/system-status.json` |

---

## 🎯 当前项目状态 (实时)

### Skill Auto-Publisher 项目
- **总Skills**: 35个
- **Gumroad上线**: 4个
- **ClawHub上线**: 1个 (ssl-certificate-checker)
- **待上线**: 30个
- **阶段**: 推广冲刺期 (暂停生成)

### 账号状态
| 平台 | 账号 | 状态 |
|-----|------|------|
| Reddit | u/Anxious-Software6827 | 待验证登录 |
| Gumroad | 9708247063907 | API连接受阻 |
| GitHub | LeonardoDpanda | ✅ 正常 |
| ClawHub | @LeonardoDpanda | ✅ 正常 |

---

## 📊 关键数据速查

### 定价策略
- 基础工具: $3-4
- 专业工具: $5-6  
- 高级/AI工具: $7-10
- 总收入潜力: $150+

### 推广目标
- Reddit: 3帖/天
- HackerNews: 1帖/天
- Dev.to: 1帖/天
- Resume条件: 访问量>100 或 首笔销售

---

## ⚠️ 已知问题

1. **Gumroad API**: 网络超时，无法自动创建产品
2. **ClawHub API**: 缺少文件上传端点，需手动发布
3. **Reddit 自动化**: 需要登录验证，待测试

---

## 📝 备忘快捷方式

### 用户偏好
- 叫我保持聊天界面简洁
- 后台执行任务，只汇报结果
- 支持完全自主决策 (L4.5权限)

### 决策红线
- ❌ 必须请示: 资金、账号绑定、法律合规
- ✅ 完全自主: 技术实现、供应商选择、定价策略

### 工作模式
- 主动推进，定期同步
- 异常立即报，日常不打扰
- 每日进展报告

---

## 🔗 快速命令

```bash
# 查看Skill台账
jq '.skills | length' memory/skill-registry.json

# 查看今日记录
ls -t memory/2026-03-*.md | head -1

# 检查任务状态
cat memory/heartbeat-state.json | jq '.lastCheckTime'
```

---

*此索引应在关键信息变更时更新*
