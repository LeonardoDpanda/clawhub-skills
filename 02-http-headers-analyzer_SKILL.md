---
name: http-headers-analyzer
description: Analyze HTTP response headers for security, performance, and caching configurations. Use when auditing website security headers, optimizing performance, debugging CORS issues, or checking server configurations.
---

# HTTP Headers Analyzer

Inspect and analyze HTTP response headers to evaluate security posture, performance optimization, and configuration correctness.

## When to Use

- Auditing security headers (CSP, HSTS, X-Frame-Options)
- Checking cache-control and performance headers
- Debugging CORS configuration issues
- Analyzing server and technology stack
- Verifying redirect chains

## When NOT to Use

- Modifying headers (this is analysis-only)
- Testing authentication (use dedicated auth tools)
- Load testing (use specialized tools like ab, wrk)

## Examples

### Basic Header Fetch

```bash
# Get all headers for a URL
curl -sI https://example.com

# Get headers with redirect following
curl -sIL https://example.com

# Show only specific headers
curl -sI https://example.com | grep -i "content-type\|server\|x-"
```

### Security Headers Check

```bash
#!/bin/bash
URL="$1"
if [ -z "$URL" ]; then
    echo "Usage: $0 <url>"
    exit 1
fi

echo "=== Security Headers Analysis for $URL ==="
headers=$(curl -sI "$URL")

echo
echo "Strict-Transport-Security (HSTS):"
echo "$headers" | grep -i "strict-transport-security" || echo "❌ Missing - Vulnerable to SSL stripping"

echo
echo "Content-Security-Policy:"
echo "$headers" | grep -i "content-security-policy" || echo "❌ Missing - XSS risk increased"

echo
echo "X-Frame-Options:"
echo "$headers" | grep -i "x-frame-options" || echo "❌ Missing - Clickjacking possible"

echo
echo "X-Content-Type-Options:"
echo "$headers" | grep -i "x-content-type-options" || echo "❌ Missing - MIME sniffing possible"

echo
echo "Referrer-Policy:"
echo "$headers" | grep -i "referrer-policy" || echo "⚠️  Missing - Privacy implications"

echo
echo "Permissions-Policy:"
echo "$headers" | grep -i "permissions-policy" || echo "⚠️  Missing - Feature control not enforced"
```

### Performance Headers Analysis

```bash
#!/bin/bash
URL="$1"

echo "=== Performance Headers for $URL ==="
headers=$(curl -sI "$URL")

echo
echo "Cache-Control:"
echo "$headers" | grep -i "cache-control" || echo "Not set"

echo
echo "ETag:"
echo "$headers" | grep -i "etag" || echo "Not set - Conditional requests not supported"

echo
echo "Last-Modified:"
echo "$headers" | grep -i "last-modified" || echo "Not set"

echo
echo "Content-Encoding:"
echo "$headers" | grep -i "content-encoding" || echo "Not compressed"

echo
echo "Vary:"
echo "$headers" | grep -i "vary" || echo "Not set"
```

### Full Header Report

```bash
#!/bin/bash
URL="${1:-https://example.com}"

echo "╔════════════════════════════════════════════════╗"
echo "║     HTTP Headers Analysis Report               ║"
echo "╚════════════════════════════════════════════════╝"
echo "Target: $URL"
echo "Time: $(date)"
echo

# Fetch headers with timing
headers=$(curl -sI -w "\nHTTP_CODE: %{http_code}\nTIME_TOTAL: %{time_total}" "$URL")

http_code=$(echo "$headers" | grep "HTTP_CODE:" | cut -d' ' -f2)
response_time=$(echo "$headers" | grep "TIME_TOTAL:" | cut -d' ' -f2)

echo "Response Code: $http_code"
echo "Response Time: ${response_time}s"
echo

# Server info
echo "📡 Server Information:"
echo "$headers" | grep -i "^server:" || echo "   Not disclosed"
echo "$headers" | grep -i "^via:" || echo "   No proxy/Via header"
echo

# Security headers score
echo "🔒 Security Headers:"
security_headers=(
    "strict-transport-security:HSTS"
    "content-security-policy:CSP"
    "x-frame-options:Frame Options"
    "x-content-type-options:Content Type Options"
    "referrer-policy:Referrer Policy"
    "permissions-policy:Permissions Policy"
    "cross-origin-embedder-policy:COEP"
    "cross-origin-opener-policy:COOP"
)

score=0
total=${#security_headers[@]}

for header in "${security_headers[@]}"; do
    key="${header%%:*}"
    name="${header##*:}"
    if echo "$headers" | grep -qi "^$key:"; then
        echo "   ✅ $name"
        ((score++))
    else
        echo "   ❌ $name"
    fi
done

echo
printf "Security Score: %d/%d\n" "$score" "$total"
```

## CORS Debugging

```bash
# Check CORS headers for API endpoints
curl -sI -X OPTIONS -H "Origin: https://example.com" \
     -H "Access-Control-Request-Method: POST" \
     https://api.example.com/data

# Test with custom origin
curl -sI -H "Origin: https://trusted-site.com" https://api.example.com/data | grep -i "access-control-"
```

## Redirect Chain Analysis

```bash
# Trace redirect chain with details
curl -sIL https://bit.ly/3xyz | grep -E "HTTP|Location:"

# Show redirect timing
curl -sIL -w "\nTotal time: %{time_total}s\n" https://example.com
```

## Header Security Score Reference

| Header | Purpose | Risk if Missing |
|--------|---------|-----------------|
| HSTS | Force HTTPS | SSL stripping attacks |
| CSP | XSS protection | Code injection |
| X-Frame-Options | Clickjacking protection | UI redressing |
| X-Content-Type-Options | MIME sniffing prevention | Drive-by downloads |
| Referrer-Policy | Privacy control | Data leakage |

## Pricing

**$4 USD** - One-time purchase
- Complete security header audit
- Performance optimization guide
- CORS debugging tools
- Batch URL analysis scripts
