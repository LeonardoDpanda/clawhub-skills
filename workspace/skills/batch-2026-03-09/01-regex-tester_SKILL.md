---
name: regex-tester
description: Test and validate regular expressions with real-time matching, capture groups visualization, and common pattern library. Use when users need to test regex patterns, debug matching issues, extract data with capture groups, or find commonly used regex patterns for emails, phone numbers, URLs, etc.
---

# Regex Tester

Test, debug, and validate regular expressions with visual feedback and practical examples.

## When to Use

- Testing regex patterns before using in code
- Debugging why a pattern doesn't match
- Extracting data using capture groups
- Finding common patterns for validation
- Learning regex syntax with examples

## When NOT to Use

- For complex parsing (use proper parsers for HTML/XML/JSON)
- When performance is critical (test in your target language)

## Usage Examples

### Basic Pattern Testing

```bash
# Test email pattern
echo "user@example.com" | python3 -c "
import re
import sys
pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
text = sys.stdin.read().strip()
match = re.match(pattern, text)
print('✅ Match!' if match else '❌ No match')
"
```

### Extract Capture Groups

```bash
# Extract domain from email
echo "contact@company.org" | python3 -c "
import re
import sys
text = sys.stdin.read().strip()
pattern = r'^(\w+)@([\w.]+)$'
match = re.match(pattern, text)
if match:
    print(f'User: {match.group(1)}')
    print(f'Domain: {match.group(2)}')
"
```

### Find All Matches

```bash
# Extract all URLs from text
echo "Visit https://example.com and http://test.org" | python3 -c "
import re
import sys
text = sys.stdin.read()
urls = re.findall(r'https?://[^\s<>\"{}|\\^`[\]]+', text)
for url in urls:
    print(f'Found: {url}')
"
```

### Replace with Regex

```bash
# Redact phone numbers
echo "Call me at 138-1234-5678" | python3 -c "
import re
import sys
text = sys.stdin.read()
result = re.sub(r'\d{3}-\d{4}-\d{4}', '[REDACTED]', text)
print(result)
"
```

## Common Patterns Library

| Pattern | Regex | Example Match |
|---------|-------|---------------|
| Email | `^[\w._%+-]+@[\w.-]+\.[A-Za-z]{2,}$` | user@domain.com |
| Phone (CN) | `^1[3-9]\d{9}$` | 13812345678 |
| URL | `^https?://[^\s<>\"{}|\\^\`[\]]+$` | https://site.com |
| IP Address | `^(?:(?:25[0-5]\|2[0-4]\d\|[01]?\d\d?)\.){3}` | 192.168.1.1 |
| Date (YYYY-MM-DD) | `^\d{4}-(?:0[1-9]\|1[0-2])-(?:0[1-9]\|[12]\d\|3[01])$` | 2024-03-15 |
| Credit Card | `^\d{4}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}$` | 1234 5678 9012 3456 |

## Flags Reference

| Flag | Description | Example |
|------|-------------|---------|
| `i` | Case-insensitive | `(?i)hello` matches HELLO |
| `m` | Multiline | `^` matches line start |
| `s` | Dot matches newline | `.` includes `\n` |
| `g` | Global (find all) | `re.findall()` |

## Tips

- Use raw strings `r'pattern'` to avoid escaping issues
- Test with edge cases: empty strings, special characters
- For complex patterns, use `re.VERBOSE` with comments
- Validate user input before applying regex
