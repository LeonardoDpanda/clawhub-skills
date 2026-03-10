#!/bin/bash
# Gumroad API 批量创建产品测试
# 基于标准 REST API 格式测试

TOKEN="$GUMROAD_API_TOKEN"

# 测试 1: 创建产品（标准格式）
echo "=== Test 1: Create Product (Form Data) ==="
curl -s -X POST "https://api.gumroad.com/v2/products" \
  -d "access_token=$TOKEN" \
  -d "product[name]=SSL Certificate Checker" \
  -d "product[price]=500" \
  -d "product[currency]=usd" \
  -d "product[description]=Check SSL/TLS certificates for any domain" \
  -d "product[is_physical]=false" \
  -d "product[custom_permalink]=ssl-certificate-checker" \
  2>&1 | tee /tmp/gumroad-test-1.log

echo ""
echo "=== Test 2: Create Product (JSON Format) ==="
# 测试 JSON 格式
curl -s -X POST "https://api.gumroad.com/v2/products" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "product": {
      "name": "HTTP Headers Analyzer",
      "price": 400,
      "currency": "usd",
      "description": "Analyze HTTP headers for security and performance",
      "is_physical": false,
      "custom_permalink": "http-headers-analyzer"
    }
  }' 2>&1 | tee /tmp/gumroad-test-2.log

echo ""
echo "=== Test 3: Get Products List ==="
# 先测试获取列表
curl -s "https://api.gumroad.com/v2/products" \
  -d "access_token=$TOKEN" 2>&1 | tee /tmp/gumroad-test-3.log

echo ""
echo "=== Results saved to /tmp/gumroad-test-*.log ==="
