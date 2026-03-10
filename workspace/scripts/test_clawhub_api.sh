#!/bin/bash
# ClawHub API Test with Token

API_TOKEN="clh_1fCyGAxj2bNgAqc3UmhZZJ9z4F0dbHAAVFlyzIEOPaA"
CLAWHUB_BASE="https://clawhub.ai"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "🔍 Testing ClawHub API Endpoints"
echo "================================"
echo ""

# Test API Token with various endpoints
ENDPOINTS=(
    "/api/v1/user"
    "/api/v1/user/profile"
    "/api/v1/me"
    "/api/v1/skills"
    "/api/v1/skills/list"
    "/api/skills"
)

for endpoint in "${ENDPOINTS[@]}"; do
    echo -e "${BLUE}Testing: ${CLAWHUB_BASE}${endpoint}${NC}"
    
    RESPONSE=$(curl -s -X GET "${CLAWHUB_BASE}${endpoint}" \
        -H "Authorization: Bearer ${API_TOKEN}" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json" \
        -w "\nHTTP_CODE:%{http_code}" \
        -L 2>/dev/null)
    
    HTTP_CODE=$(echo "$RESPONSE" | tail -1 | grep -o 'HTTP_CODE:[0-9]*' | cut -d: -f2)
    BODY=$(echo "$RESPONSE" | sed '$d')
    
    if [ -z "$HTTP_CODE" ]; then
        HTTP_CODE=$(echo "$RESPONSE" | grep -o '"statusCode":[0-9]*' | cut -d: -f2)
    fi
    
    echo "  Status: $HTTP_CODE"
    if [ "$HTTP_CODE" == "200" ]; then
        echo -e "  ${GREEN}✅ Working!${NC}"
        echo "  Response: ${BODY:0:200}"
    elif [ "$HTTP_CODE" == "401" ] || [ "$HTTP_CODE" == "403" ]; then
        echo -e "  ${YELLOW}⚠️ Auth required/invalid${NC}"
    elif [ "$HTTP_CODE" == "404" ]; then
        echo -e "  ${RED}❌ Not found${NC}"
    else
        echo "  Response: ${BODY:0:100}"
    fi
    echo ""
done

# Check if there's a GraphQL endpoint
echo -e "${BLUE}Testing GraphQL endpoint...${NC}"
GRAPHQL_RESPONSE=$(curl -s -X POST "${CLAWHUB_BASE}/graphql" \
    -H "Content-Type: application/json" \
    -d '{"query":"{ __typename }"}' \
    -w "\nHTTP_CODE:%{http_code}" \
    -L 2>/dev/null)

GRAPHQL_CODE=$(echo "$GRAPHQL_RESPONSE" | tail -1 | grep -o 'HTTP_CODE:[0-9]*' | cut -d: -f2)
echo "  GraphQL Status: $GRAPHQL_CODE"
if [ "$GRAPHQL_CODE" == "200" ]; then
    echo -e "  ${GREEN}✅ GraphQL available!${NC}"
fi
echo ""

# Check OPTIONS for CORS info
echo -e "${BLUE}Checking API capabilities...${NC}"
OPTIONS_RESPONSE=$(curl -s -X OPTIONS "${CLAWHUB_BASE}/api/v1/skills" \
    -H "Origin: https://clawhub.ai" \
    -H "Access-Control-Request-Method: POST" \
    -D - 2>/dev/null | head -20)
echo "$OPTIONS_RESPONSE"
