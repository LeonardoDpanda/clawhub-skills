#!/bin/bash
#
# X (Twitter) 自动化推广系统
# 每日定时执行脚本
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="/workspace/projects/workspace"
MARKETING_DIR="$WORKSPACE_DIR/marketing"
LOG_DIR="$MARKETING_DIR/logs"

# 创建日志目录
mkdir -p "$LOG_DIR"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_DIR/twitter-bot.log"
}

# X API 凭证
BEARER_TOKEN="AAAAAAAAAAAAAAAAAAAAADaa8AEAAAAA0P1MAna9qVQXqyWBxuvsl0LTEvA%3DJQDk7YM57qCCQlfdY1E0vjqIK4OkiAK86rQ4Rs9JLrRUTdPfKk"
API_KEY="zht8UIxLcSWiA8KIkFV9lqYYt"
API_SECRET="GBm0Xqj9yNiJl9DkIpMO9MmPYoDBISvEZaltgqzfoDDUEDwchh"

# 发布推文函数
post_tweet() {
    local text="$1"
    log "准备发布推文: ${text:0:50}..."
    
    # 使用 Python 脚本发布
    python3 "$MARKETING_DIR/post_tweet.py" "$text"
    
    if [ $? -eq 0 ]; then
        log "✅ 推文发布成功"
        return 0
    else
        log "❌ 推文发布失败"
        return 1
    fi
}

# 获取今日内容
get_today_content() {
    local date_str=$(date +%m-%d)
    local hour=$(date +%H)
    
    # 根据时间选择内容
    case $hour in
        09|9)
            echo "morning"
            ;;
        14)
            echo "afternoon"
            ;;
        20)
            echo "evening"
            ;;
        *)
            echo "none"
            ;;
    esac
}

# 主函数
main() {
    log "================================"
    log "🚀 X 自动化推广系统启动"
    log "================================"
    
    # 检查 API 连接
    log "检查 X API 连接..."
    if ! python3 "$MARKETING_DIR/test_api.py" > /dev/null 2>&1; then
        log "❌ API 连接失败，跳过本次执行"
        exit 1
    fi
    log "✅ API 连接正常"
    
    # 获取当前时间和内容类型
    local content_type=$(get_today_content)
    local today=$(date +%Y-%m-%d)
    
    if [ "$content_type" = "none" ]; then
        log "⏰ 非计划发布时间，跳过"
        exit 0
    fi
    
    log "内容类型: $content_type"
    
    # 从内容队列读取今日内容
    local tweet_file="$MARKETING_DIR/queue/${today}_${content_type}.txt"
    
    if [ ! -f "$tweet_file" ]; then
        log "⚠️ 今日内容文件不存在: $tweet_file"
        # 使用默认内容
        case $content_type in
            morning)
                tweet="🚀 新的一天，新的代码！分享一个今天让我省时间的工具。你用什么工具提升效率？ #DevTools #Productivity"
                ;;
            afternoon)
                tweet="💡 刚解决了一个烦人的问题。有时候最简单的工具反而最有效。你们的go-to工具是什么？ #Developer #CLI"
                ;;
            evening)
                tweet="📊 今日总结：自动化流程又帮我省了不少时间。把时间花在真正重要的事情上。 #Automation #Efficiency"
                ;;
        esac
    else
        tweet=$(cat "$tweet_file")
    fi
    
    # 发布推文
    post_tweet "$tweet"
    
    # 记录到统计
    echo "$(date +%s),$content_type,success" >> "$LOG_DIR/post_history.csv"
    
    log "✅ 本次执行完成"
}

# 执行主函数
main "$@"
