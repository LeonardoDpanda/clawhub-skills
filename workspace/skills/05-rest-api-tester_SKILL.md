---
name: rest-api-tester
description: Test REST APIs with customizable headers, authentication, request bodies, and response validation. Use when debugging API endpoints, testing authentication flows, validating response schemas, automating API checks, or documenting API behavior with examples.
---

# REST API Tester

Complete REST API testing tool supporting all HTTP methods, authentication, custom headers, request bodies, response validation, and automated test suites.

## When to Use

- Debugging API endpoints during development
- Testing authentication and authorization flows
- Validating API response schemas
- Automating API health checks
- Documenting API behavior with examples
- Load testing preparation
- Webhook testing

## When NOT to Use

- GraphQL APIs (use GraphQL-specific tools)
- gRPC services
- WebSocket testing
- Performance/load testing at scale
- SOAP services

## Quick Start

### Simple GET Request

```bash
# Basic GET
api-test GET https://api.example.com/users

# With query parameters
api-test GET https://api.example.com/users?page=1&limit=10
```

### POST with JSON Body

```bash
api-test POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name": "Alice", "email": "alice@example.com"}'
```

### Authentication

```bash
# Bearer token
api-test GET https://api.example.com/protected \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIs..."

# Basic auth
api-test GET https://api.example.com/admin \
  --basic user:password

# API key
api-test GET https://api.example.com/data \
  -H "X-API-Key: your-api-key"
```

## HTTP Methods

All standard methods supported:

```bash
# GET - Retrieve data
api-test GET https://api.example.com/items

# POST - Create resource
api-test POST https://api.example.com/items \
  -d '{"name": "New Item"}'

# PUT - Full update
api-test PUT https://api.example.com/items/123 \
  -d '{"name": "Updated Item", "status": "active"}'

# PATCH - Partial update
api-test PATCH https://api.example.com/items/123 \
  -d '{"status": "inactive"}'

# DELETE - Remove resource
api-test DELETE https://api.example.com/items/123

# HEAD - Headers only
api-test HEAD https://api.example.com/items

# OPTIONS - CORS check
api-test OPTIONS https://api.example.com/items
```

## Request Options

### Headers

```bash
# Single header
api-test GET https://api.example.com/data \
  -H "Accept: application/json"

# Multiple headers
api-test POST https://api.example.com/upload \
  -H "Content-Type: multipart/form-data" \
  -H "X-Request-ID: 12345" \
  -H "X-Client-Version: 2.0"
```

### Request Body

```bash
# JSON
api-test POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name": "Bob"}'

# From file
api-test POST https://api.example.com/import \
  -H "Content-Type: application/json" \
  -d @payload.json

# Form data
api-test POST https://api.example.com/form \
  -F "name=Alice" \
  -F "avatar=@photo.jpg"

# Raw text
api-test POST https://api.example.com/webhook \
  -H "Content-Type: text/plain" \
  -d "raw payload"
```

### Query Parameters

```bash
# Inline in URL
api-test GET "https://api.example.com/search?q=test&limit=10"

# As separate arguments
api-test GET https://api.example.com/search \
  -q "q=test" \
  -q "limit=10" \
  -q "sort=desc"
```

## Response Handling

### View Options

```bash
# Full response (default)
api-test GET https://api.example.com/users

# Headers only
api-test GET https://api.example.com/users --headers-only

# Body only
api-test GET https://api.example.com/users --body-only

# Status only
api-test GET https://api.example.com/users --status-only
```

### Pretty Print

```bash
# Format JSON response
api-test GET https://api.example.com/users --pretty

# Show response time
api-test GET https://api.example.com/users --timing

# Include curl command
api-test GET https://api.example.com/users --show-curl
```

### Save Response

```bash
# Save to file
api-test GET https://api.example.com/users -o users.json

# Save with timestamp
api-test GET https://api.example.com/users -o "response_{datetime}.json"

# Append to log
api-test GET https://api.example.com/health --append health.log
```

## Validation & Testing

### Response Validation

```bash
# Check status code
api-test GET https://api.example.com/health \
  --expect-status 200

# Validate JSON schema
api-test GET https://api.example.com/users \
  --schema user-schema.json

# Check response contains
api-test GET https://api.example.com/users \
  --expect-contains "alice@example.com"

# Check JSON path
api-test GET https://api.example.com/users/1 \
  --expect-json ".name=Alice" \
  --expect-json ".status=active"

# Response time limit
api-test GET https://api.example.com/users \
  --max-time 2000
```

### Test Suites

Create `api-tests.json`:

```json
{
  "baseUrl": "https://api.example.com",
  "headers": {
    "Content-Type": "application/json"
  },
  "tests": [
    {
      "name": "Get Users",
      "method": "GET",
      "path": "/users",
      "expectStatus": 200,
      "expectContains": "users"
    },
    {
      "name": "Create User",
      "method": "POST",
      "path": "/users",
      "body": {"name": "Test User", "email": "test@example.com"},
      "expectStatus": 201,
      "expectJson": ".id"
    },
    {
      "name": "Get User",
      "method": "GET",
      "path": "/users/${createUser.id}",
      "expectStatus": 200,
      "dependsOn": "Create User"
    },
    {
      "name": "Delete User",
      "method": "DELETE",
      "path": "/users/${createUser.id}",
      "expectStatus": 204,
      "dependsOn": "Get User"
    }
  ]
}
```

Run tests:
```bash
api-test --suite api-tests.json
```

Output:
```
Running API Test Suite...

✓ Get Users (45ms)
✓ Create User (89ms)
✓ Get User (34ms)
✓ Delete User (28ms)

4 passed, 0 failed
Average response time: 49ms
```

## Advanced Features

### Variables & Environment

```bash
# Use environment variables
api-test POST https://api.example.com/login \
  -d '{"username": "$USERNAME", "password": "$PASSWORD"}'

# Load from .env file
api-test --env .env GET https://api.example.com/protected

# Extract and reuse token
api-test POST https://api.example.com/login \
  -d '{"user":"admin","pass":"secret"}' \
  --extract-token ".token" \
  --save-env TOKEN

# Use saved token
api-test GET https://api.example.com/admin \
  -H "Authorization: Bearer $TOKEN"
```

### Chained Requests

```bash
# Chain multiple requests
api-test chain \
  "POST /login -d '{...}' --extract token" \
  "GET /profile -H 'Authorization: Bearer $token'" \
  "PATCH /profile -d '{...}'"
```

### Webhook Testing

```bash
# Start local webhook listener
api-test webhook --port 8080

# Test your webhook receiver
# Then trigger webhook from external service

# With custom response
api-test webhook --port 8080 \
  --response '{"status":"received"}' \
  --status 200
```

### Request Replay

```bash
# Save request
api-test POST https://api.example.com/users \
  -d '{"name":"Alice"}' \
  --save-request create-user.json

# Replay saved request
api-test --replay create-user.json

# Modify and replay
api-test --replay create-user.json \
  --modify-body '.name = "Bob"'
```

## Real-World Examples

### Health Check Script

```bash
#!/bin/bash
api-test GET https://api.example.com/health \
  --expect-status 200 \
  --expect-contains "status.*ok" \
  --max-time 3000 || echo "Health check failed"
```

### OAuth2 Flow Test

```bash
# Step 1: Get token
api-test POST https://auth.example.com/oauth/token \
  -d "grant_type=client_credentials" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET" \
  --extract ".access_token" --save-env TOKEN

# Step 2: Use token
api-test GET https://api.example.com/data \
  -H "Authorization: Bearer $TOKEN"
```

### File Upload Test

```bash
api-test POST https://api.example.com/upload \
  -F "file=@document.pdf" \
  -F "type=document" \
  -H "Authorization: Bearer $TOKEN" \
  --expect-status 201 \
  --expect-json ".fileId"
```

## CLI Reference

```
api-test <method> <url> [options]

Methods: GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS

Options:
  -H, --header <header>      Add request header
  -d, --data <data>          Request body
  -d @file                   Load body from file
  -F, --form <data>          Form data (key=value or key=@file)
  -q, --query <param>        Add query parameter
  -o, --output <file>        Save response to file
  --basic <user:pass>        Basic authentication
  --bearer <token>           Bearer token auth
  --expect-status <code>     Expected status code
  --expect-contains <text>   Response should contain text
  --expect-json <path=value> JSON path assertion
  --schema <file>            JSON Schema validation
  --max-time <ms>            Max response time
  --pretty                   Pretty print JSON
  --timing                   Show timing breakdown
  --show-curl                Output equivalent curl command
  --headers-only             Show only response headers
  --body-only                Show only response body
  --status-only              Show only status code
  --suite <file>             Run test suite
  --env <file>               Load environment variables
  --extract <path>           Extract value from response
  --save-env <var>           Save extracted value to env
  --webhook --port <n>       Start webhook listener
  --replay <file>            Replay saved request

Examples:
  api-test GET https://api.example.com/users
  api-test POST https://api.example.com/users -d '{"name":"Alice"}'
  api-test --suite tests.json
  api-test webhook --port 8080
```

## Best Practices

1. **Test in Stages**: Development → Staging → Production
2. **Use Environment Files**: Keep secrets out of scripts
3. **Validate Contracts**: Test both success and error cases
4. **Document Examples**: Save common requests as test suites
5. **Monitor Performance**: Set response time expectations
6. **Version Control**: Commit test suites alongside code
