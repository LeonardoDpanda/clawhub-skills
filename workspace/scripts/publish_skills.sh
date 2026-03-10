#!/bin/bash
# ClawHub Publish Skills Script

API_TOKEN="clh_1fCyGAxj2bNgAqc3UmhZZJ9z4F0dbHAAVFlyzIEOPaA"
CLAWHUB_BASE="https://clawhub.ai"
SKILLS_DIR="/workspace/projects/workspace/skills"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "🚀 ClawHub Batch Skills Publisher"
echo "=================================="
echo ""

# First verify API token works
echo -e "${BLUE}Verifying API Token...${NC}"
VERIFY_RESPONSE=$(curl -s -X GET "${CLAWHUB_BASE}/api/v1/skills?limit=1" \
    -H "Authorization: Bearer ${API_TOKEN}" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -w "\nHTTP_CODE:%{http_code}" \
    -L 2>/dev/null)

HTTP_CODE=$(echo "$VERIFY_RESPONSE" | tail -1 | grep -o 'HTTP_CODE:[0-9]*' | cut -d: -f2)

if [ "$HTTP_CODE" != "200" ]; then
    echo -e "${RED}❌ API Token verification failed (HTTP $HTTP_CODE)${NC}"
    exit 1
fi

echo -e "${GREEN}✅ API Token is valid!${NC}"
echo ""

# Define priority skills to publish first
PRIORITY_SKILLS=(
    "config-format-converter-pro"
    "batch-file-renamer-pro"
    "qr-code-tool-pro"
    "rest-api-tester-pro"
)

# Get all skill directories
ALL_SKILLS=($(find "$SKILLS_DIR" -name "SKILL.md" -type f | xargs -I {} dirname {} | xargs -I {} basename {}))

echo "📦 Found ${#ALL_SKILLS[@]} skills to publish"
echo "🎯 Priority skills: ${PRIORITY_SKILLS[@]}"
echo ""

# Create results directory
mkdir -p /workspace/projects/workspace/logs
RESULTS_FILE="/workspace/projects/workspace/logs/publish_results_$(date +%Y%m%d_%H%M%S).json"

echo "{" > "$RESULTS_FILE"
echo '  "publishDate": "'$(date -Iseconds)'",' >> "$RESULTS_FILE"
echo '  "totalAttempted": 0,' >> "$RESULTS_FILE"
echo '  "successful": [],' >> "$RESULTS_FILE"
echo '  "failed": []' >> "$RESULTS_FILE"
echo "}" >> "$RESULTS_FILE"

SUCCESS_COUNT=0
FAILED_COUNT=0
SUCCESS_LIST=""
FAILED_LIST=""

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
    
    # Read and escape SKILL.md content
    local skill_content=$(cat "$skill_file" | sed 's/"/\\"/g' | tr '\n' ' ' | sed 's/\\n/\\\\n/g')
    
    # Extract metadata from SKILL.md
    local display_name=$(grep -m1 "^# " "$skill_file" | sed 's/^# //' | head -1)
    local summary=$(grep -A5 "^## " "$skill_file" | grep -m1 "^-" | sed 's/^- //')
    
    if [ -z "$display_name" ]; then
        display_name="$skill_name"
    fi
    
    if [ -z "$summary" ]; then
        summary="Skill by OpenClaw"
    fi
    
    # Create JSON payload
    local payload=$(cat <<EOF
{
  "slug": "${skill_name}",
  "displayName": "${display_name}",
  "summary": "${summary}",
  "content": "${skill_content}",
  "version": "1.0.0",
  "visibility": "public"
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
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        SUCCESS_LIST="${SUCCESS_LIST}\n    - ${skill_name}"
        return 0
    elif [ "$http_code" == "409" ]; then
        echo -e "  ${YELLOW}⚠️ Skill already exists${NC}"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        SUCCESS_LIST="${SUCCESS_LIST}\n    - ${skill_name} (already exists)"
        return 0
    else
        echo -e "  ${RED}❌ Failed (HTTP $http_code)${NC}"
        echo "  Response: ${body:0:200}"
        FAILED_COUNT=$((FAILED_COUNT + 1))
        FAILED_LIST="${FAILED_LIST}\n    - ${skill_name} (HTTP $http_code)"
        return 1
    fi
}

# Publish priority skills first
echo "🎯 Publishing priority skills..."
echo ""
for skill in "${PRIORITY_SKILLS[@]}"; do
    skill_path="${SKILLS_DIR}/${skill}"
    if [ -d "$skill_path" ]; then
        publish_skill "$skill_path"
        sleep 2  # Rate limiting
    else
        echo -e "${YELLOW}⚠️ Priority skill not found: ${skill}${NC}"
    fi
done

echo ""
echo "📦 Publishing remaining skills..."
echo ""

# Publish remaining skills
for skill_path in "${ALL_SKILLS[@]}"; do
    skill_name=$(basename "$skill_path")
    
    # Skip if already published as priority
    if [[ " ${PRIORITY_SKILLS[@]} " =~ " ${skill_name} " ]]; then
        continue
    fi
    
    full_path="${SKILLS_DIR}/${skill_name}"
    if [ -d "$full_path" ]; then
        publish_skill "$full_path"
        sleep 2  # Rate limiting
    fi
done

echo ""
echo "=================================="
echo "📊 Publish Summary"
echo "=================================="
echo -e "${GREEN}✅ Successful: ${SUCCESS_COUNT}${NC}"
echo -e "${RED}❌ Failed: ${FAILED_COUNT}${NC}"
echo ""
echo "Successful Skills:"
echo -e "$SUCCESS_LIST"
echo ""
echo "Failed Skills:"
echo -e "$FAILED_LIST"
echo ""

# Update results file
cat > "$RESULTS_FILE" <<EOF
{
  "publishDate": "$(date -Iseconds)",
  "totalAttempted": $((SUCCESS_COUNT + FAILED_COUNT)),
  "successfulCount": $SUCCESS_COUNT,
  "failedCount": $FAILED_COUNT,
  "successful": [$(echo "$SUCCESS_LIST" | sed 's/^ *- /"/; s/$/",/' | tr -d '\n' | sed 's/,$//')],
  "failed": [$(echo "$FAILED_LIST" | sed 's/^ *- /"/; s/ (HTTP [0-9]*)"/",/' | tr -d '\n' | sed 's/,$//')]
}
EOF

echo "Results saved to: $RESULTS_FILE"
