# 🎬 短剧选题交付智能体

全自动短剧选题生成与交付系统，专为闲鱼等平台的短剧选题服务设计。

## ✨ 功能特性

| 功能 | 状态 | 说明 |
|------|------|------|
| 智能选题生成 | ✅ | 基于2025爆款短剧趋势，生成3个女性向选题 |
| 专业文档输出 | ✅ | Markdown格式，包含人设、冲突、大纲、制作建议 |
| 云盘自动上传 | ⚙️ | 支持阿里云盘、百度云盘（需配置） |
| 消息自动发送 | ⚙️ | 支持Telegram、邮件、闲鱼（需配置渠道） |
| 订单日志记录 | ✅ | 完整的交付记录与追踪 |
| 批量订单处理 | ✅ | 支持队列批量处理 |

## 🚀 快速开始

### 1. 单次生成测试

```bash
bash scripts/run-drama-agent.sh
```

### 2. 生成示例文档

运行后会生成类似这样的文档：

```markdown
## 选题1：《契约娇妻太撩人》

### 人设设定
- **女主**：单纯善良、有隐藏马甲
- **男主**：护妻狂魔、只对女主温柔
- **助攻**：毒舌助理、可爱萌宝

### 核心冲突
> 契约到期危机

### 核心爽点
> 身份揭晓震惊众人

### 分集大纲
第一集：开场引爆 - 女主遭遇重大打击/危机...
...
第十集：彩蛋/第二季预告 - 埋下新伏笔
```

## 📁 项目结构

```
workspace/
├── scripts/
│   ├── drama-topic-agent.js      # 主智能体脚本
│   ├── run-drama-agent.sh        # 快速启动脚本
│   ├── order-listener.js         # 订单监听处理器
│   └── upload-to-aliyun.sh       # 阿里云盘上传脚本
├── deliverables/                 # 交付文件目录
│   └── 短剧选题_ORD_xxx_日期.md
├── logs/
│   └── delivery-log.jsonl        # 交付日志
├── orders/
│   ├── queue.jsonl               # 订单队列
│   └── processed.json            # 已处理订单
├── docs/
│   └── DRAMA_AGENT_GUIDE.md      # 详细使用指南
├── .env.example                  # 环境变量示例
└── README.md                     # 本文件
```

## ⚙️ 配置方法

### 基础配置

```bash
# 复制配置文件
cp .env.example .env

# 编辑配置
nano .env

# 加载并运行
source .env && bash scripts/run-drama-agent.sh
```

### 云盘上传配置

**阿里云盘（推荐）：**

```bash
# 1. 安装 aliyunpan CLI
curl -sL https://github.com/tickstep/aliyunpan/releases/latest/download/aliyunpan-linux-amd64.zip -o aliyunpan.zip
unzip aliyunpan.zip && chmod +x aliyunpan && sudo mv aliyunpan /usr/local/bin/

# 2. 登录
aliyunpan login

# 3. 启用上传
export CLOUD_DRIVE_ENABLED=true
export CLOUD_UPLOAD_SCRIPT=./scripts/upload-to-aliyun.sh
```

### 消息通知配置

**Telegram：**

```bash
export MESSAGING_ENABLED=true
export MESSAGING_CHANNEL=telegram
export TELEGRAM_BOT_TOKEN=your_bot_token
export TELEGRAM_CHAT_ID=your_chat_id
```

## 📋 选题模板类型

当前支持生成的选题类型：

| 类型 | 主题 | 示例剧名 |
|------|------|---------|
| 现代都市 | 职场逆袭 | 《总监，请指教》 |
| 现代都市 | 婚姻复仇 | 《离婚后我暴富了》 |
| 现代都市 | 甜宠恋爱 | 《契约娇妻太撩人》 |
| 现代都市 | 重生复仇 | 《重生后，我成了首富》 |
| 古装穿越 | 穿越逆袭 | 《农门娇妻有点甜》 |
| 古装宫斗 | 宫斗权谋 | 《本宫不死，尔等终究是妃》 |
| 奇幻修仙 | 修仙逆袭 | 《被挖灵根后，我飞升了》 |

## 🔄 自动化方案

### 方案1：手动触发（简单）

买家下单后，手动运行：
```bash
bash scripts/run-drama-agent.sh --order-id=ORDER_001 --buyer-id=BUYER_001
```

### 方案2：定时批量处理

```bash
# 添加测试订单
node scripts/order-listener.js --mock

# 处理所有待处理订单
node scripts/order-listener.js --process-once

# 或设置 cron 定时任务
crontab -e
*/5 * * * * cd /workspace/projects/workspace && source .env && node scripts/order-listener.js --process-once >> logs/cron.log 2>&1
```

### 方案3：持续监听

```bash
# 后台持续监听新订单
nohup bash -c 'source .env && node scripts/order-listener.js' > logs/listener.log 2>&1 &
```

## 📊 日志查询

```bash
# 查看交付日志
cat logs/delivery-log.jsonl | jq .

# 统计交付数量
cat logs/delivery-log.jsonl | wc -l

# 查找特定订单
cat logs/delivery-log.jsonl | jq 'select(.orderId=="ORD_xxx")'
```

## 🛠️ 扩展开发

### 添加新选题类型

编辑 `scripts/drama-topic-agent.js`，在 `TOPIC_TEMPLATES` 中添加：

```javascript
suspense: [
    {
        theme: '悬疑探案',
        titles: ['《女法医她来了》', '《心理罪，她最懂》'],
        // ...
    }
]
```

### 自定义输出格式

修改 `topicsToMarkdown()` 函数，调整文档模板。

## 📞 技术支持

如有问题：
1. 查看详细文档：`docs/DRAMA_AGENT_GUIDE.md`
2. 检查日志：`logs/delivery-log.jsonl`
3. 测试运行：`bash scripts/run-drama-agent.sh`

## 📝 License

MIT License - 可自由使用和修改

---

**当前版本**: v1.0  
**最后更新**: 2025-02-27
