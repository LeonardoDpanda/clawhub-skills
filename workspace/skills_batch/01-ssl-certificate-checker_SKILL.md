---
name: ssl-certificate-checker
description: Check SSL/TLS certificate details including expiration date, issuer, validity, cipher suites, and security warnings for any domain. Use when verifying HTTPS security, monitoring certificate expiry, or troubleshooting SSL issues.
---

# SSL Certificate Checker

Analyze SSL/TLS certificates for any domain to verify security configuration and monitor expiration.

## When to Use

- Checking SSL certificate expiration dates
- Verifying certificate chain and issuer
- Troubleshooting HTTPS connection issues
- Auditing website security configuration
- Monitoring certificates before renewal

## When NOT to Use

- Penetration testing (this is read-only)
- Internal network certificates (use dedicated tools)
- Certificate installation (this only checks, doesn't install)

## Examples

### Basic Certificate Check

```bash
# Check certificate for a domain
openssl s_client -connect example.com:443 -servername example.com </dev/null 2>/dev/null | openssl x509 -noout -dates -subject -issuer

# Get detailed certificate information
echo | openssl s_client -connect example.com:443 -servername example.com 2>/dev/null | openssl x509 -noout -text
```

### Check Certificate Expiration

```bash
# Extract expiration date
echo | openssl s_client -connect example.com:443 -servername example.com 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f2

# Calculate days until expiry
expiry_date=$(echo | openssl s_client -connect example.com:443 -servername example.com 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f2)
expiry_epoch=$(date -d "$expiry_date" +%s 2>/dev/null || date -j -f "%b %d %H:%M:%S %Y %Z" "$expiry_date" +%s)
now_epoch=$(date +%s)
days_left=$(( (expiry_epoch - now_epoch) / 86400 ))
echo "Certificate expires in $days_left days"
```

### Full Security Report

```bash
#!/bin/bash
DOMAIN="$1"
if [ -z "$DOMAIN" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

echo "=== SSL Certificate Report for $DOMAIN ==="
echo

# Get certificate details
cert_info=$(echo | openssl s_client -connect "$DOMAIN:443" -servername "$DOMAIN" 2>/dev/null)

echo "Subject:"
echo "$cert_info" | openssl x509 -noout -subject 2>/dev/null | sed 's/subject= //'

echo
echo "Issuer:"
echo "$cert_info" | openssl x509 -noout -issuer 2>/dev/null | sed 's/issuer= //'

echo
echo "Validity:"
echo "$cert_info" | openssl x509 -noout -dates 2>/dev/null

echo
echo "Serial Number:"
echo "$cert_info" | openssl x509 -noout -serial 2>/dev/null | cut -d= -f2

echo
echo "SHA-256 Fingerprint:"
echo "$cert_info" | openssl x509 -noout -fingerprint -sha256 2>/dev/null | cut -d= -f2

echo
echo "Supported Cipher Suites:"
echo | openssl s_client -connect "$DOMAIN:443" -servername "$DOMAIN" 2>/dev/null | grep "Cipher    :"
```

### Batch Check Multiple Domains

```bash
# Check certificates for multiple domains
domains=("google.com" "github.com" "example.com")

for domain in "${domains[@]}"; do
    echo "Checking $domain..."
    expiry=$(echo | openssl s_client -connect "$domain:443" -servername "$domain" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
    if [ -n "$expiry" ]; then
        echo "  Expires: $expiry"
    else
        echo "  Failed to retrieve certificate"
    fi
done
```

## Security Checks

### Verify Certificate Chain

```bash
# Show complete certificate chain
echo | openssl s_client -connect example.com:443 -servername example.com -showcerts 2>/dev/null | grep -E "s:|i:"

# Verify certificate against CA bundle
openssl s_client -connect example.com:443 -servername example.com -CAfile /etc/ssl/certs/ca-certificates.crt 2>/dev/null | grep "Verify return code"
```

### Check TLS Version Support

```bash
# Test TLS 1.3 support
openssl s_client -connect example.com:443 -tls1_3 2>/dev/null | grep "Protocol"

# Test TLS 1.2 support
openssl s_client -connect example.com:443 -tls1_2 2>/dev/null | grep "Protocol"

# List supported protocols
for version in tls1 tls1_1 tls1_2 tls1_3; do
    result=$(echo | timeout 5 openssl s_client -connect example.com:443 -"$version" 2>/dev/null | grep "Protocol" || echo "Not supported")
    echo "$version: $result"
done
```

## Common Warnings

| Issue | Detection | Risk Level |
|-------|-----------|------------|
| Expiring < 30 days | Check notAfter date | 🔴 High |
| Self-signed | Issuer = Subject | 🟡 Medium |
| Weak signature (SHA1) | signatureAlgorithm | 🔴 High |
| Missing intermediate | Chain verification fails | 🟡 Medium |

## Pricing

**$5 USD** - One-time purchase
- Complete certificate analysis
- Expiration monitoring scripts
- Security check automation
- Batch domain checking
