#!/bin/bash
# Batch publish Skills to ClawHub API

API_ENDPOINT="https://clawhub.ai/api/v1/skills"
API_TOKEN="clh_1fCyGAxj2bNgAqc3UmhZZJ9z4F0dbHAAVFlyzIEOPaA"
WORKSPACE_DIR="/workspace/projects/workspace"
RESULTS_FILE="$WORKSPACE_DIR/memory/publish-results-$(date +%Y%m%d-%H%M%S).json"

# Initialize results array
echo '{"published":[],"failed":[],"existing":[],"timestamp":"'$(date -Iseconds)'"}' > "$RESULTS_FILE"

# Function to extract skill name from file path or directory
get_skill_name() {
    local filepath="$1"
    local skill_name
    
    # Try to extract from SKILL.md first line if it contains name
    if [ -f "$filepath" ]; then
        skill_name=$(head -5 "$filepath" | grep -i "^# " | head -1 | sed 's/^# //' | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g' | tr -cd 'a-z0-9-')
    fi
    
    # If not found, derive from directory or filename
    if [ -z "$skill_name" ]; then
        skill_name=$(basename "$filepath" | sed 's/_SKILL.md$//' | sed 's/-pro$//' | tr '[:upper:]' '[:lower:]')
    fi
    
    echo "$skill_name"
}

# Function to publish a skill
publish_skill() {
    local filepath="$1"
    local skill_name="$2"
    
    echo "Publishing: $skill_name"
    
    # Base64 encode the content
    local content_b64
    content_b64=$(base64 -w 0 "$filepath")
    
    # Prepare JSON payload
    local payload
    payload=$(cat <<EOF
{
    "name": "$skill_name",
    "content": "$content_b64",
    "source": "github",
    "visibility": "public"
}
EOF
)
    
    # Call API
    local response
    local http_code
    response=$(curl -s -w "\n%{http_code}" -X POST "$API_ENDPOINT" \
        -H "Authorization: Bearer $API_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$payload" 2>&1)
    
    http_code=$(echo "$response" | tail -1)
    body=$(echo "$response" | sed '$d')
    
    echo "  HTTP Code: $http_code"
    
    case "$http_code" in
        200|201)
            echo "  ✓ Published successfully"
            echo "{\"name\":\"$skill_name\",\"status\":\"success\",\"code\":$http_code}" 
            ;;
        409)
            echo "  ⚠ Already exists"
            echo "{\"name\":\"$skill_name\",\"status\":\"existing\",\"code\":$http_code}" 
            ;;
        401)
            echo "  ✗ Authentication failed (401)"
            echo "{\"name\":\"$skill_name\",\"status\":\"failed\",\"code\":$http_code,\"error\":\"Unauthorized\"}" 
            ;;
        403)
            echo "  ✗ Permission denied (403)"
            echo "{\"name\":\"$skill_name\",\"status\":\"failed\",\"code\":$http_code,\"error\":\"Forbidden\"}" 
            ;;
        *)
            echo "  ✗ Failed ($http_code): $body"
            echo "{\"name\":\"$skill_name\",\"status\":\"failed\",\"code\":$http_code,\"error\":\"$body\"}" 
            ;;
    esac
}

# Find all SKILL.md files and publish them
echo "Starting batch publish of Skills to ClawHub..."
echo "API Endpoint: $API_ENDPOINT"
echo ""

# Define skills to publish with their correct names
declare -A SKILL_FILES

# Core 9 skills (pro versions with local directories)
SKILL_FILES["config-format-converter"]="$WORKSPACE_DIR/skills/config-format-converter-pro/SKILL.md"
SKILL_FILES["batch-file-renamer"]="$WORKSPACE_DIR/skills/batch-file-renamer-pro/SKILL.md"
SKILL_FILES["qr-code-tool"]="$WORKSPACE_DIR/skills/qr-code-tool-pro/SKILL.md"
SKILL_FILES["rest-api-tester"]="$WORKSPACE_DIR/skills/rest-api-tester-pro/SKILL.md"
SKILL_FILES["ssl-certificate-checker"]="$WORKSPACE_DIR/skills/ssl-certificate-checker-pro/SKILL.md"
SKILL_FILES["http-headers-analyzer"]="$WORKSPACE_DIR/skills/http-headers-analyzer-pro/SKILL.md"
SKILL_FILES["cron-expression-parser"]="$WORKSPACE_DIR/skills/cron-expression-parser-pro/SKILL.md"
SKILL_FILES["docker-compose-validator"]="$WORKSPACE_DIR/skills/docker-compose-validator-pro/SKILL.md"
SKILL_FILES["json-path-query"]="$WORKSPACE_DIR/skills/json-path-query-pro/SKILL.md"

# Additional skills from batch-2026-03-05-1
SKILL_FILES["password-generator"]="$WORKSPACE_DIR/skills/batch-2026-03-05-1/01-password-generator_SKILL.md"
SKILL_FILES["csv-processor"]="$WORKSPACE_DIR/skills/batch-2026-03-05-1/02-csv-processor_SKILL.md"
SKILL_FILES["markdown-formatter"]="$WORKSPACE_DIR/skills/batch-2026-03-05-1/03-markdown-formatter_SKILL.md"
SKILL_FILES["system-health-check"]="$WORKSPACE_DIR/skills/batch-2026-03-05-1/04-system-health-check_SKILL.md"
SKILL_FILES["url-encoder"]="$WORKSPACE_DIR/skills/batch-2026-03-05-1/05-url-encoder_SKILL.md"

# Additional skills from batch-2026-03-05-2
SKILL_FILES["csv-data-analyzer"]="$WORKSPACE_DIR/skills/batch-2026-03-05-2/csv-data-analyzer_SKILL.md"
SKILL_FILES["text-diff-comparator"]="$WORKSPACE_DIR/skills/batch-2026-03-05-2/text-diff-comparator_SKILL.md"
SKILL_FILES["json-schema-validator"]="$WORKSPACE_DIR/skills/batch-2026-03-05-2/json-schema-validator_SKILL.md"
SKILL_FILES["url-shortener-expander"]="$WORKSPACE_DIR/skills/batch-2026-03-05-2/url-shortener-expander_SKILL.md"

# Additional skills from batch-2026-03-09
SKILL_FILES["regex-tester"]="$WORKSPACE_DIR/skills/batch-2026-03-09/01-regex-tester_SKILL.md"
SKILL_FILES["color-code-converter"]="$WORKSPACE_DIR/skills/batch-2026-03-09/02-color-code-converter_SKILL.md"
SKILL_FILES["base64-toolkit"]="$WORKSPACE_DIR/skills/batch-2026-03-09/03-base64-toolkit_SKILL.md"
SKILL_FILES["jwt-token-inspector"]="$WORKSPACE_DIR/skills/batch-2026-03-09/04-jwt-token-inspector_SKILL.md"
SKILL_FILES["sql-formatter"]="$WORKSPACE_DIR/skills/batch-2026-03-09/05-sql-formatter_SKILL.md"

# Additional skills from root
SKILL_FILES["meeting-summarizer"]="$WORKSPACE_DIR/skills/01-meeting-summarizer_SKILL.md"
SKILL_FILES["data-format-converter"]="$WORKSPACE_DIR/skills/02-data-format-converter_SKILL.md"
SKILL_FILES["website-monitor"]="$WORKSPACE_DIR/skills/03-website-monitor_SKILL.md"
SKILL_FILES["website-monitor-alt"]="$WORKSPACE_DIR/skills/04-batch-file-renamer_SKILL.md"
SKILL_FILES["rest-api-tester-alt"]="$WORKSPACE_DIR/skills/05-rest-api-tester_SKILL.md"

# Additional pro skills
SKILL_FILES["image-reader"]="$WORKSPACE_DIR/skills/image-reader/SKILL.md"
SKILL_FILES["coze-image-gen"]="$WORKSPACE_DIR/skills/coze-image-gen/SKILL.md"
SKILL_FILES["coze-voice-gen"]="$WORKSPACE_DIR/skills/coze-voice-gen/SKILL.md"
SKILL_FILES["coze-web-search"]="$WORKSPACE_DIR/skills/coze-web-search/SKILL.md"
SKILL_FILES["skill-auto-publisher"]="$WORKSPACE_DIR/skills/skill-auto-publisher/SKILL.md"
SKILL_FILES["youtube-title-optimizer"]="$WORKSPACE_DIR/skills/youtube-title-optimizer/SKILL.md"

# Results arrays
SUCCESS_LIST=()
FAILED_LIST=()
EXISTING_LIST=()

# Publish each skill
for skill_name in "${!SKILL_FILES[@]}"; do
    filepath="${SKILL_FILES[$skill_name]}"
    
    if [ ! -f "$filepath" ]; then
        echo "⚠ File not found: $filepath"
        FAILED_LIST+=("{\"name\":\"$skill_name\",\"error\":\"File not found\"}")
        continue
    fi
    
    result=$(publish_skill "$filepath" "$skill_name")
    status=$(echo "$result" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
    
    case "$status" in
        success)
            SUCCESS_LIST+=("$result")
            ;;
        existing)
            EXISTING_LIST+=("$result")
            ;;
        failed)
            FAILED_LIST+=("$result")
            ;;
    esac
    
    # Small delay to avoid rate limiting
    sleep 0.5
done

# Generate final report
echo ""
echo "========================================"
echo "Publish Complete!"
echo "========================================"
echo "Total Skills: $((${#SUCCESS_LIST[@]} + ${#FAILED_LIST[@]} + ${#EXISTING_LIST[@]}))"
echo "Successful: ${#SUCCESS_LIST[@]}"
echo "Already Exists: ${#EXISTING_LIST[@]}"
echo "Failed: ${#FAILED_LIST[@]}"
echo ""

# Build JSON results
json_results='{'
json_results+='"timestamp":"'$(date -Iseconds)'"'
json_results+=',"total":'$((${#SUCCESS_LIST[@]} + ${#FAILED_LIST[@]} + ${#EXISTING_LIST[@]}))''
json_results+=',"successful":'${#SUCCESS_LIST[@]}''
json_results+=',"existing":'${#EXISTING_LIST[@]}''
json_results+=',"failed":'${#FAILED_LIST[@]}''

# Add successful items
json_results+=',"published":['
first=true
for item in "${SUCCESS_LIST[@]}"; do
    if [ "$first" = true ]; then
        first=false
    else
        json_results+=','
    fi
    json_results+="$item"
done
json_results+=']'

# Add existing items
json_results+=',"existing":['
first=true
for item in "${EXISTING_LIST[@]}"; do
    if [ "$first" = true ]; then
        first=false
    else
        json_results+=','
    fi
    json_results+="$item"
done
json_results+=']'

# Add failed items
json_results+=',"failed":['
first=true
for item in "${FAILED_LIST[@]}"; do
    if [ "$first" = true ]; then
        first=false
    else
        json_results+=','
    fi
    json_results+="$item"
done
json_results+=']'

json_results+='}'

# Save results
echo "$json_results" > "$RESULTS_FILE"
echo "Results saved to: $RESULTS_FILE"

# Print summary
echo ""
echo "Successfully Published:"
for item in "${SUCCESS_LIST[@]}"; do
    name=$(echo "$item" | grep -o '"name":"[^"]*"' | cut -d'"' -f4)
    echo "  ✓ $name -> https://clawhub.com/skills/$name"
done

echo ""
echo "Already Existed:"
for item in "${EXISTING_LIST[@]}"; do
    name=$(echo "$item" | grep -o '"name":"[^"]*"' | cut -d'"' -f4)
    echo "  ⚠ $name"
done

echo ""
echo "Failed:"
for item in "${FAILED_LIST[@]}"; do
    name=$(echo "$item" | grep -o '"name":"[^"]*"' | cut -d'"' -f4)
    echo "  ✗ $name"
done
