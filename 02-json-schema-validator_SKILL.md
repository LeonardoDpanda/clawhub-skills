---
name: json-schema-validator
description: Validate JSON data against JSON Schema with detailed error reporting and fix suggestions. Use when ensuring API responses, config files, or data payloads match expected structure. Supports JSON Schema Draft 7/2020-12 with custom validation rules.
---

# JSON Schema Validator

Comprehensive JSON validation tool supporting industry-standard JSON Schema specifications.

## When to Use

- Validating API request/response payloads
- Ensuring configuration file integrity
- Data ingestion quality checks
- CI/CD pipeline validation
- API documentation testing
- Contract testing between services

## When NOT to Use

- Simple type checking (use `typeof`)
- Syntax-only JSON validation
- XML or YAML validation
- Runtime type checking in production hot paths

## Quick Start

### Basic Validation

```bash
# Validate data.json against schema.json
json-schema-validator validate data.json schema.json

# Validate multiple files
json-schema-validator validate data/*.json schema.json
```

### Inline Schema

```bash
# Define schema inline
json-schema-validator validate data.json --schema '{
  "type": "object",
  "required": ["id", "name"],
  "properties": {
    "id": { "type": "integer" },
    "name": { "type": "string", "minLength": 1 }
  }
}'
```

### API Response Validation

```bash
# Validate curl response
curl -s https://api.example.com/user/123 | \
  json-schema-validator validate --stdin user-schema.json
```

## Advanced Usage

### Detailed Error Reporting

```bash
# Show all validation errors with path
json-schema-validator validate data.json schema.json --verbose

# JSON output for CI/CD
json-schema-validator validate data.json schema.json --format json
```

### Custom Formats

```bash
# Validate with custom format checks
json-schema-validator validate data.json schema.json \
  --custom-formats "phone:^\\+?[1-9]\\d{1,14}$" \
  --custom-formats "uuid:^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
```

### Schema Generation

```bash
# Generate schema from sample data
json-schema-validator generate sample-data.json --output schema.json

# Generate with additional constraints
json-schema-validator generate sample-data.json \
  --required-fields id,email,created_at \
  --output schema.json
```

## Schema Examples

### User Object Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["id", "email", "created_at"],
  "properties": {
    "id": {
      "type": "integer",
      "minimum": 1
    },
    "email": {
      "type": "string",
      "format": "email"
    },
    "name": {
      "type": "string",
      "minLength": 1,
      "maxLength": 100
    },
    "role": {
      "type": "string",
      "enum": ["admin", "user", "guest"]
    },
    "created_at": {
      "type": "string",
      "format": "date-time"
    }
  }
}
```

### Array of Products Schema

```json
{
  "type": "array",
  "items": {
    "type": "object",
    "required": ["sku", "price"],
    "properties": {
      "sku": { "type": "string", "pattern": "^[A-Z]{2}-\\d{6}$" },
      "price": { "type": "number", "minimum": 0 },
      "tags": {
        "type": "array",
        "items": { "type": "string" },
        "uniqueItems": true
      }
    }
  }
}
```

## CI/CD Integration

### GitHub Actions

```yaml
- name: Validate API Schemas
  run: |
    json-schema-validator validate \
      tests/fixtures/*.json \
      schemas/api-response.json \
      --format junit \
      --output validation-results.xml
```

### Pre-commit Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit
json-schema-validator validate config/*.json schema.json || exit 1
```

## Error Output Format

```json
{
  "valid": false,
  "errors": [
    {
      "path": ".user.email",
      "message": "Invalid email format",
      "value": "not-an-email",
      "schema": "#/properties/user/properties/email"
    }
  ],
  "suggestions": [
    "Check email format: should be user@domain.com",
    "Ensure 'user' object has required 'email' field"
  ]
}
```