#!/bin/bash
# ClawHub Skill Publisher - Run this on your local machine

CLAWHUB_TOKEN="clh_bvEZkqyJ9vQdxccv_U3GTcwjGBmLypGofQJA88hlsSQ"

echo "🚀 Publishing 10 Skills to ClawHub..."
echo ""

# Skill 1
echo "📦 Publishing: password-generator ($4)"
curl -s -X POST "https://clawhub.com/api/skills" \
  -H "Authorization: Bearer $CLAWHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "password-generator",
    "description": "Generate secure, customizable passwords with configurable length, character sets, and entropy requirements",
    "github_url": "https://github.com/LeonardoDpanda/clawhub-skills/blob/main/password-generator_SKILL.md",
    "version": "1.0.0",
    "tags": ["security", "password", "generator"]
  }'
echo " ✅"
echo ""

# Skill 2
echo "📦 Publishing: csv-processor ($5)"
curl -s -X POST "https://clawhub.com/api/skills" \
  -H "Authorization: Bearer $CLAWHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "csv-processor",
    "description": "Process CSV files with filtering, sorting, aggregation, column operations, and format conversion",
    "github_url": "https://github.com/LeonardoDpanda/clawhub-skills/blob/main/csv-processor_SKILL.md",
    "version": "1.0.0",
    "tags": ["csv", "data-processing", "analytics"]
  }'
echo " ✅"
echo ""

# Skill 3
echo "📦 Publishing: markdown-formatter ($3)"
curl -s -X POST "https://clawhub.com/api/skills" \
  -H "Authorization: Bearer $CLAWHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "markdown-formatter",
    "description": "Format, lint, and convert Markdown documents with table of contents generation and link validation",
    "github_url": "https://github.com/LeonardoDpanda/clawhub-skills/blob/main/markdown-formatter_SKILL.md",
    "version": "1.0.0",
    "tags": ["markdown", "documentation", "formatting"]
  }'
echo " ✅"
echo ""

# Skill 4
echo "📦 Publishing: system-health-check ($5)"
curl -s -X POST "https://clawhub.com/api/skills" \
  -H "Authorization: Bearer $CLAWHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "system-health-check",
    "description": "Monitor system health metrics including CPU, memory, disk usage, network connectivity, and service status",
    "github_url": "https://github.com/LeonardoDpanda/clawhub-skills/blob/main/system-health-check_SKILL.md",
    "version": "1.0.0",
    "tags": ["system", "monitoring", "health-check"]
  }'
echo " ✅"
echo ""

# Skill 5
echo "📦 Publishing: url-encoder ($3)"
curl -s -X POST "https://clawhub.com/api/skills" \
  -H "Authorization: Bearer $CLAWHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "url-encoder",
    "description": "Encode and decode URLs, query parameters, base64 strings, HTML entities, and perform URL parsing",
    "github_url": "https://github.com/LeonardoDpanda/clawhub-skills/blob/main/url-encoder_SKILL.md",
    "version": "1.0.0",
    "tags": ["url", "encoding", "web-development"]
  }'
echo " ✅"
echo ""

# Skill 6
echo "📦 Publishing: csv-data-analyzer ($6)"
curl -s -X POST "https://clawhub.com/api/skills" \
  -H "Authorization: Bearer $CLAWHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "csv-data-analyzer",
    "description": "Analyze CSV files to extract statistics, detect patterns, identify anomalies, and generate data quality reports",
    "github_url": "https://github.com/LeonardoDpanda/clawhub-skills/blob/main/csv-data-analyzer_SKILL.md",
    "version": "1.0.0",
    "tags": ["csv", "data-analysis", "statistics"]
  }'
echo " ✅"
echo ""

# Skill 7
echo "📦 Publishing: url-shortener-expander ($3)"
curl -s -X POST "https://clawhub.com/api/skills" \
  -H "Authorization: Bearer $CLAWHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "url-shortener-expander",
    "description": "Shorten long URLs using popular services and expand shortened URLs to reveal their destinations",
    "github_url": "https://github.com/LeonardoDpanda/clawhub-skills/blob/main/url-shortener-expander_SKILL.md",
    "version": "1.0.0",
    "tags": ["url", "shortener", "productivity"]
  }'
echo " ✅"
echo ""

# Skill 8
echo "📦 Publishing: text-diff-comparator ($5)"
curl -s -X POST "https://clawhub.com/api/skills" \
  -H "Authorization: Bearer $CLAWHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "text-diff-comparator",
    "description": "Compare two text files or strings to find differences, generate patches, and visualize changes",
    "github_url": "https://github.com/LeonardoDpanda/clawhub-skills/blob/main/text-diff-comparator_SKILL.md",
    "version": "1.0.0",
    "tags": ["diff", "comparison", "developer-tools"]
  }'
echo " ✅"
echo ""

# Skill 9
echo "📦 Publishing: json-schema-validator ($7)"
curl -s -X POST "https://clawhub.com/api/skills" \
  -H "Authorization: Bearer $CLAWHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "json-schema-validator",
    "description": "Validate JSON data against JSON Schema definitions, generate schemas from sample data, and test API responses",
    "github_url": "https://github.com/LeonardoDpanda/clawhub-skills/blob/main/json-schema-validator_SKILL.md",
    "version": "1.0.0",
    "tags": ["json", "schema", "validation", "api"]
  }'
echo " ✅"
echo ""

# Skill 10 - Timestamp Converter (待变现)
echo "📦 Publishing: timestamp-converter ($3)"
curl -s -X POST "https://clawhub.com/api/skills" \
  -H "Authorization: Bearer $CLAWHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "timestamp-converter",
    "description": "Convert between Unix timestamps, ISO 8601 dates, and human-readable formats",
    "github_url": "https://github.com/LeonardoDpanda/clawhub-skills/blob/main/timestamp-converter_SKILL.md",
    "version": "1.0.0",
    "tags": ["timestamp", "date", "converter"]
  }'
echo " ✅"
echo ""

echo "🎉 All 10 skills published!"
echo ""
echo "Check your skills at: https://clawhub.com/dashboard"
