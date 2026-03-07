---
name: log-analyzer-pro
description: Analyze log files with intelligent pattern recognition, error clustering, and performance metrics extraction. Use when debugging issues, monitoring system health, or extracting insights from application logs. Supports real-time streaming and batch analysis of multiple log formats.
---

# Log Analyzer Pro

Professional log analysis tool for debugging, monitoring, and system optimization.

## When to Use

- Debugging production issues from logs
- Analyzing application performance trends
- Monitoring error rates and patterns
- Extracting metrics from log data
- Comparing logs across time periods
- Identifying security anomalies

## When NOT to Use

- Real-time log alerting (use monitoring tools)
- Log aggregation from multiple sources
- Long-term log storage
- Binary log analysis
- Encrypted log decryption

## Quick Start

### Basic Log Analysis

```bash
# Analyze single log file
log-analyzer-pro analyze app.log

# Real-time monitoring
log-analyzer-pro tail -f app.log

# Analyze last N lines
log-analyzer-pro analyze app.log --last 1000
```

### Error Analysis

```bash
# Extract and cluster errors
log-analyzer-pro errors app.log

# Show error trends
log-analyzer-pro errors app.log --trend --interval 1h

# Compare with previous period
log-analyzer-pro errors app.log --compare yesterday
```

### Performance Metrics

```bash
# Extract response times
log-analyzer-pro metrics app.log --pattern "response_time=(\\d+)"

# Generate latency percentiles
log-analyzer-pro latency app.log --field duration
```

## Advanced Usage

### Pattern Recognition

```bash
# Define custom patterns
log-analyzer-pro analyze app.log \
  --pattern "ERROR" --pattern "CRITICAL" \
  --pattern "Exception:" \
  --output errors.json

# Regex patterns
log-analyzer-pro analyze app.log \
  --regex "\\[ERROR\\].*?(?=\\[|$)" \
  --context 3
```

### Multi-file Analysis

```bash
# Analyze all logs in directory
log-analyzer-pro analyze ./logs/*.log --aggregate

# Compare logs from different servers
log-analyzer-pro compare server1.log server2.log --metric error_rate
```

### Time-based Filtering

```bash
# Analyze specific time range
log-analyzer-pro analyze app.log \
  --from "2024-01-15 09:00:00" \
  --to "2024-01-15 10:00:00"

# Relative time
log-analyzer-pro analyze app.log --last 1h
log-analyzer-pro analyze app.log --today
```

## Supported Log Formats

### Common Formats (Auto-detected)

```
# Apache/Nginx
192.168.1.1 - - [15/Jan/2024:10:30:00 +0000] "GET /api/users HTTP/1.1" 200 1234

# JSON
{"timestamp":"2024-01-15T10:30:00Z","level":"ERROR","message":"Connection failed"}

# Syslog
Jan 15 10:30:00 server app[1234]: Error processing request

# Custom
[2024-01-15 10:30:00] [ERROR] [module] Error message here
```

## Analysis Types

### Error Clustering

```bash
# Group similar errors
log-analyzer-pro cluster app.log --field message

# Output:
# Cluster 1 (45 occurrences): Connection timeout
# Cluster 2 (23 occurrences): Database error
# Cluster 3 (12 occurrences): Authentication failed
```

### Timeline Analysis

```bash
# Generate timeline of events
log-analyzer-pro timeline app.log --granularity 5m

# Visual output
# 09:00 ████████ 45 req/s
# 09:05 ████████████ 78 req/s  ⚠️ spike
# 09:10 ██████ 32 req/s
```

### Performance Analysis

```bash
# Response time analysis
log-analyzer-pro perf app.log \
  --field response_time \
  --percentiles 50,95,99 \
  --threshold 1000

# Output:
# p50: 45ms
# p95: 230ms ⚠️
# p99: 1200ms 🔴
```

## Output Formats

```bash
# JSON for programmatic use
log-analyzer-pro analyze app.log --format json

# CSV for spreadsheets
log-analyzer-pro metrics app.log --format csv

# HTML report
log-analyzer-pro analyze app.log --report --output report.html

# Markdown summary
log-analyzer-pro analyze app.log --summary --format md
```

## Real-time Monitoring

```bash
# Live error monitoring
log-analyzer-pro watch app.log --alert-on ERROR

# Performance monitoring
log-analyzer-pro watch app.log \
  --metric "response_time>1000" \
  --alert-threshold 10

# Dashboard mode
log-analyzer-pro dashboard --logs "./logs/*.log"
```

## Configuration

### .log-analyzer.json

```json
{
  "patterns": {
    "error": "ERROR|CRITICAL|FATAL",
    "warning": "WARN|WARNING",
    "request": "REQUEST|GET|POST|PUT|DELETE"
  },
  "fields": {
    "timestamp": "\\[(\\d{4}-\\d{2}-\\d{2}[^\\]]+)\\]",
    "level": "\\[(ERROR|WARN|INFO|DEBUG)\\]",
    "message": "message['\"]?:\\s*['\"]?([^'\"\\n]+)"
  },
  "alerts": {
    "error_rate": { "threshold": 5, "window": "5m" },
    "response_time": { "threshold": 1000, "percentile": 95 }
  }
}
```

## Use Cases

### Production Debugging

```bash
# Find root cause of outage
log-analyzer-pro analyze app.log \
  --from "2024-01-15 14:00:00" \
  --to "2024-01-15 14:30:00" \
  --errors --context 5
```

### Performance Optimization

```bash
# Identify slow endpoints
log-analyzer-pro perf access.log \
  --group-by endpoint \
  --sort-by p95 \
  --limit 10
```

### Security Audit

```bash
# Detect suspicious patterns
log-analyzer-pro analyze access.log \
  --pattern "404" \
  --pattern "failed" \
  --pattern "unauthorized" \
  --group-by ip
```

## CI/CD Integration

```yaml
# GitHub Actions: Performance regression check
- name: Analyze Logs
  run: |
    log-analyzer-pro perf app.log \
      --baseline baseline.json \
      --fail-on-regression 10%
```