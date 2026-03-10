---
name: rest-api-tester-pro
description: Test REST APIs with customizable headers, authentication, and request bodies. CLI alternative to Postman for developers who love the terminal. Use when you need to test API endpoints, debug HTTP requests, automate API testing, or manage API collections from the command line.
---

# REST API Tester Pro

A powerful command-line REST API testing tool - the terminal alternative to Postman for developers who prefer the command line.

## Why This Skill?

- **No GUI Required**: Stay in your terminal, no context switching
- **Lightning Fast**: Test APIs instantly without waiting for Postman to load
- **Collection Management**: Organize requests into reusable collections
- **Environment Variables**: Switch between dev/staging/prod with ease
- **Beautiful Output**: Colorized, formatted JSON responses with syntax highlighting
- **Automation Ready**: Perfect for CI/CD pipelines and automated testing

## Quick Start

### Basic GET Request

```bash
# Simple GET request
api-test get https://api.example.com/users

# With custom headers
api-test get https://api.example.com/users \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "X-API-Version: 2"
```

### POST Request with JSON Body

```bash
api-test post https://api.example.com/users \
  -H "Content-Type: application/json" \
  -b '{
    "name": "John Doe",
    "email": "john@example.com",
    "role": "developer"
  }'
```

### Using Different HTTP Methods

```bash
# PUT request
api-test put https://api.example.com/users/123 \
  -b '{"name": "Updated Name"}'

# PATCH request
api-test patch https://api.example.com/users/123 \
  -b '{"email": "new@example.com"}'

# DELETE request
api-test delete https://api.example.com/users/123
```

## Authentication Methods

### Bearer Token

```bash
# Inline token
api-test get https://api.example.com/protected \
  --auth bearer \
  --token "YOUR_JWT_TOKEN"

# From environment variable
api-test get https://api.example.com/protected \
  --auth bearer \
  --token "$API_TOKEN"
```

### Basic Auth

```bash
api-test get https://api.example.com/admin \
  --auth basic \
  --username admin \
  --password secret123
```

### API Key

```bash
# Header-based API key
api-test get https://api.example.com/data \
  --auth apikey \
  --key-name "X-API-Key" \
  --key-value "your-api-key-here"

# Query parameter API key
api-test get https://api.example.com/data \
  --auth apikey \
  --key-name "api_key" \
  --key-value "your-api-key-here" \
  --key-in query
```

## Environment Management

### Create Environment

```bash
# Create development environment
api-test env create dev

# Add variables
api-test env set dev BASE_URL "https://api-dev.example.com"
api-test env set dev API_KEY "dev-key-12345"
api-test env set dev TIMEOUT "30"
```

### Use Environment

```bash
# Use variables from environment
api-test get "{{BASE_URL}}/users" \
  --env dev \
  -H "X-API-Key: {{API_KEY}}"

# Switch to production
api-test get "{{BASE_URL}}/users" \
  --env prod
```

### Environment File Format

```json
{
  "dev": {
    "BASE_URL": "https://api-dev.example.com",
    "API_KEY": "dev-key-12345",
    "TIMEOUT": "30"
  },
  "prod": {
    "BASE_URL": "https://api.example.com",
    "API_KEY": "prod-key-67890",
    "TIMEOUT": "60"
  }
}
```

## Collection Management

### Create Collection

```bash
# Create a new collection
api-test collection create my-project

# Add request to collection
api-test collection add my-project "Get All Users" \
  --method GET \
  --url "{{BASE_URL}}/users" \
  --env dev

# Add POST request
api-test collection add my-project "Create User" \
  --method POST \
  --url "{{BASE_URL}}/users" \
  --body '{"name":"Test","email":"test@example.com"}' \
  --header "Content-Type: application/json"
```

### Run Collection

```bash
# Run all requests in collection
api-test collection run my-project

# Run with specific environment
api-test collection run my-project --env dev

# Run with delay between requests
api-test collection run my-project --delay 1000
```

### Collection File Structure

```json
{
  "name": "my-project",
  "requests": [
    {
      "name": "Get All Users",
      "method": "GET",
      "url": "{{BASE_URL}}/users",
      "headers": {
        "Authorization": "Bearer {{TOKEN}}"
      }
    },
    {
      "name": "Create User",
      "method": "POST",
      "url": "{{BASE_URL}}/users",
      "headers": {
        "Content-Type": "application/json"
      },
      "body": {
        "name": "Test User",
        "email": "test@example.com"
      }
    }
  ]
}
```

## Advanced Features

### Request History

```bash
# Show last 10 requests
api-test history

# Show last 50 requests
api-test history --limit 50

# Clear history
api-test history --clear
```

### Response Handling

```bash
# Save response to file
api-test get https://api.example.com/users \
  --output users.json

# Extract specific field from response
api-test get https://api.example.com/users/1 \
  --extract "data.name"

# Show only status code
api-test get https://api.example.com/health \
  --status-only

# Include response headers
api-test get https://api.example.com/users \
  --include-headers
```

### Request Options

```bash
# Set timeout
api-test get https://slow-api.example.com/data \
  --timeout 60

# Follow redirects
api-test get https://bit.ly/xyz \
  --follow-redirects

# Disable SSL verification (dev only!)
api-test get https://self-signed.example.com \
  --insecure

# Verbose mode for debugging
api-test get https://api.example.com/users \
  --verbose
```

## Automated Testing

### Test Assertions

```bash
# Test status code
api-test get https://api.example.com/users \
  --test "status == 200"

# Test response body
api-test get https://api.example.com/users/1 \
  --test "json.data.id == 1" \
  --test "json.data.name == 'John Doe'"

# Test response time
api-test get https://api.example.com/users \
  --test "response_time < 500"

# Test headers
api-test get https://api.example.com/users \
  --test "headers['content-type'] contains 'json'"
```

### Test Collection

```bash
# Run all tests in collection
api-test collection test my-project

# Generate test report
api-test collection test my-project \
  --reporter json \
  --output test-report.json
```

### Test Script Example

```bash
#!/bin/bash

# Health check test
echo "Testing health endpoint..."
api-test get "{{BASE_URL}}/health" \
  --env dev \
  --test "status == 200" \
  --test "json.status == 'healthy'"

# User CRUD tests
echo "Creating test user..."
RESPONSE=$(api-test post "{{BASE_URL}}/users" \
  --env dev \
  --header "Content-Type: application/json" \
  --body '{"name":"Test","email":"test@test.com"}' \
  --extract "data.id")

echo "Created user ID: $RESPONSE"

# Update user
api-test put "{{BASE_URL}}/users/$RESPONSE" \
  --env dev \
  --body '{"name":"Updated"}' \
  --test "status == 200"

# Delete user
api-test delete "{{BASE_URL}}/users/$RESPONSE" \
  --env dev \
  --test "status == 204"

echo "All tests passed!"
```

## Import/Export

### Import from Postman

```bash
# Import Postman collection
api-test import postman-collection.json \
  --format postman \
  --name my-imported-collection

# Import with environment
api-test import postman-environment.json \
  --format postman-env \
  --name dev
```

### Export Collection

```bash
# Export as JSON
api-test collection export my-project \
  --format json \
  --output my-project.json

# Export as cURL commands
api-test collection export my-project \
  --format curl \
  --output my-project.sh
```

## Use Cases

### 1. API Development Workflow

```bash
# 1. Test your local API during development
api-test get http://localhost:3000/api/users

# 2. Add to collection as you build
api-test collection add my-api "List Users" \
  --method GET \
  --url "http://localhost:3000/api/users"

# 3. Test with different payloads
api-test post http://localhost:3000/api/users \
  -b '{"name":"Alice","role":"admin"}'

api-test post http://localhost:3000/api/users \
  -b '{"name":"Bob","role":"user"}'
```

### 2. CI/CD Pipeline Integration

```yaml
# .github/workflows/api-tests.yml
name: API Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Run API Tests
        run: |
          api-test collection test production-suite \
            --env ci \
            --reporter junit \
            --output test-results.xml
      
      - name: Upload Test Results
        uses: actions/upload-artifact@v3
        with:
          name: test-results
          path: test-results.xml
```

### 3. API Monitoring

```bash
#!/bin/bash
# monitor.sh - Run every 5 minutes via cron

ENDPOINTS=(
  "https://api.example.com/health"
  "https://api.example.com/status"
  "https://api.example.com/metrics"
)

for endpoint in "${ENDPOINTS[@]}"; do
  result=$(api-test get "$endpoint" \
    --timeout 10 \
    --test "status == 200" \
    --silent)
  
  if [ $? -ne 0 ]; then
    echo "ALERT: $endpoint is down" | \
      mail -s "API Alert" admin@example.com
  fi
done
```

### 4. Load Testing

```bash
#!/bin/bash
# Quick load test

CONCURRENT=10
REQUESTS=100

for i in $(seq 1 $CONCURRENT); do
  for j in $(seq 1 $REQUESTS); do
    api-test get "{{BASE_URL}}/users" \
      --env prod \
      --silent &
  done
done

wait
echo "Load test completed"
```

## Configuration

### Global Config File

Create `~/.api-tester/config.json`:

```json
{
  "default_timeout": 30,
  "default_env": "dev",
  "output_format": "pretty",
  "colors": true,
  "save_history": true,
  "history_limit": 100,
  "verify_ssl": true
}
```

### Project Config File

Create `.api-tester.json` in your project root:

```json
{
  "base_url": "https://api.example.com",
  "default_headers": {
    "User-Agent": "API-Tester-Pro/1.0",
    "Accept": "application/json"
  },
  "collections_dir": "./api-collections",
  "environments_dir": "./api-environments"
}
```

## Tips & Best Practices

1. **Use Environment Variables for Secrets**: Never commit API keys to version control
2. **Organize Collections by Feature**: Keep related endpoints together
3. **Name Requests Clearly**: Use descriptive names for better maintainability
4. **Use Variables**: Make collections reusable across environments
5. **Test Assertions**: Add tests to catch API regressions early
6. **Version Control Collections**: Commit collection files to track API changes
7. **Use Scripts for Complex Workflows**: Chain requests for multi-step operations

## When to Use / When NOT to Use

### ✅ Use When

- Testing APIs during development
- Automating API testing in CI/CD
- Quick debugging of API issues
- Performance testing endpoints
- Documenting API behavior
- Migrating from Postman to CLI workflow

### ❌ NOT For

- Complex GUI-based API exploration (use Postman/Insomnia)
- API documentation generation
- Schema validation (use specialized tools)
- Complex OAuth flows (use dedicated OAuth tools)

## Troubleshooting

### Common Issues

```bash
# SSL Certificate errors
api-test get https://api.example.com --insecure

# Timeout issues
api-test get https://slow-api.example.com --timeout 60

# Redirect not followed
api-test get https://bit.ly/xyz --follow-redirects

# Character encoding issues
api-test get https://api.example.com --encoding utf-8
```

### Debug Mode

```bash
# Maximum verbosity
api-test get https://api.example.com/users \
  --verbose \
  --debug
```

## Pricing

This is a premium Skill priced at **$9**.

### Why Premium?

- **Professional Features**: Collection management, environments, automation
- **Time Savings**: Replaces expensive GUI tools for terminal users
- **CI/CD Ready**: Built for modern DevOps workflows
- **Beautiful UI**: Carefully crafted terminal experience
- **Active Support**: Regular updates and feature additions

### Free Alternative

Basic HTTP requests are available with curl. This Skill adds:
- Collection management
- Environment variables
- Automated testing
- Beautiful output formatting
- Request history

---

**REST API Tester Pro** - Test APIs like a pro, stay in your terminal.
