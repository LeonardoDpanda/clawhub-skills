# HEARTBEAT.md - X推广系统定时任务

## 检查任务

每30分钟检查一次是否需要发布推文：

```bash
# 检查当前时间
HOUR=$(date +%H)
MINUTE=$(date +%M)

# 如果是 09:00, 14:00, 或 20:00，执行发布
if [[ "$HOUR" == "09" || "$HOUR" == "14" || "$HOUR" == "20" ]] && [[ "$MINUTE" == "00" ]]; then
    cd /workspace/projects/workspace/marketing && bash twitter-bot.sh
fi

# 每天23:00生成次日内容
if [[ "$HOUR" == "23" && "$MINUTE" == "00" ]]; then
    cd /workspace/projects/workspace/marketing && python3 generate_queue.py
fi
```

## 状态检查

- [ ] 检查API连接状态
- [ ] 检查今日推文是否已发布
- [ ] 检查内容队列是否充足
- [ ] 更新统计数据

## 执行命令

```bash
cd /workspace/projects/workspace/marketing

# 测试API
python3 test_api.py

# 如果需要发布，执行
bash twitter-bot.sh
```
