# 短剧选题交付智能体 - 使用指南

## 📋 功能概述

本智能体自动完成以下流程：

1. ✅ 生成3个女性向爆款短剧选题（剧名、人设、核心爽点、冲突、大纲）
2. ✅ 整理为清晰的Markdown格式并保存
3. ✅ 上传到云盘并生成分享链接（可选）
4. ✅ 通过消息渠道发送给买家（可选）
5. ✅ 记录完整的交付日志

## 🚀 快速开始

### 1. 直接运行（单次交付）

```bash
# 使用默认参数运行
bash scripts/run-drama-agent.sh

# 指定订单号和买家ID
bash scripts/run-drama-agent.sh --order-id=ORD_001 --buyer-id=BUYER_001
```

### 2. 通过 Node.js 直接运行

```bash
node scripts/drama-topic-agent.js --order-id=ORD_001 --buyer-id=BUYER_001
```

## ⚙️ 配置说明

### 环境变量配置

在运行前，可以通过环境变量配置各项功能：

```bash
# 输出目录
export DRAMA_OUTPUT_DIR="./deliverables"
export DRAMA_LOG_DIR="./logs"

# 云盘上传配置
export CLOUD_DRIVE_ENABLED="true"
export CLOUD_DRIVE_TYPE="aliyun"  # 可选: aliyun, baidu, quark
export CLOUD_UPLOAD_SCRIPT=""     # 自定义上传脚本路径
export CLOUD_TARGET_FOLDER="/短剧选题交付"

# 消息通知配置
export MESSAGING_ENABLED="true"
export MESSAGING_CHANNEL="xianyu"  # 可选: xianyu, telegram, email
```

### 配置文件方式

也可以创建 `.env` 文件：

```bash
cat > .env << 'EOF'
DRAMA_OUTPUT_DIR=./deliverables
DRAMA_LOG_DIR=./logs
CLOUD_DRIVE_ENABLED=true
CLOUD_DRIVE_TYPE=aliyun
MESSAGING_ENABLED=true
MESSAGING_CHANNEL=xianyu
EOF
```

然后加载环境变量：
```bash
source .env && bash scripts/run-drama-agent.sh
```

## 📦 云盘上传配置

### 阿里云盘

方案1：使用 aliyunpan CLI
```bash
# 安装 aliyunpan
# 参考: https://github.com/tickstep/aliyunpan

# 创建上传脚本 scripts/upload-aliyun.sh
#!/bin/bash
FILEPATH=$1
FILENAME=$2
aliyunpan upload "$FILEPATH" "/短剧选题交付/$FILENAME"
# 生成分享链接
aliyunpan share add "/短剧选题交付/$FILENAME"
```

方案2：使用 WebDAV
```bash
# 配置 rclone
rclone config

# 创建上传脚本
#!/bin/bash
FILEPATH=$1
FILENAME=$2
rclone copy "$FILEPATH" aliyundrive:/短剧选题交付/
echo "https://www.aliyundrive.com/s/xxxx"
```

### 百度云盘

使用 BaiduPCS-Go：
```bash
# 安装 BaiduPCS-Go
# 参考: https://github.com/qjfoidnh/BaiduPCS-Go

# 创建上传脚本
#!/bin/bash
FILEPATH=$1
FILENAME=$2
BaiduPCS-Go upload "$FILEPATH" "/短剧选题交付/"
```

## 💬 消息渠道配置

### 闲鱼消息（通过 OpenClaw）

需要配置 OpenClaw 的闲鱼渠道：

```bash
# 1. 查看当前渠道状态
openclaw status --deep

# 2. 配置闲鱼渠道（目前 OpenClaw 可能不直接支持闲鱼，需要通过其他方式）
```

**替代方案：** 使用 Telegram 或邮件通知

### Telegram 通知

1. 创建 Telegram Bot（通过 @BotFather）
2. 获取 Chat ID
3. 配置环境变量

```bash
export TELEGRAM_BOT_TOKEN="your_bot_token"
export TELEGRAM_CHAT_ID="your_chat_id"
```

### 邮件通知

```bash
export EMAIL_SMTP_HOST="smtp.example.com"
export EMAIL_SMTP_PORT="587"
export EMAIL_USER="your@email.com"
export EMAIL_PASS="your_password"
```

## 📁 输出文件结构

```
workspace/
├── deliverables/           # 交付文件目录
│   ├── 短剧选题_ORD_001_2025-02-27.md
│   └── 短剧选题_ORD_002_2025-02-27.md
├── logs/                   # 日志目录
│   └── delivery-log.jsonl  # 交付日志
└── scripts/
    ├── drama-topic-agent.js
    └── run-drama-agent.sh
```

## 📊 日志格式

日志文件 `logs/delivery-log.jsonl` 每行一个 JSON 对象：

```json
{
  "timestamp": "2025-02-27T10:30:00.000Z",
  "orderId": "ORD_ABC123",
  "buyerId": "BUYER_XYZ789",
  "filename": "短剧选题_ORD_ABC123_2025-02-27.md",
  "filepath": "./deliverables/短剧选题_ORD_ABC123_2025-02-27.md",
  "cloudUpload": {
    "success": true,
    "message": "上传成功",
    "link": "https://www.aliyundrive.com/s/xxxx"
  },
  "messageSent": {
    "success": true,
    "message": "消息已发送"
  },
  "status": "completed"
}
```

## 🔄 自动化触发方案

### 方案1：Cron 定时检查

```bash
# 编辑 crontab
crontab -e

# 每5分钟检查一次新订单
*/5 * * * * cd /workspace/projects/workspace && node scripts/check-orders.js
```

### 方案2：Webhook 接收订单

```bash
# 使用 OpenClaw 的 HTTP 触发器
# 配置一个 webhook 端点，接收闲鱼订单通知

# 创建 webhook 处理脚本 scripts/webhook-handler.js
```

### 方案3：手动触发 + 复制粘贴

最简单的方式：
1. 买家在闲鱼下单并发送订单号
2. 你手动运行脚本生成选题
3. 复制生成的内容或分享链接发送给买家

## 🎨 选题模板扩展

如需添加更多选题类型，编辑 `scripts/drama-topic-agent.js` 中的 `TOPIC_TEMPLATES`：

```javascript
const TOPIC_TEMPLATES = {
    modern: [ /* 现代题材 */ ],
    ancient: [ /* 古装题材 */ ],
    fantasy: [ /* 奇幻题材 */ ],
    // 添加新类别
    suspense: [ /* 悬疑题材 */ ],
    comedy: [ /* 喜剧题材 */ ],
};
```

## 🛠️ 故障排除

### 问题：无法保存文件

```bash
# 检查目录权限
mkdir -p deliverables logs
chmod 755 deliverables logs
```

### 问题：云盘上传失败

1. 检查云盘 CLI 工具是否正确安装
2. 检查是否已登录授权
3. 检查目标文件夹是否存在

### 问题：消息发送失败

1. 检查消息渠道是否已正确配置
2. 检查 API Token 是否有效
3. 查看日志文件获取详细错误信息

## 📞 联系方式

如有问题或定制需求，请通过以下方式联系：
- 邮箱：support@example.com
- Telegram：@your_bot

---

**当前版本**：v1.0  
**最后更新**：2025-02-27
