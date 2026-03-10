#!/bin/bash
# ClawHub API Discovery - Find correct endpoints

API_TOKEN="clh_1fCyGAxj2bNgAqc3UmhZZJ9z4F0dbHAAVFlyzIEOPaA"
CLAWHUB_BASE="https://clawhub.ai"

echo "🔍 Discovering ClawHub API endpoints..."
echo ""

# Test various upload/storage endpoints
UPLOAD_ENDPOINTS=(
    "/api/v1/upload"
    "/api/v1/storage/upload"
    "/api/v1/files/upload"
    "/api/upload"
    "/upload"
)

for endpoint in "${UPLOAD_ENDPOINTS[@]}"; do
    echo "Testing: ${CLAWHUB_BASE}${endpoint}"
    
    # Create a test file
    echo "test content" > /tmp/test_upload.txt
    
    RESPONSE=$(curl -s -X POST "${CLAWHUB_BASE}${endpoint}" \
        -H "Authorization: Bearer ${API_TOKEN}" \
        -F "file=@/tmp/test_upload.txt" \
        -w "\nHTTP_CODE:%{http_code}" \
        -L 2>/dev/null)
    
    HTTP_CODE=$(echo "$RESPONSE" | tail -1 | grep -o 'HTTP_CODE:[0-9]*' | cut -d: -f2)
    echo "  Status: $HTTP_CODE"
    
    if [ "$HTTP_CODE" == "200" ] || [ "$HTTP_CODE" == "201" ]; then
        echo "  ✅ Upload endpoint found!"
        echo "  Response: $(echo "$RESPONSE" | sed '$d')"
    fi
    echo ""
done

# Check if there's a user-specific endpoint for their skills
echo "Checking user skills endpoint..."
USER_RESPONSE=$(curl -s -X GET "${CLAWHUB_BASE}/api/v1/user/skills" \
    -H "Authorization: Bearer ${API_TOKEN}" \
    -H "Accept: application/json" \
    -w "\nHTTP_CODE:%{http_code}" \
    -L 2>/dev/null)

echo "User skills status: $(echo "$USER_RESPONSE" | tail -1)"
echo ""

# Check OPTIONS for the skills POST endpoint
echo "Checking POST /api/v1/skills requirements..."
curl -s -X OPTIONS "${CLAWHUB_BASE}/api/v1/skills" \
    -H "Origin: https://clawhub.ai" \
    -H "Access-Control-Request-Method: POST" \
    -D - 2>/dev/null | grep -i "allow"
