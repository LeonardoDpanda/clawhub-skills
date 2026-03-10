#!/bin/bash
# Accept MIT-0 License and Publish

API_TOKEN="clh_1fCyGAxj2bNgAqc3UmhZZJ9z4F0dbHAAVFlyzIEOPaA"
CLAWHUB_BASE="https://clawhub.ai"

echo "📝 Attempting to accept MIT-0 license..."
echo ""

# Try to accept license via API
LICENSE_ENDPOINTS=(
    "/api/v1/user/license"
    "/api/v1/user/accept-license"
    "/api/v1/license/accept"
    "/api/v1/auth/license"
)

for endpoint in "${LICENSE_ENDPOINTS[@]}"; do
    echo "Trying: ${CLAWHUB_BASE}${endpoint}"
    
    RESPONSE=$(curl -s -X POST "${CLAWHUB_BASE}${endpoint}" \
        -H "Authorization: Bearer ${API_TOKEN}" \
        -H "Content-Type: application/json" \
        -d '{"license": "MIT-0", "accepted": true}' \
        -w "\nHTTP_CODE:%{http_code}" \
        -L 2>/dev/null)
    
    HTTP_CODE=$(echo "$RESPONSE" | tail -1 | grep -o 'HTTP_CODE:[0-9]*' | cut -d: -f2)
    echo "  Status: $HTTP_CODE"
    
    if [ "$HTTP_CODE" == "200" ] || [ "$HTTP_CODE" == "201" ]; then
        echo "  ✅ License accepted!"
        break
    fi
done

# Check user profile for license status
echo ""
echo "🔍 Checking user profile..."
PROFILE_RESPONSE=$(curl -s -X GET "${CLAWHUB_BASE}/api/v1/user" \
    -H "Authorization: Bearer ${API_TOKEN}" \
    -H "Accept: application/json" \
    -w "\nHTTP_CODE:%{http_code}" \
    -L 2>/dev/null)

echo "Profile endpoint status: $(echo "$PROFILE_RESPONSE" | tail -1)"
