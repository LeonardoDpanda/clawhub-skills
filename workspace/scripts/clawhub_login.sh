#!/bin/bash
# ClawHub Login and Publish Script

EMAIL="410205301@qq.com"
PASSWORD='$UK{Pq0!*E_O'
API_TOKEN="clh_1fCyGAxj2bNgAqc3UmhZZJ9z4F0dbHAAVFlyzIEOPaA"
CLAWHUB_BASE="https://clawhub.ai"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🚀 ClawHub Login and Batch Publish"
echo "=================================="
echo ""

# Try multiple login endpoints
LOGIN_ENDPOINTS=(
    "/api/v1/auth/login"
    "/api/v1/login"
    "/auth/login"
    "/api/auth/login"
)

SESSION_TOKEN=""
LOGIN_SUCCESS=false

for endpoint in "${LOGIN_ENDPOINTS[@]}"; do
    echo -e "${YELLOW}Trying login endpoint: ${CLAWHUB_BASE}${endpoint}${NC}"
    
    RESPONSE=$(curl -s -X POST "${CLAWHUB_BASE}${endpoint}" \
        -H "Content-Type: application/json" \
        -d "{\"email\":\"${EMAIL}\",\"password\":\"${PASSWORD}\"}" \
        -w "\nHTTP_CODE:%{http_code}" \
        -L 2>/dev/null)
    
    HTTP_CODE=$(echo "$RESPONSE" | grep -oP 'HTTP_CODE:\K[0-9]+')
    BODY=$(echo "$RESPONSE" | sed 's/HTTP_CODE:[0-9]*//')
    
    echo "Response Code: $HTTP_CODE"
    echo "Response Body: $BODY"
    echo ""
    
    if [ "$HTTP_CODE" == "200" ] || [ "$HTTP_CODE" == "201" ]; then
        echo -e "${GREEN}✅ Login successful!${NC}"
        LOGIN_SUCCESS=true
        # Try to extract token
        SESSION_TOKEN=$(echo "$BODY" | grep -oP '(?<=token\":\"|\"token\":\s*\")[^\"]+' | head -1)
        if [ -z "$SESSION_TOKEN" ]; then
            SESSION_TOKEN=$(echo "$BODY" | grep -oP '(?<=access_token\":\"|\"access_token\":\s*\")[^\"]+' | head -1)
        fi
        if [ -z "$SESSION_TOKEN" ]; then
            SESSION_TOKEN=$(echo "$BODY" | grep -oP '(?<=session\":\"|\"session\":\s*\")[^\"]+' | head -1)
        fi
        break
    fi
done

if [ "$LOGIN_SUCCESS" = false ]; then
    echo -e "${RED}❌ Login failed on all endpoints${NC}"
    echo "Trying with API Token directly..."
    
    # Try to verify API token
    VERIFY_RESPONSE=$(curl -s -X GET "${CLAWHUB_BASE}/api/v1/user/profile" \
        -H "Authorization: Bearer ${API_TOKEN}" \
        -H "Content-Type: application/json" \
        -w "\nHTTP_CODE:%{http_code}" \
        -L 2>/dev/null)
    
    VERIFY_HTTP_CODE=$(echo "$VERIFY_RESPONSE" | grep -oP 'HTTP_CODE:\K[0-9]+')
    
    if [ "$VERIFY_HTTP_CODE" == "200" ]; then
        echo -e "${GREEN}✅ API Token is valid!${NC}"
        SESSION_TOKEN="$API_TOKEN"
        LOGIN_SUCCESS=true
    fi
fi

if [ "$LOGIN_SUCCESS" = true ]; then
    echo ""
    echo -e "${GREEN}Session Token: ${SESSION_TOKEN:0:20}...${NC}"
    echo "$SESSION_TOKEN" > /tmp/clawhub_session.txt
    exit 0
else
    echo -e "${RED}❌ All login attempts failed${NC}"
    exit 1
fi
