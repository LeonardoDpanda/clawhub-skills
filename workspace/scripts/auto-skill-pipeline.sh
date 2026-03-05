#!/bin/bash
#
# Auto Skill Pipeline - Complete automation for Skill generation and publishing
# Trigger: Daily at 1:00 AM Beijing Time (UTC 17:00)
# Manual: Run directly or via "openclaw sessions spawn"

set -euo pipefail

# Configuration
WORKSPACE="/workspace/projects/workspace"
REGISTRY_FILE="$WORKSPACE/memory/skill-registry.json"
TEMP_DIR="/tmp/skill-pipeline-$(date +%s)"
TARGET_REPO="https://github.com/LeonardoDpanda/clawhub-skills.git"
REPO_DIR="$TEMP_DIR/clawhub-skills"
LOG_FILE="$WORKSPACE/memory/skill-pipeline.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

# Cleanup on exit
cleanup() {
    if [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
}
trap cleanup EXIT

# Check prerequisites
check_prerequisites() {
    log "Checking prerequisites..."
    
    # Check GitHub auth
    if ! gh auth status &>/dev/null; then
        error "GitHub CLI not authenticated. Run: gh auth login"
        return 1
    fi
    
    # Check ClawHub CLI
    if ! command -v clawhub &>/dev/null; then
        warning "ClawHub CLI not found. Installing..."
        npm install -g clawhub
    fi
    
    # Check ClawHub auth
    if ! clawhub whoami &>/dev/null; then
        error "ClawHub not authenticated. Run: clawhub login"
        return 1
    fi
    
    success "Prerequisites check passed"
    return 0
}

# Generate Skill content using AI
# This function is called within the OpenClaw session context
generate_skill() {
    log "Starting Skill generation..."
    
    # The actual generation happens via OpenClaw agent
    # This script expects the SKILL.md content to be provided via stdin or file
    
    local skill_name="$1"
    local skill_content_file="$2"
    
    if [[ ! -f "$skill_content_file" ]]; then
        error "Skill content file not found: $skill_content_file"
        return 1
    fi
    
    success "Skill content loaded: $skill_name"
    return 0
}

# Push to GitHub
push_to_github() {
    local skill_name="$1"
    local skill_file="$2"
    
    log "Pushing $skill_name to GitHub..."
    
    # Clone repo
    mkdir -p "$TEMP_DIR"
    if ! git clone "$TARGET_REPO" "$REPO_DIR" 2>/dev/null; then
        # If clone fails, might already exist or auth issue
        error "Failed to clone repository. Check GitHub auth."
        return 1
    fi
    
    # Copy skill file
    local target_file="$REPO_DIR/${skill_name}_SKILL.md"
    cp "$skill_file" "$target_file"
    
    # Git operations
    cd "$REPO_DIR"
    git add "${skill_name}_SKILL.md"
    
    if git diff --cached --quiet; then
        warning "No changes to commit (file may already exist)"
        return 0
    fi
    
    git commit -m "feat: add ${skill_name} Skill - Auto-generated"
    
    if git push origin main; then
        success "Pushed to GitHub: $target_file"
        echo "https://github.com/LeonardoDpanda/clawhub-skills/blob/main/${skill_name}_SKILL.md"
        return 0
    else
        error "Failed to push to GitHub"
        return 1
    fi
}

# Publish to ClawHub
publish_to_clawhub() {
    local skill_name="$1"
    local skill_dir="$2"
    
    log "Publishing $skill_name to ClawHub..."
    
    # Extract human-readable name from SKILL.md
    local human_name=$(grep "^# " "$skill_dir/SKILL.md" | head -1 | sed 's/^# //')
    if [[ -z "$human_name" ]]; then
        human_name="$skill_name"
    fi
    
    if clawhub publish "$skill_dir" \
        --slug "$skill_name" \
        --name "$human_name" \
        --version "1.0.0" \
        --changelog "Auto-generated initial release"; then
        success "Published to ClawHub: $skill_name"
        echo "https://clawhub.com/skills/$skill_name"
        return 0
    else
        error "Failed to publish to ClawHub"
        return 1
    fi
}

# Update registry
update_registry() {
    local name="$1"
    local description="$2"
    local rationale="$3"
    local status="$4"
    local github_url="$5"
    local clawhub_url="$6"
    
    log "Updating registry..."
    
    local timestamp=$(date '+%Y-%m-%d %H:%M')
    
    # Create new entry
    local new_entry=$(cat <<EOF
    {
      "name": "$name",
      "description": "$description",
      "marketRationale": "$rationale",
      "createdAt": "$timestamp",
      "publishStatus": "$status",
      "githubPath": "$github_url",
      "clawhubUrl": "$clawhub_url"
    }
EOF
)
    
    # Update registry using jq if available, otherwise Python
    if command -v jq &>/dev/null; then
        jq --argjson entry "$new_entry" '.skills += [$entry]' "$REGISTRY_FILE" > "$REGISTRY_FILE.tmp"
        mv "$REGISTRY_FILE.tmp" "$REGISTRY_FILE"
    elif command -v python3 &>/dev/null; then
        python3 << PYEOF
import json
with open('$REGISTRY_FILE', 'r') as f:
    data = json.load(f)
entry = $new_entry
data['skills'].append(entry)
data['stats']['totalGenerated'] += 1
data['stats']['lastUpdated'] = '$timestamp'
data['stats']['lastSkillName'] = '$name'
if '$status' == '已发布':
    data['stats']['totalPublished'] += 1
else:
    data['stats']['totalFailed'] += 1
with open('$REGISTRY_FILE', 'w') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
PYEOF
    fi
    
    success "Registry updated"
}

# Send notifications
send_notifications() {
    local name="$1"
    local description="$2"
    local rationale="$3"
    local status="$4"
    local github_url="$5"
    local clawhub_url="$6"
    
    local timestamp=$(date '+%Y-%m-%d %H:%M')
    
    # Build notification message
    local message=$(cat <<EOF
🎯 Skill 自动生成完成

📌 技能名称：$name
📝 功能简介：$description
📊 市场定位：$rationale
✅ 发布状态：$status
🔗 GitHub：$github_url
🌐 ClawHub：$clawhub_url
⏰ 生成时间：$timestamp
EOF
)
    
    log "Sending notifications..."
    
    # WebChat - write to notification file for agent to pick up
    echo "$message" > "$WORKSPACE/memory/.notification_webchat"
    
    # Telegram - if configured
    if [[ -f "$WORKSPACE/config/telegram_bot.conf" ]]; then
        source "$WORKSPACE/config/telegram_bot.conf"
        curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
            -d "chat_id=${CHAT_ID}" \
            -d "text=$message" \
            -d "parse_mode=HTML" > /dev/null || warning "Telegram notification failed"
    fi
    
    # Email - if configured
    if [[ -f "$WORKSPACE/config/email.conf" ]]; then
        source "$WORKSPACE/config/email.conf"
        echo "$message" | mail -s "[ClawHub] Skill 发布完成: $name" "$EMAIL_TO" || warning "Email notification failed"
    fi
    
    success "Notifications sent"
}

# Main pipeline execution
main() {
    log "=== Skill Auto-Pipeline Started ==="
    
    # Check prerequisites
    if ! check_prerequisites; then
        error "Prerequisites check failed"
        exit 1
    fi
    
    # Note: The actual Skill generation is done by the OpenClaw agent
    # This script expects the generated files to be provided
    
    log "Pipeline ready. Waiting for Skill content from agent..."
    log "Use: openclaw sessions spawn --task '生成并发布1个高价值Skill'"
}

# Handle manual trigger with pre-generated content
run_with_content() {
    local skill_name="$1"
    local skill_content="$2"
    local description="$3"
    local rationale="$4"
    
    log "=== Running Pipeline for: $skill_name ==="
    
    # Setup temp directory
    mkdir -p "$TEMP_DIR/skill"
    local skill_file="$TEMP_DIR/skill/SKILL.md"
    
    # Write skill content
    echo "$skill_content" > "$skill_file"
    
    # Step 1: Push to GitHub
    local github_url=""
    if push_to_github "$skill_name" "$skill_file"; then
        github_url="https://github.com/LeonardoDpanda/clawhub-skills/blob/main/${skill_name}_SKILL.md"
    else
        github_url="Push failed"
    fi
    
    # Step 2: Publish to ClawHub
    local clawhub_url=""
    local status="发布失败"
    if publish_to_clawhub "$skill_name" "$TEMP_DIR/skill"; then
        clawhub_url="https://clawhub.com/skills/$skill_name"
        status="已发布"
    else
        clawhub_url="Publication pending"
    fi
    
    # Step 3: Update registry
    update_registry "$skill_name" "$description" "$rationale" "$status" "$github_url" "$clawhub_url"
    
    # Step 4: Send notifications
    send_notifications "$skill_name" "$description" "$rationale" "$status" "$github_url" "$clawhub_url"
    
    log "=== Pipeline Complete ==="
    
    # Return results
    cat <<EOF
PIPELINE_RESULT:{
  "skillName": "$skill_name",
  "status": "$status",
  "githubUrl": "$github_url",
  "clawhubUrl": "$clawhub_url",
  "timestamp": "$(date '+%Y-%m-%d %H:%M')"
}
EOF
}

# Command dispatch
case "${1:-}" in
    "run")
        # Run with provided content
        shift
        run_with_content "$@"
        ;;
    "check")
        # Just check prerequisites
        check_prerequisites
        ;;
    *)
        # Default: show usage
        cat <<EOF
Usage: $0 [command] [args]

Commands:
  check                           Check prerequisites
  run <name> <content> <desc> <rationale>  Run full pipeline

Environment:
  WORKSPACE    OpenClaw workspace path (default: /workspace/projects/workspace)

Examples:
  $0 check
  $0 run "my-skill" "# SKILL.md content..." "Description" "Market rationale"
EOF
        ;;
esac
