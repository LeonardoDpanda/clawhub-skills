---
name: url-encoder
description: Encode and decode URLs, query parameters, base64 strings, HTML entities, and perform URL parsing/analysis. Use when preparing URLs for APIs, decoding encoded strings, parsing URL components, handling special characters in web addresses, or debugging URL-related issues. NOT for URL shortening, malicious URL analysis, or bypassing security filters.
---

# URL Encoder/Decoder

Complete URL encoding, decoding, and parsing utility for web development.

## When to Use

- Preparing URLs with special characters for APIs
- Decoding encoded URL parameters
- Parsing URL components (domain, path, query)
- Handling non-ASCII characters in URLs
- Encoding form data for HTTP requests
- Decoding base64 in URLs
- Debugging URL-related issues

## When NOT to Use

- **DO NOT** use for URL shortening (use bit.ly, TinyURL)
- **DO NOT** use for malicious URL analysis (use security tools)
- **DO NOT** use for bypassing security filters or WAF
- **DO NOT** use for crawling websites (use scrapers)
- **DO NOT** use for SEO analysis (use SEO tools)

## Usage Examples

### URL Encode
```
Encode: https://example.com/search?q=hello world&category=books & more
```

Output:
```
🔏 URL Encoded

Original: https://example.com/search?q=hello world&category=books & more
Encoded:  https://example.com/search?q=hello%20world&category=books%20%26%20more

Components:
- Scheme: https
- Host: example.com
- Path: /search
- Query: q=hello%20world&category=books%20%26%20more

Encoding Applied:
- Space → %20
- & → %26 (in value)
```

### URL Decode
```
Decode: https%3A%2F%2Fexample.com%2Fpath%3Fkey%3Dvalue%2520test
```

Output:
```
🔓 URL Decoded

Encoded:   https%3A%2F%2Fexample.com%2Fpath%3Fkey%3Dvalue%2520test
Decoded:   https://example.com/path?key=value%20test

Note: Double-encoded %2520 detected
Fully decoded: https://example.com/path?key=value test
```

### Query String Encode
```
Encode query params:
name=John Doe
email=john@example.com
message=Hello & Welcome!
```

Output:
```
🔏 Query String Encoded

name=John%20Doe&email=john%40example.com&message=Hello%20%26%20Welcome%21

Parsed Parameters:
- name: John Doe
- email: john@example.com
- message: Hello & Welcome!
```

### URL Parse
```
Parse: https://user:pass@api.example.com:8080/v1/users?id=123&expand=true#profile
```

Output:
```
🔗 URL Components

┌─ General ──────────────┐
Href:     https://user:pass@api.example.com:8080/v1/users?id=123&expand=true#profile
Protocol: https:
Origin:   https://api.example.com:8080

┌─ Authentication ───────┐
Username: user
Password: pass

┌─ Host ─────────────────┐
Hostname: api.example.com
Port:     8080

┌─ Path ─────────────────┐
Pathname: /v1/users
Path segments: ["v1", "users"]

┌─ Query ────────────────┐
Search:   ?id=123&expand=true
Query string:
- id: 123
- expand: true

┌─ Fragment ─────────────┐
Hash:     #profile
Fragment: profile
```

### Base64 URL Encoding
```
Base64 URL encode: {"user": "admin", "role": "editor"}
```

### HTML Entity Encode/Decode
```
HTML encode: <div class="test">Hello & Welcome</div>
```

## Encoding Types

### Percent Encoding (URL)
```
Encode for URL: special chars
Rules:
- A-Z, a-z, 0-9, -_.~ remain unchanged
- Space → %20 (or + in query strings)
- Other chars → %XX hex

Examples:
- @ → %40
- # → %23
- / → %2F
- 中 → %E4%B8%AD (UTF-8)
```

### Base64 URL-Safe
```
Standard Base64:    a+b/c==
URL-Safe Base64:    a-b_c
(Replaces + → -, / → _, removes =)
```

### Form Encoding
```
application/x-www-form-urlencoded:
- Space → +
- Special chars → %XX
- Key=value pairs joined with &
```

## Batch Operations

```
Encode multiple URLs from file:
Encode each line in urls.txt
```

```
Decode query parameters from curl command:
Decode: curl "https://api.example.com?data=eyJ1c2VyIjoiYWRtaW4ifQ%3D%3D"
```

## URL Validation

```
Validate URL: https://example.com/path
```

Output:
```
✅ Valid URL

Format:     Well-formed
Resolvable: Yes (DNS check)
Reachable:  Yes (HTTP 200)
HTTPS:      Yes (TLS 1.3)
Certificate: Valid
Expires:    2026-12-31
```

## Common Patterns

### API Request Preparation
```
Prepare API URL:
Base: https://api.example.com/v1
Path: /users/search
Params:
  - q: hello world
  - limit: 10
  - sort: created_at desc

Result: https://api.example.com/v1/users/search?q=hello%20world&limit=10&sort=created_at%20desc
```

### OAuth URL Construction
```
Build OAuth authorization URL:
- endpoint: https://auth.example.com/authorize
- client_id: my_app
- redirect_uri: https://myapp.com/callback
- scope: read write
- state: abc123

Encoded: https://auth.example.com/authorize?client_id=my_app&redirect_uri=https%3A%2F%2Fmyapp.com%2Fcallback&scope=read%20write&state=abc123
```

### Debugging Encoded URLs
```
Debug this URL:
https://example.com?data=eyJ1c2VyIjp7Im5hbWUiOiJKb2huIiwiYWdlIjozMH19

Analysis:
- Detected base64-encoded parameter
- Decoded: {"user":{"name":"John","age":30}}
- Structure: Valid JSON object
```

## Special Character Reference

| Char | URL Encoded | Notes |
|------|-------------|-------|
| space | %20 or + | %20 in path, + in query |
| ! | %21 | |
| # | %23 | fragment delimiter |
| $ | %24 | |
| % | %25 | must encode itself |
| & | %26 | query delimiter |
| ' | %27 | |
| ( | %28 | |
| ) | %29 | |
| * | %2A | unencoded in some cases |
| + | %2B | space in form encoding |
| , | %2C | |
| / | %2F | path delimiter |
| : | %3A | |
| ; | %3B | |
| = | %3D | key-value delimiter |
| ? | %3F | query start |
| @ | %40 | auth delimiter |
| [ | %5B | |
| ] | %5D | |
