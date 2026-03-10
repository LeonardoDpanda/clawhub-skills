# GitHub Actions 配置指南

本目录包含用于自动化发布的 GitHub Actions 工作流。

## 🚀 已配置工作流

### 1. ClawHub 批量发布
- **文件**: `clawhub-batch-publish.yml`
- **触发**: 每天凌晨2点 UTC，或手动触发
- **功能**: 自动发布所有待发布的 Skills 到 ClawHub

### 2. Gumroad 批量创建
- **文件**: `gumroad-batch-create.yml`
- **触发**: 每天凌晨3点 UTC，或手动触发
- **功能**: 批量创建 Gumroad 产品页面

### 3. Reddit 自动发帖
- **文件**: `reddit-auto-post.yml`
- **触发**: 每天下午1点 UTC（美国早上），或手动触发
- **功能**: 自动在指定 subreddit 发布推广帖

---

## 🔐 必需 Secrets 配置

在 GitHub 仓库设置中添加以下 Secrets：

### ClawHub 配置
| Secret Name | 值 | 获取方式 |
|------------|-----|---------|
| `CLAWHUB_API_TOKEN` | API Token | https://clawhub.ai → Account → API Keys |
| `CLAWHUB_EMAIL` | 登录邮箱 | 你的 ClawHub 账号 |
| `CLAWHUB_PASSWORD` | 登录密码 | 你的 ClawHub 密码 |

### Gumroad 配置
| Secret Name | 值 | 获取方式 |
|------------|-----|---------|
| `GUMROAD_ACCESS_TOKEN` | Access Token | https://app.gumroad.com/settings → Advanced → Generate Token |

### Reddit 配置
| Secret Name | 值 | 获取方式 |
|------------|-----|---------|
| `REDDIT_USERNAME` | 用户名 | 你的 Reddit 账号 |
| `REDDIT_PASSWORD` | 密码 | 你的 Reddit 密码 |
| `REDDIT_CLIENT_ID` | App ID | https://www.reddit.com/prefs/apps → Create App |
| `REDDIT_CLIENT_SECRET` | App Secret | 同上 |

### GitHub 配置
| Secret Name | 值 | 获取方式 |
|------------|-----|---------|
| `GH_PAT` | Personal Access Token | https://github.com/settings/tokens → Generate with `repo` scope |

---

## 📋 配置步骤

### 步骤1：获取 Reddit API 凭证

1. 访问 https://www.reddit.com/prefs/apps
2. 点击 "Create App" 或 "Create Another App"
3. 选择 "script" 类型
4. 填写名称和描述
5. Redirect URI 填 `http://localhost:8080`
6. 创建后记录：
   - Client ID（在 App 名称下面的一串字符）
   - Secret（点击 "edit" 后显示的 secret）

### 步骤2：获取 Gumroad Access Token

1. 访问 https://app.gumroad.com/settings
2. 找到 "Advanced" 部分
3. 点击 "Generate Access Token"
4. 复制生成的 token

### 步骤3：获取 ClawHub API Token

1. 访问 https://clawhub.ai
2. 登录后进入 Account Settings
3. 找到 API Keys 部分
4. 生成新的 API Token
5. **重要**: 首次使用需先接受 MIT-0 license

### 步骤4：在 GitHub 添加 Secrets

1. 访问仓库页面：`https://github.com/LeonardoDpanda/clawhub-skills`
2. 点击 Settings → Secrets and variables → Actions
3. 点击 "New repository secret"
4. 逐个添加上面表格中的所有 secrets

---

## ▶️ 手动触发工作流

配置完成后，可以手动测试：

1. 访问仓库页面
2. 点击 Actions 标签
3. 选择要运行的工作流（如 "Batch Publish to ClawHub"）
4. 点击 "Run workflow"
5. 选择分支（main），可选设置参数
6. 点击绿色 "Run workflow" 按钮

---

## 📊 查看执行结果

工作流运行后：

1. 在 Actions 页面查看运行状态
2. 点击具体运行记录查看详细日志
3. 成功/失败都会有明确的输出信息
4. 生成的日志和截图会自动上传到 Artifacts

---

## ⚠️ 注意事项

1. **Reddit 防 spam**: 不要过于频繁发帖，建议每天1-3帖
2. **Gumroad 速率限制**: 批量创建时注意间隔，避免触发限制
3. **ClawHub License**: 首次发布前必须先手动接受 MIT-0 license
4. **Secrets 安全**: 所有敏感信息都存储在 GitHub Secrets 中，不会暴露在代码里

---

## 🆘 故障排除

### 工作流运行失败

1. 检查 Secrets 是否都正确配置
2. 查看 Actions 日志获取具体错误信息
3. 确认 API Token 没有过期

### Reddit 发帖失败

- 检查账号是否被 shadowban
- 确认 subreddit 允许新账号发帖
- 检查是否触发 rate limit

### Gumroad 创建失败

- 确认 Access Token 有正确的权限
- 检查产品名称是否重复
- 查看 Gumroad 账户状态

---

完成配置后，系统将 **全自动运行**，无需手动干预！
