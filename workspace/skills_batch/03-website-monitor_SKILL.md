---
name: website-monitor
description: Monitor website uptime, performance, and SSL certificate status with configurable alerts via email, Slack, Discord, or webhook. Use when ensuring service availability, tracking response times, detecting outages, or monitoring certificate expiration for production websites and APIs.
---

# Website Monitor

Comprehensive website monitoring with uptime checks, performance tracking, SSL certificate monitoring, and multi-channel alerting.

## When to Use

- Monitoring production websites and APIs
- Tracking response times and availability
- SSL certificate expiration alerts
- Detecting outages before customers do
- SLA compliance monitoring
- Multi-region availability checks

## When NOT to Use

- Load testing (use dedicated tools like k6)
- Security vulnerability scanning
- Content compliance checking
- Single-page app (SPA) functionality testing

## Quick Start

### Basic Uptime Check

```bash
# Check once
website-check https://example.com

# Monitor continuously
website-monitor https://example.com --interval 60
```

### Add Alert Channels

```bash
# Slack notifications
website-monitor https://api.example.com \
  --interval 300 \
  --alert slack \
  --slack-webhook https://hooks.slack.com/services/...

# Email alerts
website-monitor https://example.com \
  --alert email \
  --email-to ops@example.com

# Multiple channels
website-monitor https://example.com \
  --alert slack,email,webhook \
  --webhook-url https://your-service.com/alerts
```

## Core Features

### Uptime Monitoring

```bash
# Simple HTTP/HTTPS check
website-monitor https://example.com

# Check specific status code
website-monitor https://api.example.com/health \
  --expect-status 200

# Check response content
website-monitor https://example.com \
  --expect-content "Welcome" \
  --timeout 10
```

### Performance Tracking

```bash
# Track response time with thresholds
website-monitor https://example.com \
  --warn-response-time 1000 \
  --critical-response-time 3000

# Full performance metrics
website-check --metrics https://example.com
# Output: DNS: 45ms, Connect: 120ms, TTFB: 230ms, Total: 520ms
```

### SSL Certificate Monitoring

```bash
# Check certificate expiration
website-monitor https://example.com \
  --check-ssl \
  --ssl-warning-days 30 \
  --ssl-critical-days 7

# SSL details
website-check --ssl-details https://example.com
# Output: Issuer, Expiry, SANs, Cipher, Protocol
```

## Configuration File

Create `website-monitor.json`:

```json
{
  "sites": [
    {
      "name": "Production API",
      "url": "https://api.example.com/health",
      "interval": 60,
      "timeout": 10,
      "expectStatus": 200,
      "alerts": {
        "slack": {
          "webhook": "https://hooks.slack.com/services/..."
        },
        "email": {
          "to": ["ops@example.com"],
          "from": "monitor@example.com"
        }
      },
      "thresholds": {
        "responseTime": {
          "warn": 1000,
          "critical": 3000
        }
      }
    },
    {
      "name": "Main Website",
      "url": "https://example.com",
      "interval": 300,
      "checkSsl": true,
      "sslWarningDays": 14
    }
  ]
}
```

Run with config:
```bash
website-monitor --config website-monitor.json
```

## Alert Templates

### Slack Message Format

```
🚨 Website Alert: Production API

Status: DOWN
URL: https://api.example.com/health
Error: HTTP 503 Service Unavailable
Response Time: 5234ms
Checked from: us-east-1
Time: 2026-03-04 14:32:05 UTC

Previous status: UP (2 hours ago)
```

### Email Alert

Subject: `[CRITICAL] example.com is DOWN`

```
Monitoring Alert - CRITICAL

Website: example.com
Status: DOWN ❌
Detected at: 2026-03-04 14:32:05 UTC
Duration: 5 minutes

Error Details:
- Type: Connection Timeout
- URL: https://example.com
- Response Time: 30.2s (timeout)

SSL Certificate:
- Status: Valid ✓
- Expires: 2026-06-15 (103 days)

Last Successful Check: 2026-03-04 14:27:05 UTC
```

## Advanced Usage

### Multi-Region Monitoring

```bash
# Check from multiple locations
website-monitor https://example.com \
  --regions us-east,us-west,eu-west,ap-south \
  --region-fail-threshold 2
```

### API Endpoint Testing

```bash
# POST with body
website-monitor https://api.example.com/webhook \
  --method POST \
  --header "Authorization: Bearer token" \
  --header "Content-Type: application/json" \
  --body '{"test": true}' \
  --expect-status 201
```

### Scheduled Maintenance Windows

```json
{
  "maintenance": {
    "schedule": "0 2 * * SUN",
    "duration": 30,
    "timezone": "UTC"
  }
}
```

### Alert Routing Rules

```json
{
  "alertRules": [
    {
      "condition": "status == 'down' && duration > 5min",
      "channels": ["slack", "pagerduty"],
      "escalateAfter": 15
    },
    {
      "condition": "sslDays < 7",
      "channels": ["email"],
      "severity": "warning"
    }
  ]
}
```

## Status Dashboard

Generate a status page:

```bash
# Create HTML status page
website-monitor --config sites.json --export-dashboard ./status.html

# JSON API for external dashboards
website-monitor --config sites.json --api-port 8080
# Endpoint: GET http://localhost:8080/status
```

## CLI Reference

```
website-monitor [url] [options]

Options:
  -c, --config <file>      Configuration file
  -i, --interval <sec>     Check interval (default: 300)
  -t, --timeout <sec>      Request timeout (default: 30)
  --method <method>        HTTP method (default: GET)
  -H, --header <header>    Add request header
  -b, --body <data>        Request body
  --expect-status <code>   Expected HTTP status
  --expect-content <text>  Expected response content
  -a, --alert <channels>   Alert channels (slack,email,webhook)
  --slack-webhook <url>    Slack webhook URL
  --email-to <address>     Email recipient
  --webhook-url <url>      Custom webhook URL
  --check-ssl              Monitor SSL certificate
  --ssl-warning-days <n>   SSL warning threshold
  --ssl-critical-days <n>  SSL critical threshold
  --regions <list>         Check from multiple regions
  --export-dashboard       Generate status page
  --api-port <port>        Run status API server

Examples:
  website-monitor https://example.com --interval 60
  website-monitor --config production-sites.json
  website-check --ssl-details https://example.com
```

## Best Practices

1. **Health Endpoints**: Use dedicated /health endpoints for APIs
2. **Interval Tuning**: Production: 60s, Secondary: 300s, Certificates: daily
3. **Alert Fatigue**: Set escalation rules, avoid alerting on brief blips
4. **Redundant Checks**: Monitor from multiple regions for critical services
5. **Runbook Links**: Include troubleshooting links in alert messages
