#!/bin/bash
# 短剧选题交付智能体 - 快速启动脚本

# 设置环境变量
export DRAMA_OUTPUT_DIR="${DRAMA_OUTPUT_DIR:-./deliverables}"
export DRAMA_LOG_DIR="${DRAMA_LOG_DIR:-./logs}"

# 解析参数
ORDER_ID=""
BUYER_ID=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --order-id=*)
            ORDER_ID="${1#*=}"
            shift
            ;;
        --buyer-id=*)
            BUYER_ID="${1#*=}"
            shift
            ;;
        *)
            echo "未知参数: $1"
            exit 1
            ;;
    esac
done

# 如果没有提供参数，使用默认值
if [ -z "$ORDER_ID" ]; then
    ORDER_ID="ORD_$(date +%s)"
fi

if [ -z "$BUYER_ID" ]; then
    BUYER_ID="BUYER_$(date +%s)"
fi

echo "========================================"
echo "   启动短剧选题交付智能体"
echo "========================================"
echo "订单编号: $ORDER_ID"
echo "买家编号: $BUYER_ID"
echo "========================================"
echo ""

# 运行智能体
node scripts/drama-topic-agent.js --order-id="$ORDER_ID" --buyer-id="$BUYER_ID"
