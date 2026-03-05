#!/bin/bash

nohup openclaw gateway run --port 5000 > /app/work/logs/bypass/dev.log 2>&1 &

# Auto-approve pairing requests after Gateway starts
sleep 5
echo "Auto-approving any pending device pairing requests..."
openclaw devices approve --latest 2>/dev/null || echo "No pending pairing requests or approval failed"