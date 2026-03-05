#!/bin/bash
#
# Auto-approve device pairing requests
# This script should be run periodically to automatically approve pending pairing requests

LOG_FILE="/workspace/projects/workspace/memory/device-approval.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Check for pending pairing requests
check_and_approve() {
    # Get list of pending devices
    local pending=$(openclaw devices list 2>/dev/null | grep "Pending (" | sed 's/.*Pending (\([0-9]*\)).*/\1/')
    
    if [[ -n "$pending" && "$pending" -gt 0 ]]; then
        log "Found $pending pending pairing request(s), approving..."
        
        if openclaw devices approve --latest 2>/dev/null; then
            log "✓ Successfully approved pairing request"
        else
            log "✗ Failed to approve pairing request"
        fi
    fi
}

# Run once
check_and_approve