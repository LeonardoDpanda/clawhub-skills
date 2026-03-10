#!/bin/bash
# ClawHub Publish Skills Script v2 - Correct API format

API_TOKEN="clh_1fCyGAxj2bNgAqc3UmhZZJ9z4F0dbHAAVFlyzIEOPaA"
CLAWHUB_BASE="https://clawhub.ai"
SKILLS_DIR="/workspace/projects/workspace/skills"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "🚀 ClawHub Batch Skills Publisher v2"
echo "===================================="
echo ""

# Create temp directory for payloads
mkdir -p /tmp/clawhub_publish

# Function to publish a skill using files format
publish_skill() {
    local skill_dir=$1
    local skill_name=$(basename "$skill_dir")
    local skill_file="${skill_dir}/SKILL.md"
    
    echo -e "${BLUE}Publishing: ${skill_name}${NC}"
    
    if [ ! -f "$skill_file" ]; then
        echo -e "  ${RED}❌ SKILL.md not found${NC}"
        return 1
    fi
    
    # Extract metadata from SKILL.md
    local display_name=$(grep -m1 "^# " "$skill_file" | sed 's/^# //' | head -1)
    local summary=$(grep -A10 "^## " "$skill_file" | grep "^- " | head -1 | sed 's/^- //')
    local description=$(grep -A20 "^## " "$skill_file" | grep -v "^## " | head -5 | tr '\n' ' ')
    
    if [ -z "$display_name" ]; then
        display_name="$skill_name"
    fi
    
    if [ -z "$summary" ]; then
        summary="Skill for OpenClaw"
    fi
    
    # Create multipart/form-data style payload using JSON with base64 files
    # First, base64 encode the SKILL.md content
    local skill_content_b64=$(base64 -w 0 "$skill_file")
    
    # Create the JSON payload with files array format
    local payload_file="/tmp/clawhub_publish/${skill_name}_payload.json"
    
    cat > "$payload_file" <<EOF
{
  "slug": "${skill_name}",
  "displayName": "${display_name}",
  "summary": "${summary}",
  "changelog": "Initial release",
  "files": [
    {
      "path": "SKILL.md",
      "content": "${skill_content_b64}",
      "encoding": "base64"
    }
  ]
}
EOF
    
    echo "  Payload created: $payload_file"
    
    # Try to publish
    local response=$(curl -s -X POST "${CLAWHUB_BASE}/api/v1/skills" \
        -H "Authorization: Bearer ${API_TOKEN}" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json" \
        -d "@${payload_file}" \
        -w "\nHTTP_CODE:%{http_code}" \
        -L 2>/dev/null)
    
    local http_code=$(echo "$response" | tail -1 | grep -o 'HTTP_CODE:[0-9]*' | cut -d: -f2)
    local body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" == "201" ] || [ "$http_code" == "200" ]; then
        echo -e "  ${GREEN}✅ Published successfully!${NC}"
        echo "  Response: ${body:0:100}"
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

# Get all skill directories
echo "📦 Scanning skills directory..."
SKILL_DIRS=($(find "$SKILLS_DIR" -maxdepth 1 -mindepth 1 -type d))

echo "Found ${#SKILL_DIRS[@]} skills"
echo ""

# Priority skills
PRIORITY_SKILLS=("config-format-converter-pro" "batch-file-renamer-pro" "qr-code-tool-pro" "rest-api-tester-pro")

SUCCESS_COUNT=0
FAILED_COUNT=0

# Publish priority skills first
echo "🎯 Publishing priority skills..."
echo ""
for priority in "${PRIORITY_SKILLS[@]}"; do
    for skill_dir in "${SKILL_DIRS[@]}"; do
        if [[ "$(basename "$skill_dir")" == "$priority" ]]; then
            if publish_skill "$skill_dir"; then
                SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
            else
                FAILED_COUNT=$((FAILED_COUNT + 1))
            fi
            sleep 1
            break
        fi
    done
done

echo ""
echo "📦 Publishing remaining skills..."
echo ""

# Publish remaining skills
for skill_dir in "${SKILL_DIRS[@]}"; do
    skill_name=$(basename "$skill_dir")
    
    # Skip priority skills
    if [[ " ${PRIORITY_SKILLS[@]} " =~ " ${skill_name} " ]]; then
        continue
    fi
    
    if publish_skill "$skill_dir"; then
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    else
        FAILED_COUNT=$((FAILED_COUNT + 1))
    fi
    sleep 1
done

echo ""
echo "===================================="
echo "📊 Publish Summary"
echo "===================================="
echo -e "${GREEN}✅ Successful: ${SUCCESS_COUNT}${NC}"
echo -e "${RED}❌ Failed: ${FAILED_COUNT}${NC}"
echo ""
