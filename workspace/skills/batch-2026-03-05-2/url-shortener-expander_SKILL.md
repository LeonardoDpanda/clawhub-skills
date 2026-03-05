---
name: url-shortener-expander
description: Shorten long URLs using popular services and expand shortened URLs to reveal their destinations. Use when sharing links in space-constrained contexts, checking where a short URL leads before clicking, cleaning up messy URLs, or tracking link metrics. NOT for masking malicious URLs or bypassing security filters.
---

# URL Shortener & Expander

Shorten long URLs and expand shortened ones to preview destinations before clicking.

## When to Use

- Sharing URLs in character-limited contexts (Twitter, SMS)
- Creating clean, memorable links for presentations
- Checking where a shortened URL actually leads
- Generating QR-friendly compact URLs
- Cleaning up tracking parameters from URLs
- Verifying link destinations for security

## When NOT to Use

- Masking phishing or malicious URLs
- Bypassing corporate security filters
- Circumventing paywalls
- Spam distribution
- Hiding affiliate links deceptively
- URLs that violate terms of service

## Quick Start

```bash
# Shorten a URL
url-tool shorten https://example.com/very/long/path/to/resource

# Expand a shortened URL
url-tool expand https://bit.ly/abc123

# Clean URL (remove tracking parameters)
url-tool clean "https://example.com?utm_source=email&utm_campaign=spring"

# Get URL info (expansion + metadata)
url-tool info https://tinyurl.com/xyz789
```

## URL Shortening

### Supported Services

| Service | Features | Rate Limit |
|---------|----------|------------|
| bit.ly | Custom aliases, analytics | 1000/month |
| tinyurl | No account needed | Unlimited |
| is.gd | Custom URLs, preview | 50/hour |
| v.gd | Short URLs | 50/hour |
| tny.im | Very short URLs | 100/hour |

### Basic Shortening

```bash
# Auto-select best service
url-tool shorten https://example.com/page

# Use specific service
url-tool shorten https://example.com/page --service bitly
url-tool shorten https://example.com/page --service tinyurl

# Custom alias (if supported)
url-tool shorten https://example.com/page --alias mylink
# Result: https://bit.ly/mylink
```

### Shortening with Options

```bash
# Add title/metadata
url-tool shorten https://example.com --title "Example Website"

# Generate QR code alongside
url-tool shorten https://example.com --qr --output qr.png

# Copy to clipboard
url-tool shorten https://example.com --clipboard

# Get JSON output
url-tool shorten https://example.com --json
```

## URL Expansion

### Basic Expansion

```bash
# Reveal destination URL
url-tool expand https://bit.ly/3xyzABC
# Output: https://example.com/actual/destination/page

# Expand without following redirects
url-tool expand https://bit.ly/3xyzABC --no-follow
```

### Batch Expansion

```bash
# Expand multiple URLs from file
url-tool expand --file urls.txt --output expanded.csv

# Expand from clipboard
url-tool expand --clipboard

# Process list inline
url-tool expand https://bit.ly/a https://t.co/b https://tinyurl.com/c
```

### Security Scanning

```bash
# Check if destination is safe
url-tool expand https://bit.ly/suspicious --check-safe

# Full security report
url-tool expand https://bit.ly/unknown --security-report

# Check against blocklists
url-tool expand https://bit.ly/link --check-blocklist
```

## URL Cleaning

Remove tracking parameters and clean URLs:

```bash
# Remove common tracking parameters
url-tool clean "https://example.com?utm_source=email&utm_medium=banner"
# Output: https://example.com

# Remove all query parameters
url-tool clean "https://example.com?a=1&b=2" --remove-all-params

# Keep specific parameters
url-tool clean "https://example.com?id=123&utm_source=email" --keep-params "id"

# Remove specific parameters only
url-tool clean "https://example.com?id=123&ref=email" --remove-params "ref,utm_source"
```

### Common Tracking Parameters Removed

- `utm_source`, `utm_medium`, `utm_campaign`, `utm_term`, `utm_content`
- `fbclid` (Facebook click ID)
- `gclid` (Google click ID)
- `ref`, `referrer`, `referral`
- `source`, `medium`

## URL Analysis

### Get URL Information

```bash
# Comprehensive URL info
url-tool info https://bit.ly/example

# Output includes:
# - Original URL
# - Expanded URL
# - Final destination (after all redirects)
# - HTTP status
# - Page title
# - Meta description
# - Security status
```

### Check URL Health

```bash
# Check if URL is accessible
url-tool check https://example.com

# Get HTTP headers
url-tool headers https://example.com

# Follow redirect chain
url-tool trace https://bit.ly/example
```

## Advanced Features

### Custom Short Domain

```bash
# Configure custom short domain (requires setup)
url-tool config --short-domain "go.mycompany.com"
url-tool shorten https://example.com --custom-domain
```

### URL Analytics

```bash
# Get click stats for shortened URL
url-tool stats https://bit.ly/mylink

# Output: clicks, referrers, countries, browsers
```

### Bulk Operations

```bash
# Shorten multiple URLs
url-tool shorten --file long_urls.txt --output short_urls.csv

# Process with custom template
url-tool shorten --file urls.txt --format "{{short}} -> {{original}}"
```

## Use Cases

### Social Media Sharing

```bash
# Shorten for Twitter (character limit)
url-tool shorten "https://myblog.com/very-long-post-title-here" --clipboard

# With tracking
url-tool shorten "https://myblog.com/post" --title "Blog Post" --service bitly
```

### Email Campaigns

```bash
# Clean tracking from received URLs before archiving
url-tool clean "$URL" --clipboard

# Verify links before forwarding
url-tool expand "$SHORT_URL" --check-safe
```

### Security Verification

```bash
# Check suspicious link
url-tool expand https://t.co/suspicious --security-report

# Batch check links from email
url-tool expand --file email_links.txt --check-safe --output report.csv
```

### Presentations & Documents

```bash
# Create memorable short link
url-tool shorten "https://docs.google.com/spreadsheets/d/very-long-id" \
  --alias q1-report --clipboard
```

## Output Formats

### JSON Output

```bash
url-tool shorten https://example.com --json
```

```json
{
  "success": true,
  "original_url": "https://example.com/path",
  "short_url": "https://bit.ly/3ABCxyz",
  "service": "bitly",
  "created_at": "2026-03-05T10:30:00Z",
  "qr_code": "https://api.qrserver.com/v1/..."
}
```

### CSV Output

```bash
url-tool expand --file urls.txt --csv
```

```csv
short_url,expanded_url,status,title
https://bit.ly/abc,https://example.com,200,Example Site
```

## Configuration

### API Keys

```bash
# Set Bitly API token
url-tool config --bitly-token YOUR_TOKEN

# Set custom service credentials
url-tool config --service custom --endpoint https://my.link/api
```

### Default Settings

```bash
# Set default shortening service
url-tool config --default-service is.gd

# Always copy to clipboard
url-tool config --auto-clipboard true

# Default to QR generation
url-tool config --auto-qr false
```

## Integration Examples

### Shell Function

```bash
# Add to .bashrc/.zshrc
shorten() { url-tool shorten "$1" --clipboard; }
expand() { url-tool expand "$1"; }
cleanurl() { url-tool clean "$1" --clipboard; }

# Usage
shorten "https://example.com/long-url"
expand "https://bit.ly/abc123"
```

### Clipboard Workflow

```bash
# Shorten URL in clipboard
pbpaste | xargs url-tool shorten --clipboard

# Clean URL in clipboard
pbpaste | xargs url-tool clean --clipboard
```

### Alfred Workflow Integration

```bash
# For macOS Alfred users
# Keyword: short {query}
# Script: url-tool shorten "{query}" --clipboard

# Keyword: expand {query}
# Script: url-tool expand "{query}" --clipboard
```

## Troubleshooting

### Rate Limit Errors

```bash
# Switch service when rate limited
url-tool shorten https://example.com --service tinyurl

# Use backup service list
url-tool shorten https://example.com --fallback
```

### Expansion Failures

```bash
# URL returns 404
url-tool expand https://bit.ly/expired --ignore-404

# Invalid short URL format
url-tool validate https://bit.ly/test
```

### Encoding Issues

```bash
# Handle URLs with special characters
url-tool shorten "https://example.com/search?q=hello world" --encode

# Decode encoded URLs
url-tool decode "https://example.com/search%3Fq%3Dhello%20world"
```

## Privacy & Security

### Data Handling

- Original URLs are processed but not stored
- Shortened URL mappings may be stored by third-party services
- No analytics or tracking by this tool
- HTTPS-only for all operations

### Security Best Practices

1. Always expand unknown short URLs before clicking
2. Use `--check-safe` for suspicious links
3. Be cautious with URL shorteners in sensitive contexts
4. Custom aliases may be guessable - use random strings for privacy

## Pricing

**$3 USD** - One-time purchase

Includes:
- Multiple shortening services
- URL expansion with safety checks
- URL cleaning (remove trackers)
- Batch operations
- JSON/CSV output
- Security scanning
- QR code generation

---

*Make links manageable, but stay safe.*
