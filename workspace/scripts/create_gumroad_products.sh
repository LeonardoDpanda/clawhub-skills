#!/bin/bash
# Gumroad Auto Product Creator - Run this on your local machine

GUMROAD_TOKEN="CQ8wPlMhWv1to-rjIpAHu6cnlWJfBy3fTGZkoqdtQu0"

echo "🚀 Creating 10 products on Gumroad..."
echo ""

# Product 1
echo "💰 Creating: Timestamp Converter ($3)"
curl -s -X POST "https://api.gumroad.com/v2/products" \
  -H "Authorization: Bearer $GUMROAD_TOKEN" \
  -d "product[name]=Timestamp Converter - OpenClaw Skill" \
  -d "product[description]=Convert between Unix timestamps, ISO 8601 dates, and human-readable formats.\n\n✨ Features:\n- Unix timestamp ↔ ISO 8601 conversion\n- Human-readable formatting\n- Batch processing\n\n🔗 Get it on ClawHub: https://clawhub.com/skills/timestamp-converter" \
  -d "product[price]=300" \
  -d "product[currency]=usd" \
  -d "product[is_physical]=false" \
  -d "product[tags][]=openclaw" \
  -d "product[tags][]=developer-tools"
echo " ✅"
echo ""

# Product 2
echo "💰 Creating: Password Generator ($4)"
curl -s -X POST "https://api.gumroad.com/v2/products" \
  -H "Authorization: Bearer $GUMROAD_TOKEN" \
  -d "product[name]=Password Generator - OpenClaw Skill" \
  -d "product[description]=Generate secure, customizable passwords with configurable length and entropy.\n\n✨ Features:\n- Customizable length\n- Entropy calculation\n- Multiple character sets\n\n🔗 Get it on ClawHub: https://clawhub.com/skills/password-generator" \
  -d "product[price]=400" \
  -d "product[currency]=usd" \
  -d "product[is_physical]=false" \
  -d "product[tags][]=openclaw" \
  -d "product[tags][]=security"
echo " ✅"
echo ""

# Product 3
echo "💰 Creating: CSV Data Analyzer ($6)"
curl -s -X POST "https://api.gumroad.com/v2/products" \
  -H "Authorization: Bearer $GUMROAD_TOKEN" \
  -d "product[name]=CSV Data Analyzer - OpenClaw Skill" \
  -d "product[description]=Analyze CSV files with statistics, pattern detection, and anomaly identification.\n\n✨ Features:\n- Statistical analysis\n- Pattern detection\n- Data quality reports\n\n🔗 Get it on ClawHub: https://clawhub.com/skills/csv-data-analyzer" \
  -d "product[price]=600" \
  -d "product[currency]=usd" \
  -d "product[is_physical]=false" \
  -d "product[tags][]=openclaw" \
  -d "product[tags][]=data-analysis"
echo " ✅"
echo ""

# Product 4
echo "💰 Creating: URL Shortener & Expander ($3)"
curl -s -X POST "https://api.gumroad.com/v2/products" \
  -H "Authorization: Bearer $GUMROAD_TOKEN" \
  -d "product[name]=URL Shortener Expander - OpenClaw Skill" \
  -d "product[description]=Shorten long URLs and expand shortened URLs with security checks.\n\n✨ Features:\n- URL shortening\n- URL expansion\n- Security verification\n\n🔗 Get it on ClawHub: https://clawhub.com/skills/url-shortener-expander" \
  -d "product[price]=300" \
  -d "product[currency]=usd" \
  -d "product[is_physical]=false" \
  -d "product[tags][]=openclaw" \
  -d "product[tags][]=productivity"
echo " ✅"
echo ""

# Product 5
echo "💰 Creating: Text Diff Comparator ($5)"
curl -s -X POST "https://api.gumroad.com/v2/products" \
  -H "Authorization: Bearer $GUMROAD_TOKEN" \
  -d "product[name]=Text Diff Comparator - OpenClaw Skill" \
  -d "product[description]=Compare text differences with unified diff, side-by-side view, and patch generation.\n\n✨ Features:\n- Unified diff format\n- Side-by-side comparison\n- Patch generation\n\n🔗 Get it on ClawHub: https://clawhub.com/skills/text-diff-comparator" \
  -d "product[price]=500" \
  -d "product[currency]=usd" \
  -d "product[is_physical]=false" \
  -d "product[tags][]=openclaw" \
  -d "product[tags][]=developer-tools"
echo " ✅"
echo ""

# Product 6
echo "💰 Creating: JSON Schema Validator ($7)"
curl -s -X POST "https://api.gumroad.com/v2/products" \
  -H "Authorization: Bearer $GUMROAD_TOKEN" \
  -d "product[name]=JSON Schema Validator - OpenClaw Skill" \
  -d "product[description]=Validate JSON against schemas, generate schemas from data, and test API responses.\n\n✨ Features:\n- JSON Schema validation\n- Schema generation\n- API response testing\n\n🔗 Get it on ClawHub: https://clawhub.com/skills/json-schema-validator" \
  -d "product[price]=700" \
  -d "product[currency]=usd" \
  -d "product[is_physical]=false" \
  -d "product[tags][]=openclaw" \
  -d "product[tags][]=api"
echo " ✅"
echo ""

# Product 7
echo "💰 Creating: CSV Processor ($5)"
curl -s -X POST "https://api.gumroad.com/v2/products" \
  -H "Authorization: Bearer $GUMROAD_TOKEN" \
  -d "product[name]=CSV Processor - OpenClaw Skill" \
  -d "product[description]=Process CSV files with filtering, sorting, aggregation, and format conversion.\n\n✨ Features:\n- Data filtering\n- Sorting & aggregation\n- Column operations\n\n🔗 Get it on ClawHub: https://clawhub.com/skills/csv-processor" \
  -d "product[price]=500" \
  -d "product[currency]=usd" \
  -d "product[is_physical]=false" \
  -d "product[tags][]=openclaw" \
  -d "product[tags][]=csv"
echo " ✅"
echo ""

# Product 8
echo "💰 Creating: Markdown Formatter ($3)"
curl -s -X POST "https://api.gumroad.com/v2/products" \
  -H "Authorization: Bearer $GUMROAD_TOKEN" \
  -d "product[name]=Markdown Formatter - OpenClaw Skill" \
  -d "product[description]=Format, lint, and convert Markdown with TOC generation and link validation.\n\n✨ Features:\n- Document formatting\n- TOC generation\n- Link validation\n\n🔗 Get it on ClawHub: https://clawhub.com/skills/markdown-formatter" \
  -d "product[price]=300" \
  -d "product[currency]=usd" \
  -d "product[is_physical]=false" \
  -d "product[tags][]=openclaw" \
  -d "product[tags][]=documentation"
echo " ✅"
echo ""

# Product 9
echo "💰 Creating: System Health Check ($5)"
curl -s -X POST "https://api.gumroad.com/v2/products" \
  -H "Authorization: Bearer $GUMROAD_TOKEN" \
  -d "product[name]=System Health Check - OpenClaw Skill" \
  -d "product[description]=Monitor system metrics including CPU, memory, disk, network, and services.\n\n✨ Features:\n- CPU & memory monitoring\n- Disk usage tracking\n- Network connectivity\n\n🔗 Get it on ClawHub: https://clawhub.com/skills/system-health-check" \
  -d "product[price]=500" \
  -d "product[currency]=usd" \
  -d "product[is_physical]=false" \
  -d "product[tags][]=openclaw" \
  -d "product[tags][]=system"
echo " ✅"
echo ""

# Product 10
echo "💰 Creating: URL Encoder ($3)"
curl -s -X POST "https://api.gumroad.com/v2/products" \
  -H "Authorization: Bearer $GUMROAD_TOKEN" \
  -d "product[name]=URL Encoder - OpenClaw Skill" \
  -d "product[description]=Encode and decode URLs, query parameters, Base64, and HTML entities.\n\n✨ Features:\n- URL encoding/decoding\n- Base64 conversion\n- HTML entities\n\n🔗 Get it on ClawHub: https://clawhub.com/skills/url-encoder" \
  -d "product[price]=300" \
  -d "product[currency]=usd" \
  -d "product[is_physical]=false" \
  -d "product[tags][]=openclaw" \
  -d "product[tags][]=web"
echo " ✅"
echo ""

echo "🎉 All 10 products created!"
echo ""
echo "View your products at: https://gumroad.com/dashboard"
