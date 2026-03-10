#!/bin/bash
# ClawHub Publish Skills Script v5 - With license

API_TOKEN="clh_1fCyGAxj2bNgAqc3UmhZZJ9z4F0dbHAAVFlyzIEOPaA"
CLAWHUB_BASE="https://clawhub.ai"
SKILLS_DIR="/workspace/projects/workspace/skills"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "🚀 ClawHub Batch Skills Publisher v5"
echo "====================================="
echo ""

# Function to calculate SHA256
get_sha256() {
    sha256sum "$1" | cut -d' ' -f1
}

# Function to get file size
get_size() {
    stat -c%s "$1"
}

# Function to publish a skill
publish_skill() {
    local skill_dir=$1
    local skill_name=$(basename "$skill_dir")
    local skill_file="${skill_dir}/SKILL.md"
    
    echo -e "${BLUE}Publishing: ${skill_name}${NC}"
    
    if [ ! -f "$skill_file" ]; then
        echo -e "  ${RED}❌ SKILL.md not found${NC}"
        return 1
    fi
    
    # Get file metadata
    local sha256=$(get_sha256 "$skill_file")
    local size=$(get_size "$skill_file")
    
    # Extract metadata from SKILL.md
    local display_name=$(grep -m1 "^# " "$skill_file" | sed 's/^# //' | head -1)
    local summary=$(grep -A10 "^## " "$skill_file" | grep "^- " | head -1 | sed 's/^- //')
    
    if [ -z "$display_name" ]; then
        display_name="$skill_name"
    fi
    
    if [ -z "$summary" ]; then
        summary="Skill for OpenClaw"
    fi
    
    # Create the JSON payload with license
    local payload=$(cat <<EOF
{
  "slug": "${skill_name}",
  "displayName": "${display_name}",
  "summary": "${summary}",
  "version": "1.0.0",
  "license": "MIT-0",
  "changelog": "Initial release",
  "files": [
    {
      "path": "SKILL.md",
      "sha256": "${sha256}",
      "size": ${size},
      "storageId": "${sha256}",
      "encoding": "utf-8"
    }
  ]
}
EOF
)
    
    # Try to publish
    local response=$(curl -s -X POST "${CLAWHUB_BASE}/api/v1/skills" \
        -H "Authorization: Bearer ${API_TOKEN}" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json" \
        -d "$payload" \
        -w "\nHTTP_CODE:%{http_code}" \
        -L 2>/dev/null)
    
    local http_code=$(echo "$response" | tail -1 | grep -o 'HTTP_CODE:[0-9]*' | cut -d: -f2)
    local body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" == "201" ] || [ "$http_code" == "200" ]; then
        echo -e "  ${GREEN}✅ Published successfully!${NC}"
        return 0
    elif [ "$http_code" == "409" ]; then
        echo -e "  ${YELLOW}⚠️ Skill already exists${NC}"
        return 0
    else
        echo -e "  ${RED}❌ Failed (HTTP $http_code)${NC}"
        echo "  Response: ${body:0:300}"
        return 1
    fi
}

# Test with one skill first
echo "🧪 Testing with one skill first..."
echo ""

TEST_SKILL="${SKILLS_DIR}/config-format-converter-pro"
if [ -d "$TEST_SKILL" ]; then
    publish_skill "$TEST_SKILL"
fi

echo ""
echo "If this succeeds, run for all skills..."
