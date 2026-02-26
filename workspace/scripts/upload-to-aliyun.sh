#!/bin/bash
# 阿里云盘上传脚本
# 使用方法: bash scripts/upload-to-aliyun.sh <文件路径> <文件名>

FILEPATH=$1
FILENAME=$2
TARGET_FOLDER="/短剧选题交付"

if [ -z "$FILEPATH" ] || [ -z "$FILENAME" ]; then
    echo "用法: $0 <文件路径> <文件名>" >&2
    exit 1
fi

if [ ! -f "$FILEPATH" ]; then
    echo "错误: 文件不存在: $FILEPATH" >&2
    exit 1
fi

# 检查 aliyunpan 是否安装
if ! command -v aliyunpan &> /dev/null; then
    echo "错误: aliyunpan 未安装" >&2
    echo "请先安装: https://github.com/tickstep/aliyunpan" >&2
    exit 1
fi

# 确保目标文件夹存在
echo "📁 检查目标文件夹..."
aliyunpan mkdir "$TARGET_FOLDER" 2>/dev/null || true

# 上传文件
echo "☁️  正在上传: $FILENAME"
if aliyunpan upload "$FILEPATH" "$TARGET_FOLDER/$FILENAME"; then
    echo "✅ 上传成功"
    
    # 创建分享链接
    echo "🔗 创建分享链接..."
    SHARE_RESULT=$(aliyunpan share add "$TARGET_FOLDER/$FILENAME" 2>&1)
    
    # 提取分享链接
    SHARE_URL=$(echo "$SHARE_RESULT" | grep -oE 'https?://[^[:space:]]+' | head -1)
    
    if [ -n "$SHARE_URL" ]; then
        echo "$SHARE_URL"
        exit 0
    else
        echo "⚠️  分享链接创建失败，请手动创建" >&2
        exit 1
    fi
else
    echo "❌ 上传失败" >&2
    exit 1
fi
