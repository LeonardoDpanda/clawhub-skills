#!/bin/bash
# 2小时推广监测脚本
# 用法: ./monitor-engagement.sh <reddit_post_url> <x_post_url>

REDDIT_URL="$1"
X_URL="$2"
LOG_FILE="/workspace/projects/workspace/memory/promotion-day1-metrics.json"
START_TIME=$(date +%s)

echo "🚀 推广监测已启动"
echo "开始时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Reddit: $REDDIT_URL"
echo "X: $X_URL"

# 初始化日志
if [ ! -f "$LOG_FILE" ]; then
cat > "$LOG_FILE" << 'EOF'
{
  "monitoring_start": "",
  "reddit_post": "",
  "x_post": "",
  "checkpoints": [],
  "total_duration_hours": 2
}
EOF
fi

# 更新开始信息
jq --arg time "$(date -Iseconds)" \
   --arg reddit "$REDDIT_URL" \
   --arg x "$X_URL" \
   '.monitoring_start = $time | .reddit_post = $reddit | .x_post = $x' \
   "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"

# 检查函数
check_engagement() {
    local elapsed=$(( $(date +%s) - START_TIME ))
    local elapsed_min=$(( elapsed / 60 ))
    
    echo ""
    echo "⏰ 检查点: +${elapsed_min}分钟"
    echo "请手动查看以下链接并记录数据:"
    echo ""
    echo "📱 Reddit: $REDDIT_URL"
    echo "   - 需要记录: Upvotes, Comments"
    echo ""
    echo "🐦 X: $X_URL"
    echo "   - 需要记录: Likes, Retweets, Replies"
    echo ""
    echo "💡 提示: 运行以下命令记录数据:"
    echo "   ./log-metrics.sh $elapsed_min <reddit_upvotes> <reddit_comments> <x_likes> <x_retweets> <x_replies>"
}

# 设置定时检查
echo ""
echo "📊 监测计划:"
echo "  - 30分钟后第一次检查"
echo "  - 60分钟后第二次检查"
echo "  - 120分钟后最终检查"
echo ""

# 后台运行监测
(sleep 1800 && check_engagement && echo "✅ 第一次检查完成") &
(sleep 3600 && check_engagement && echo "✅ 第二次检查完成") &
(sleep 7200 && check_engagement && echo "🏁 监测结束" && \
 jq --arg time "$(date -Iseconds)" '.completed_at = $time' "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${FILE}.tmp" "$LOG_FILE") &

echo "✅ 监测脚本已在后台运行"
echo "你可以关闭此终端，监测会继续在后台执行"
echo "日志文件: $LOG_FILE"
