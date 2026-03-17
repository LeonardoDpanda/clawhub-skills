---
name: cron-expression-parser
description: Parse, validate, and generate Cron expressions. Convert between cron syntax and human-readable descriptions, calculate next execution times, and generate cron schedules from natural language. Use when working with scheduled tasks, debugging cron jobs, or converting scheduling requirements.
---

# Cron Expression Parser

Work with Cron expressions to schedule tasks, validate syntax, and convert between formats.

## When to Use

- Converting human-readable schedules to cron syntax
- Understanding what an existing cron expression does
- Validating cron expression syntax
- Calculating next execution times
- Converting between cron variants (Linux, Quartz, AWS)

## When NOT to Use

- Modifying system crontabs (use crontab -e)
- Managing systemd timers (use systemctl)
- Complex scheduling logic (use workflow orchestrators)

## Cron Format Reference

```
┌───────────── minute (0 - 59)
│ ┌───────────── hour (0 - 23)
│ │ ┌───────────── day of month (1 - 31)
│ │ │ ┌───────────── month (1 - 12)
│ │ │ │ ┌───────────── day of week (0 - 6, Sun=0)
│ │ │ │ │
* * * * *
```

Special strings:
- `@yearly`   = `0 0 1 1 *`
- `@monthly`  = `0 0 1 * *`
- `@weekly`   = `0 0 * * 0`
- `@daily`    = `0 0 * * *`
- `@hourly`   = `0 * * * *`
- `@reboot`   = Run at startup

## Examples

### Parse Cron to Human Readable

```bash
#!/bin/bash
CRON="$1"

case "$CRON" in
    "0 0 * * *")
        echo "Daily at midnight"
        ;;
    "0 */6 * * *")
        echo "Every 6 hours"
        ;;
    "*/15 * * * *")
        echo "Every 15 minutes"
        ;;
    "0 9 * * 1")
        echo "Every Monday at 9:00 AM"
        ;;
    "0 0 1 * *")
        echo "First day of every month"
        ;;
    "0 2 * * 0")
        echo "Every Sunday at 2:00 AM"
        ;;
    *)
        echo "Custom schedule: $CRON"
        ;;
esac
```

### Generate Common Cron Expressions

```bash
#!/bin/bash
# Cron Expression Generator

generate_cron() {
    local schedule="$1"
    
    case "$schedule" in
        "every-minute")
            echo "* * * * *"
            ;;
        "every-5-minutes")
            echo "*/5 * * * *"
            ;;
        "every-15-minutes")
            echo "*/15 * * * *"
            ;;
        "every-30-minutes")
            echo "*/30 * * * *"
            ;;
        "hourly")
            echo "0 * * * *"
            ;;
        "every-6-hours")
            echo "0 */6 * * *"
            ;;
        "daily-midnight")
            echo "0 0 * * *"
            ;;
        "daily-noon")
            echo "0 12 * * *"
            ;;
        "weekly-monday")
            echo "0 9 * * 1"
            ;;
        "monthly")
            echo "0 0 1 * *"
            ;;
        "weekdays-9am")
            echo "0 9 * * 1-5"
            ;;
        *)
            echo "Unknown schedule: $schedule"
            return 1
            ;;
    esac
}

# Usage examples
echo "Every 5 minutes: $(generate_cron every-5-minutes)"
echo "Weekdays at 9 AM: $(generate_cron weekdays-9am)"
```

### Validate Cron Syntax

```bash
#!/bin/bash
validate_cron() {
    local cron="$1"
    
    # Basic pattern validation
    if [[ ! "$cron" =~ ^([0-9*,/-]+[[:space:]]+){4}[0-9*,/-]+$ ]]; then
        echo "❌ Invalid format"
        return 1
    fi
    
    # Extract fields
    IFS=' ' read -r min hour dom month dow <<< "$cron"
    
    # Validate each field
    validate_field() {
        local field="$1" name="$2" max="$3"
        
        # Check for valid characters only
        if [[ ! "$field" =~ ^[0-9*,/-]+$ ]]; then
            echo "❌ $name contains invalid characters"
            return 1
        fi
        
        # Check numeric ranges
        if [[ "$field" =~ ^[0-9]+$ ]]; then
            if (( field > max )); then
                echo "❌ $name value $field exceeds maximum $max"
                return 1
            fi
        fi
        
        echo "✅ $name valid"
    }
    
    validate_field "$min" "Minute" 59
    validate_field "$hour" "Hour" 23
    validate_field "$dom" "Day of Month" 31
    validate_field "$month" "Month" 12
    validate_field "$dow" "Day of Week" 7
    
    return 0
}

# Test
validate_cron "0 */6 * * *"
```

### Calculate Next Execution Time

```bash
#!/bin/bash
CRON="$1"

echo "Cron: $CRON"
echo "Next 5 executions:"

# Using Python for accurate calculation
python3 << PYTHON
cron = "$CRON"
from datetime import datetime, timedelta
import re

# Simple cron parser (simplified version)
def parse_cron(cron_str, start_time):
    parts = cron_str.split()
    if len(parts) != 5:
        return []
    
    minute, hour, dom, month, dow = parts
    
    # Generate next 5 occurrences (simplified)
    times = []
    current = start_time
    for _ in range(5):
        if minute == "0" and hour == "0":
            # Daily at midnight
            current = current.replace(hour=0, minute=0, second=0)
            if current <= start_time:
                current += timedelta(days=1)
        elif "/" in minute:
            # Every N minutes
            step = int(minute.split("/")[1])
            current = current + timedelta(minutes=step - (current.minute % step))
        times.append(current)
        current += timedelta(minutes=1)
    
    return times

now = datetime.now()
for t in parse_cron(cron, now):
    print(f"  {t.strftime('%Y-%m-%d %H:%M:%S')}")
PYTHON
```

## Common Cron Patterns

| Description | Cron Expression |
|-------------|-----------------|
| Every minute | `* * * * *` |
| Every 5 minutes | `*/5 * * * *` |
| Every hour | `0 * * * *` |
| Every day at midnight | `0 0 * * *` |
| Every Sunday | `0 0 * * 0` |
| Weekdays at 9 AM | `0 9 * * 1-5` |
| First of month | `0 0 1 * *` |
| Every quarter | `0 0 1 1,4,7,10 *` |

## Conversion Tools

### Natural Language to Cron

```bash
#!/bin/bash
convert_natural() {
    local input="$1"
    input=$(echo "$input" | tr '[:upper:]' '[:lower:]')
    
    case "$input" in
        *"every minute"*|*"every 1 minute"*)
            echo "* * * * *"
            ;;
        *"every 5 minutes"*|*"5 minutes"*)
            echo "*/5 * * * *"
            ;;
        *"every hour"*|*"hourly"*)
            echo "0 * * * *"
            ;;
        *"daily"*|*"every day"*)
            echo "0 0 * * *"
            ;;
        *"midnight"*)
            echo "0 0 * * *"
            ;;
        *"noon"*|*"12pm"*)
            echo "0 12 * * *"
            ;;
        *"weekly"*|*"every week"*)
            echo "0 0 * * 0"
            ;;
        *"monthly"*|*"every month"*)
            echo "0 0 1 * *"
            ;;
        *)
            echo "Could not parse: $input"
            return 1
            ;;
    esac
}

# Example usage
convert_natural "Run every 5 minutes"
```

## Pricing

**$3 USD** - One-time purchase
- Cron expression parser
- Human-readable converter
- Syntax validator
- Next execution calculator
- Natural language to cron conversion
