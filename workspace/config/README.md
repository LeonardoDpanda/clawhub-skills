# 账号与权限配置管理

## 🔐 安全存储原则

1. **本地存储**: 所有密钥只保存在本地工作区，不上传
2. **分级加密**: 敏感信息单独文件，非敏感信息可公开
3. **备份机制**: 定期备份配置，避免丢失
4. **访问控制**: 仅限必要工具访问对应密钥

---

## 📁 配置文件结构

```
config/
├── secrets/          # 敏感信息（绝不提交到git）
│   ├── github-credentials.json
│   ├── gumroad-api.json
│   ├── reddit-credentials.json
│   └── twitter-api.json
├── preferences/      # 策略偏好（可同步）
│   ├── deployment-strategy.json
│   ├── content-guidelines.json
│   └── risk-tolerance.json
└── platforms/        # 平台配置（非敏感）
    ├── github-repos.json
    ├── gumroad-products.json
    └── posting-schedules.json
```

---

## 🚫 .gitignore 保护

确保 secrets/ 目录不会被意外提交：

```
config/secrets/
*.key
*.secret
.env.local
```

---

## 📝 配置模板

### GitHub 配置模板
```json
{
  "platform": "github",
  "account_type": "personal|bot",
  "username": "string",
  "access_token": "string",
  "repositories": [
    {
      "name": "clawhub-skills",
      "permissions": ["read", "write", "admin"],
      "default_branch": "main"
    }
  ],
  "rate_limits": {
    "requests_per_hour": 5000
  }
}
```

### Gumroad 配置模板
```json
{
  "platform": "gumroad",
  "account_email": "string",
  "api_key": "string",
  "permissions": ["read", "write"],
  "products": [
    {
      "id": "string",
      "name": "string",
      "url": "string"
    }
  ]
}
```

### Reddit 配置模板
```json
{
  "platform": "reddit",
  "account_type": "dedicated_marketing",
  "username": "string",
  "password": "string",
  "app_id": "string",
  "app_secret": "string",
  "refresh_token": "string",
  "subreddits": ["webdev", "sysadmin", "programming"],
  "posting_limits": {
    "posts_per_day": 3,
    "comments_per_hour": 10
  }
}
```

---

## 🔄 同步检查清单

当用户说"之前同步过"时，检查以下位置：

- [ ] `config/secrets/github-credentials.json`
- [ ] `config/secrets/gumroad-api.json`
- [ ] Git 全局配置: `git config --global user.name/email`
- [ ] SSH keys: `~/.ssh/`
- [ ] OpenClaw 配置: `openclaw config list`

---

## ⚠️ 安全提醒

1. **绝不**在代码中硬编码密钥
2. **绝不**在日志中打印完整密钥
3. **定期**轮换 API Key
4. **监控**异常访问模式
