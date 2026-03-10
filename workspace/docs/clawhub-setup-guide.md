# ClawHub CLI 配置指南

## 目标
配置ClawHub CLI，使其可以自动发布Skills到 https://clawhub.com

---

## 步骤1：获取ClawHub访问凭证

### 1.1 登录ClawHub
1. 打开 https://clawhub.com
2. 使用账号登录（或注册新账号）

### 1.2 获取API Token
**方法A：账号设置页**
1. 点击右上角头像 → Settings
2. 找到 "API Tokens" 或 "Developer" 标签
3. 点击 "Generate New Token"
4. 复制Token（格式类似：`ch_xxxxxxxxxxxxxxxx`）

**方法B：如果没有API Token选项**
1. 可能需要先创建Application
2. 在Developer Dashboard创建新应用
3. 获取Client ID和Client Secret

---

## 步骤2：配置OpenClaw连接ClawHub

### 方法A：通过openclaw CLI配置（推荐）

```bash
# 配置ClawHub连接
openclaw config set clawhub.token "YOUR_CLAWHUB_TOKEN"

# 验证配置
openclaw config get clawhub.token

# 测试连接
openclaw clawhub status
```

### 方法B：直接写入配置文件

配置文件路径：`~/.openclaw/config.yaml` 或工作区 `.openclaw/config.yaml`

```yaml
clawhub:
  token: "YOUR_CLAWHUB_TOKEN"
  endpoint: "https://api.clawhub.com/v1"
  username: "your_username"
```

---

## 步骤3：验证发布功能

### 测试单个Skill发布
```bash
# 发布一个Skill测试
cd /workspace/projects/workspace
openclaw clawhub publish skills/config-format-converter-pro/SKILL.md

# 或使用完整路径
clawhub publish /workspace/projects/workspace/skills/config-format-converter-pro/SKILL.md
```

### 预期输出
```
✓ Validating SKILL.md... OK
✓ Uploading to ClawHub... OK
✓ Published: https://clawhub.com/skills/config-format-converter
```

---

## 步骤4：批量发布现有Skills

### 需要发布的Skills列表（免费版）
已确认有付费版的4个：
1. config-format-converter
2. batch-file-renamer
3. qr-code-tool
4. rest-api-tester

待变现的31个Skills（需要发布免费版）

### 批量发布命令
```bash
# 发布所有Skills（我会帮你执行）
for skill in /workspace/projects/workspace/skills/*/; do
    openclaw clawhub publish "$skill/SKILL.md"
done
```

---

## 可能遇到的问题

### 问题1：提示"clawhub"命令不存在
**解决**：
```bash
# 检查openclaw是否安装
openclaw --version

# 如果未安装，需要先安装
npm install -g openclaw

# 或使用npx
npx openclaw clawhub publish ...
```

### 问题2：Token无效
**解决**：
- 检查Token是否复制完整
- 确认Token没有过期
- 重新生成Token

### 问题3：发布失败，提示格式错误
**解决**：
- 检查SKILL.md是否符合ClawHub格式要求
- 确保有 `name:` 和 `description:` 字段
- 确保技能名称唯一

---

## 配置完成后

一旦配置成功，我可以：
1. 自动批量发布所有35个Skills
2. 每日自动发布新生成的Skills
3. 自动更新已有Skills
4. 同步GitHub和ClawHub的内容

---

## 需要你提供的信息

请提供以下任一：
1. **API Token**（如果有）
2. **账号密码**（我可以帮你登录获取Token）
3. **截图**（如果你找不到Token选项，截图给我看看ClawHub的设置页面）

拿到Token后，我立即完成配置并批量发布！
