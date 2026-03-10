# Skill Auto-Publisher 核心任务文档

> 本文档是项目最高优先级参考，所有工作必须围绕此文档展开。
> 创建时间：2026-03-05
> 最后更新：2026-03-05

---

## 🎯 项目目标

建立一个**全自动化的 Skill 生成-发布-变现**流水线：

```
市场分析 → 生成 Skill → GitHub 推送 → ClawHub 发布 → Gumroad 变现 → 推广销售
```

**成功标准**：
- [x] 自动生成高质量 Skills
- [ ] Skills 成功推送到 GitHub
- [ ] Skills 成功发布到 ClawHub
- [ ] Skills 成功上架 Gumroad
- [ ] 实现被动收入

---

## 🔄 标准工作流程 (SOP)

### Phase 1: 批量生成 (Automated)
**触发条件**: 每天凌晨 01:00 或手动触发
**执行者**: AI Subagent
**输出**: 5 个完整 SKILL.md 文件

```
1. 市场分析 → 识别 5 个高价值机会
2. 生成内容 → 5 个 SKILL.md 文件
3. 本地保存 → skills/batch-{date}/
4. 记录台账 → memory/skill-registry.json
```

### Phase 2: GitHub 推送 (Requires Token)
**前置条件**: GITHUB_TOKEN 已配置
**执行者**: AI / 自动化脚本
**输出**: 代码推送到远程仓库

```
1. 克隆仓库 → git clone
2. 复制文件 → cp batch/* clawhub-skills/
3. 提交代码 → git commit
4. 推送远程 → git push
5. 更新台账 → 标记 "已推送"
```

### Phase 3: ClawHub 发布 (Requires GitHub)
**前置条件**: Phase 2 完成
**执行者**: AI / clawhub CLI
**输出**: Skills 在 ClawHub 上架

```
1. 登录 ClawHub → clawhub login
2. 遍历发布 → for each skill: clawhub publish
3. 记录 URL → 更新台账
4. 标记状态 → "已发布"
```

### Phase 4: Gumroad 变现 (Requires API/Token)
**前置条件**: GUMROAD_ACCESS_TOKEN 已配置
**执行者**: AI / API 调用
**输出**: 产品在 Gumroad 上架销售

```
1. 调用 API → POST /v2/products
2. 设置价格 → $2-$10
3. 生成描述 → 含 ClawHub 链接
4. 记录 URL → 更新台账
5. 标记状态 → "已上线"
```

### Phase 5: 推广销售 (Manual/Scheduled)
**前置条件**: Phase 4 完成
**执行者**: AI 生成内容 + 人工/自动化发布
**输出**: 社交媒体曝光

```
1. 生成推文 → X/Twitter 内容
2. 发布推广 → 含 Gumroad 链接
3. 跟踪数据 → 销售统计
```

---

## 📊 当前状态总览

### 历史已完成 (5 Skills)
| Skill | GitHub | ClawHub | Gumroad | 收入 |
|-------|--------|---------|---------|------|
| config-format-converter | ✅ | ✅ | ✅ $5 | 🟢 |
| batch-file-renamer | ✅ | ✅ | ✅ $3 | 🟢 |
| qr-code-tool | ✅ | ✅ | ✅ $4 | 🟢 |
| rest-api-tester | ✅ | ✅ | ✅ $5 | 🟢 |
| timestamp-converter | ✅ | ✅ | ⏳ $3 | 🟡 |

### 待处理积压 (10 Skills)
| 批次 | 状态 | Skills | 阻塞点 |
|------|------|--------|--------|
| batch-2026-03-05-1 | ✅ 已推送 | 5 个 | 待 ClawHub 发布 |
| batch-2026-03-05-2 | ✅ 已推送 | 5 个 | 待 ClawHub 发布 |

**总计**: 15 个 Skills 已生成, 15 个已推送到 GitHub, 待 ClawHub 发布和 Gumroad 变现

---

## 🔴 关键阻塞点 & 解决方案

### 阻塞 1: GitHub Token
- **影响**: Phase 2 无法进行, 所有后续步骤阻塞
- **状态**: ❌ 未配置
- **解决**: 用户生成 Personal Access Token
- **获取地址**: https://github.com/settings/tokens
- **所需权限**: `repo`

### 阻塞 2: Gumroad API 网络
- **影响**: Phase 4 无法自动化
- **状态**: ⚠️ 当前环境无法连接 api.gumroad.com
- **备选方案**:
  - A. 用户本地执行 curl 命令
  - B. 浏览器自动化（需安装扩展）
  - C. 手动在 Gumroad 后台创建

### 阻塞 3: X/Twitter 集成
- **影响**: Phase 5 未启动
- **状态**: 📝 待规划
- **优先级**: P2（先解决 P0/P1）

---

## ✅ 立即行动清单

### 优先级 P0 (阻塞所有进度)
- [ ] **获取 GitHub Token**
  - 用户访问 https://github.com/settings/tokens
  - 生成 Token (权限: repo)
  - 发送给 AI

### 优先级 P1 (完成后解锁变现)
- [ ] **推送 10 个 Skills 到 GitHub**
  - AI 使用 Token 执行推送
  - 完成后触发 ClawHub 发布

- [ ] **创建 10 个 Gumroad 产品**
  - 方案 A: 用户手动创建（AI 提供清单）
  - 方案 B: AI 浏览器自动化创建

### 优先级 P2 (优化和扩展)
- [ ] **配置 X/Twitter 推广**
- [ ] **设置定时自动化任务**
- [ ] **监控销售和反馈**

---

## 📝 对话规则

**当用户提问时, AI 必须:**
1. 先查看本文档确认当前状态
2. 识别当前阻塞点
3. 提供与主线任务相关的回答
4. 定期更新本文档状态

**避免:**
- 陷入子任务而忘记整体目标
- 重复讨论已确认的内容
- 在阻塞未解决时启动新功能

---

## 🔗 关键文件位置

| 文件 | 路径 | 用途 |
|------|------|------|
| 本文档 | `memory/SKILL_PUBLISHER_SOP.md` | 核心 SOP |
| Skill 台账 | `memory/skill-registry.json` | 所有 Skills 状态 |
| Gumroad Token | `config/gumroad.env` | API 认证 |
| GitHub Token | 待创建 | API 认证 |
| 生成文件 | `skills/batch-{date}/` | 本地 Skills |

---

## 📈 目标里程碑

| 阶段 | 目标 | 当前 |
|------|------|------|
| MVP | 5 Skills 完成全流程 | ✅ 80% (4/5) |
| V1 | 15 Skills 全部上线 | 🔄 33% (5/15) |
| V2 | 每日自动生成+发布 | ⏸️ 待配置 |
| V3 | 多平台变现 (Gumroad+X+PH) | ⏸️ 规划中 |

---

**记住: 当前最高优先级是获取 GitHub Token 并完成 10 个积压 Skills 的推送!**
