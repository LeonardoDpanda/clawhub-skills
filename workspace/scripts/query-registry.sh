#!/bin/bash
#
# Skill Registry Query Tool
# Usage: ./query-registry.sh [command]
#

WORKSPACE="/workspace/projects/workspace"
REGISTRY_FILE="$WORKSPACE/memory/skill-registry.json"

case "${1:-list}" in
    "list"|"all")
        echo "=== Skill 台账 ==="
        if [[ -f "$REGISTRY_FILE" ]]; then
            cat "$REGISTRY_FILE" | python3 -m json.tool 2>/dev/null || cat "$REGISTRY_FILE"
        else
            echo "台账文件不存在: $REGISTRY_FILE"
        fi
        ;;
    "stats"|"统计")
        echo "=== 发布统计 ==="
        if [[ -f "$REGISTRY_FILE" ]]; then
            python3 << 'PYEOF'
import json
import sys

try:
    with open('/workspace/projects/workspace/memory/skill-registry.json', 'r') as f:
        data = json.load(f)
    
    stats = data.get('stats', {})
    print(f"📊 总生成数: {stats.get('totalGenerated', 0)}")
    print(f"✅ 成功发布: {stats.get('totalPublished', 0)}")
    print(f"❌ 失败数: {stats.get('totalFailed', 0)}")
    print(f"🕐 最后更新: {stats.get('lastUpdated', 'N/A')}")
    print(f"📌 最后技能: {stats.get('lastSkillName', 'N/A')}")
    
    print("\n=== 已发布技能列表 ===")
    for skill in data.get('skills', []):
        status_icon = "✅" if skill.get('publishStatus') == '已发布' else "❌"
        print(f"{status_icon} {skill.get('name')} - {skill.get('createdAt')} - {skill.get('publishStatus')}")
        print(f"   {skill.get('description', 'N/A')[:60]}...")
        
except Exception as e:
    print(f"错误: {e}")
    sys.exit(1)
PYEOF
        else
            echo "台账文件不存在"
        fi
        ;;
    "last"|"最新")
        echo "=== 最新技能 ==="
        if [[ -f "$REGISTRY_FILE" ]]; then
            python3 << 'PYEOF'
import json

try:
    with open('/workspace/projects/workspace/memory/skill-registry.json', 'r') as f:
        data = json.load(f)
    
    skills = data.get('skills', [])
    if skills:
        last = skills[-1]
        print(f"📌 技能名称: {last.get('name')}")
        print(f"📝 功能简介: {last.get('description')}")
        print(f"📊 市场定位: {last.get('marketRationale')}")
        print(f"✅ 发布状态: {last.get('publishStatus')}")
        print(f"🔗 GitHub: {last.get('githubPath')}")
        print(f"🌐 ClawHub: {last.get('clawhubUrl')}")
        print(f"⏰ 生成时间: {last.get('createdAt')}")
    else:
        print("暂无技能记录")
except Exception as e:
    print(f"错误: {e}")
PYEOF
        fi
        ;;
    "help"|"-h"|"--help")
        cat << 'HELP'
Skill 台账查询工具

用法: ./query-registry.sh [命令]

命令:
  list, all      显示完整台账
  stats, 统计     显示统计信息
  last, 最新      显示最新技能
  help           显示帮助

示例:
  ./query-registry.sh list
  ./query-registry.sh stats
  ./query-registry.sh last
HELP
        ;;
    *)
        echo "未知命令: $1"
        echo "使用 './query-registry.sh help' 查看帮助"
        ;;
esac
