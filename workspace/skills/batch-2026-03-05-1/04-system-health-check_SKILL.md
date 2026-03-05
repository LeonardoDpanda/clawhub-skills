---
name: system-health-check
description: Monitor system health metrics including CPU, memory, disk usage, network connectivity, running processes, and service status. Use when diagnosing performance issues, checking resource utilization, verifying system availability, or performing routine maintenance checks. NOT for remote server monitoring, security penetration testing, or detailed application profiling.
---

# System Health Check

Comprehensive local system monitoring and diagnostics tool.

## When to Use

- Diagnosing slow performance or high resource usage
- Checking disk space before large operations
- Monitoring CPU and memory consumption
- Verifying network connectivity
- Checking running processes
- Validating service status
- Routine system maintenance checks

## When NOT to Use

- **DO NOT** use for remote server monitoring (use specialized monitoring tools)
- **DO NOT** use for security penetration testing
- **DO NOT** use for detailed application profiling (use profilers)
- **DO NOT** use for log analysis (use log aggregators)
- **DO NOT** use for historical trending (use monitoring systems)

## Usage Examples

### Quick System Overview
```
Check system health
```

Output:
```
🖥️ System Health Report
Generated: 2026-03-05 14:30:23 CST
Hostname: workstation
Uptime: 5 days, 3 hours, 22 minutes

┌─ CPU ─────────────────────────┐
Usage: 23% ▓▓▓░░░░░░░░░░░░░░░░
Cores: 8 (4 physical, 8 logical)
Load Average: 1.2, 0.9, 0.8
Temperature: 52°C (normal)

┌─ Memory ──────────────────────┐
Total: 32 GB
Used: 12.4 GB (39%)
Available: 19.6 GB (61%)
Cached: 4.2 GB

┌─ Disk ────────────────────────┐
/          : 45% used (234G/512G) ✅
/home      : 62% used (310G/500G) ⚠️
/tmp       : 12% used (12G/100G)  ✅

┌─ Network ─────────────────────┐
Status: Connected ✅
Primary: eth0 (192.168.1.105)
External IP: 203.0.113.45
DNS: Reachable ✅
Gateway: Reachable ✅
Internet: Connected ✅ (latency: 12ms)

Overall Status: ✅ Healthy
```

### Detailed CPU Analysis
```
Check CPU usage details
```

### Memory Analysis
```
Check memory usage with top processes
```

Output:
```
🧠 Memory Analysis

Top Memory Consumers:
1. chrome        2.4 GB  (7.5%)  [browser]
2. node          1.8 GB  (5.6%)  [javascript runtime]
3. python        890 MB  (2.8%)  [data processing]
4. dockerd       756 MB  (2.4%)  [container runtime]
5. code          645 MB  (2.0%)  [vscode]

Memory Pressure: Low
Swap Usage: 0 MB / 16 GB
OOM Risk: None
```

### Disk Analysis
```
Check disk usage with large files
```

### Network Diagnostics
```
Check network connectivity
```

Output:
```
🌐 Network Diagnostics

Interface Status:
- eth0: UP ✅ (1 Gbps, full duplex)
- wlan0: DOWN
- lo: UP ✅ (loopback)

Connectivity Tests:
- Local gateway (192.168.1.1): ✅ 1ms
- DNS (8.8.8.8): ✅ 12ms
- Internet (1.1.1.1): ✅ 15ms
- github.com: ✅ 45ms

Public IP: 203.0.113.45
Location: Shanghai, CN
ISP: China Telecom
```

### Process Check
```
Check running processes matching "node"
```

### Service Status
```
Check services: ssh, docker, nginx
```

## Detailed Checks

### CPU Deep Dive
```
Analyze CPU with options:
- Per-core breakdown
- Top processes by CPU
- CPU frequency scaling
- Thermal throttling status
- Context switches/sec
```

### Storage Analysis
```
Analyze storage:
- Disk usage by directory
- Largest files (top 20)
- Old files (>1 year)
- Temporary files cleanup
- Inode usage
```

### Network Deep Dive
```
Network analysis:
- Active connections
- Bandwidth usage
- Interface statistics
- Routing table
- Open ports
- Connection states
```

## Health Thresholds

| Metric | Warning | Critical |
|--------|---------|----------|
| CPU Usage | >70% | >90% |
| Memory Usage | >75% | >90% |
| Disk Usage | >80% | >95% |
| Load Average | >cores×0.7 | >cores |
| Temperature | >70°C | >85°C |

## Alert Levels

```
✅ Healthy - All metrics normal
⚠️ Warning - One or more metrics approaching limits
❌ Critical - Immediate attention required
```

## Actionable Recommendations

```
System Health Recommendations:

⚠️ Disk /home at 87% capacity
  → Consider cleaning large files
  → Top directories:
     - ~/Downloads: 45 GB
     - ~/.cache: 12 GB
     - ~/Projects: 89 GB

✅ Memory usage healthy at 45%
✅ CPU load normal
✅ Network connectivity good

Recommended Actions:
1. Run 'clean Downloads folder' or archive old files
2. Clear package cache: apt clean
3. Review Docker images: docker system prune
```

## Export Options

```
Save health report:
- To file: Save report to system_health_2026-03-05.txt
- JSON: Export as JSON for parsing
- Summary: One-line status for scripts
```

## Scheduled Monitoring

```
Quick check for automation:
- Exit code 0: All healthy
- Exit code 1: Warning
- Exit code 2: Critical
```

## Common Patterns

### Pre-Update Check
```
Before system update, check:
1. Disk space > 5GB free
2. No critical processes running
3. System load < 50%
```

### Troubleshooting Performance
```
Diagnose slow system:
1. Check CPU for high usage
2. Check memory for pressure
3. Check disk for full partition
4. Check top processes
5. Check for swap thrashing
```

### Health History
```
Compare with previous:
- Show trend over last 7 days
- Highlight significant changes
- Identify patterns
```
