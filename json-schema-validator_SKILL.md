---
name: json-schema-validator
description: Validate JSON data against JSON Schema definitions, generate schemas from sample data, and test API responses for compliance. Use when ensuring data consistency, validating API payloads, documenting data structures, or enforcing input validation rules. NOT for validating XML, YAML, or non-JSON data formats.
---

# JSON Schema Validator

Validate JSON data against schemas, generate schemas from examples, and ensure API compliance.

## When to Use

- Validating API request/response payloads
- Ensuring configuration file correctness
- Documenting data structures for APIs
- Testing data imports before processing
- Enforcing data consistency across services
- Generating validation documentation
- Creating mock data from schemas

## When NOT to Use

- Validating XML data (use XML-specific tools)
- YAML validation (convert to JSON first)
- Database schema validation
- Binary data validation
- Complex business logic validation (use code)

## Quick Start

```bash
# Validate JSON against schema
json-schema validate data.json schema.json

# Validate multiple files
json-schema validate "*.json" schema.json

# Generate schema from sample data
json-schema generate sample.json --output schema.json

# Validate API response
json-schema validate https://api.example.com/data endpoint-schema.json

# Test with detailed error output
json-schema validate data.json schema.json --verbose
```

## Core Concepts

### JSON Schema Basics

JSON Schema defines the structure and constraints of JSON data:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "name": { "type": "string" },
    "age": { "type": "integer", "minimum": 0 },
    "email": { "type": "string", "format": "email" }
  },
  "required": ["name", "email"]
}
```

### Validation Process

```bash
# Basic validation
json-schema validate data.json schema.json

# With custom error messages
json-schema validate data.json schema.json --errors detailed

# Fail fast (stop at first error)
json-schema validate data.json schema.json --fail-fast
```

## Validation Commands

### File Validation

```bash
# Single file
json-schema validate user.json user-schema.json

# Multiple files against one schema
json-schema validate users/*.json user-schema.json

# Directory validation
json-schema validate data/ schema.json --recursive
```

### Inline Validation

```bash
# Validate JSON string directly
json-schema validate --data '{"name": "John", "age": 30}' schema.json

# Validate from stdin
cat data.json | json-schema validate --stdin schema.json
```

### Remote Validation

```bash
# Validate URL response
json-schema validate https://api.example.com/users/1 user-schema.json

# With custom headers
json-schema validate https://api.example.com/data schema.json \
  --header "Authorization: Bearer token123"
```

## Schema Generation

### From Sample Data

```bash
# Generate schema from example
json-schema generate sample-data.json --output generated-schema.json

# Generate from multiple samples
json-schema generate samples/*.json --merge --output schema.json

# Include examples in schema
json-schema generate sample.json --include-examples
```

### Generation Options

```bash
# Strict mode (all fields required)
json-schema generate sample.json --strict

# Infer formats (email, date, uri)
json-schema generate sample.json --infer-formats

# Set additionalProperties
json-schema generate sample.json --no-additional-properties
```

Generated schema example:
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "id": { "type": "integer" },
    "name": { "type": "string" },
    "email": {
      "type": "string",
      "format": "email"
    },
    "created_at": {
      "type": "string",
      "format": "date-time"
    }
  },
  "required": ["id", "name"]
}
```

## Advanced Validation

### Schema References

```bash
# Resolve local references
json-schema validate data.json schema.json --base-path ./schemas/

# Resolve remote references
json-schema validate data.json schema.json --resolve-remote

# Bundle schema (inline all references)
json-schema bundle schema.json --output bundled-schema.json
```

### Custom Formats

```bash
# Define custom format validators
cat > formats.yaml << EOF
formats:
  phone:
    pattern: "^\\+?[1-9]\\d{1,14}$"
  uuid:
    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"
EOF

json-schema validate data.json schema.json --custom-formats formats.yaml
```

### Conditional Validation

```bash
# Schema with conditionals (if/then/else)
json-schema validate data.json conditional-schema.json

# With context variables
json-schema validate data.json schema.json --context '{"environment": "production"}'
```

## Error Reporting

### Error Formats

```bash
# Human-readable errors (default)
json-schema validate invalid.json schema.json

# JSON error output
json-schema validate invalid.json schema.json --output json

# JUnit XML format for CI
json-schema validate invalid.json schema.json --output junit --output-file results.xml
```

### Error Output Example

```bash
json-schema validate user.json user-schema.json --verbose
```

Output:
```
❌ Validation failed: 3 errors found

[1] /age
    Expected: integer
    Actual: string
    Value: "thirty"

[2] /email
    Format validation failed
    Expected: valid email
    Value: "invalid-email"

[3] (root)
    Missing required property: name
```

## Testing & CI Integration

### Test Suites

```bash
# Run test suite
json-schema test --schema schema.json --tests tests.json

# Test file format:
# [
#   { "description": "valid user", "data": {...}, "valid": true },
#   { "description": "invalid email", "data": {...}, "valid": false }
# ]
```

### CI/CD Integration

```bash
# Exit with error code on failure
json-schema validate data.json schema.json --strict

# Quiet mode (only errors)
json-schema validate data.json schema.json --quiet

# Summary only
json-schema validate data.json schema.json --summary
```

### Git Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "🔍 Validating JSON files..."

# Find all JSON files
for file in $(git diff --cached --name-only --diff-filter=ACM | grep '\.json$'); do
    if [[ "$file" == *"schema.json" ]]; then
        continue
    fi
    
    # Check if has corresponding schema
    schema="${file%.json}-schema.json"
    if [ -f "$schema" ]; then
        json-schema validate "$file" "$schema" --quiet || exit 1
    fi
done
```

## Common Schema Patterns

### User Object

```json
{
  "type": "object",
  "properties": {
    "id": { "type": "integer" },
    "username": { 
      "type": "string", 
      "minLength": 3,
      "maxLength": 20,
      "pattern": "^[a-zA-Z0-9_]+$"
    },
    "email": { "type": "string", "format": "email" },
    "age": { "type": "integer", "minimum": 13, "maximum": 120 },
    "roles": {
      "type": "array",
      "items": { "enum": ["user", "admin", "moderator"] }
    }
  },
  "required": ["id", "username", "email"]
}
```

### API Response

```json
{
  "type": "object",
  "properties": {
    "status": { "enum": ["success", "error"] },
    "data": { "type": "object" },
    "error": {
      "type": "object",
      "properties": {
        "code": { "type": "integer" },
        "message": { "type": "string" }
      }
    }
  },
  "required": ["status"],
  "oneOf": [
    { "required": ["data"] },
    { "required": ["error"] }
  ]
}
```

### Configuration File

```json
{
  "type": "object",
  "properties": {
    "debug": { "type": "boolean", "default": false },
    "port": { "type": "integer", "minimum": 1, "maximum": 65535 },
    "database": {
      "type": "object",
      "properties": {
        "host": { "type": "string" },
        "port": { "type": "integer" },
        "name": { "type": "string" }
      },
      "required": ["host", "name"]
    }
  },
  "required": ["port"]
}
```

## Utility Commands

### Schema Linting

```bash
# Validate schema syntax
json-schema lint schema.json

# Check for best practices
json-schema lint schema.json --strict
```

### Schema Conversion

```bash
# Convert between draft versions
json-schema convert schema.json --from draft-04 --to draft-07

# Convert to TypeScript interfaces
json-schema to-typescript schema.json --output types.ts

# Convert to OpenAPI spec
json-schema to-openapi schema.json --output openapi.yaml
```

### Schema Documentation

```bash
# Generate markdown documentation
json-schema docs schema.json --output schema-docs.md

# Generate HTML documentation
json-schema docs schema.json --format html --output docs/
```

## Use Case Examples

### API Development

```bash
# Validate mock responses match schema
json-schema validate mock-response.json api-response-schema.json

# Test all example responses
for file in examples/*.json; do
    json-schema validate "$file" response-schema.json
done
```

### Configuration Management

```bash
# Validate config before deployment
json-schema validate production.json config-schema.json \
  && echo "✅ Config valid" \
  || echo "❌ Config invalid"
```

### Data Pipeline

```bash
# Validate incoming data
json-schema validate imported-data.json input-schema.json \
  --output json > validation-results.json

# Filter valid records only
jq -r '.valid[]' validation-results.json > valid-records.json
```

### Documentation

```bash
# Generate schema from existing API
curl https://api.example.com/users/1 | json-schema generate --output user-schema.json

# Create documentation
json-schema docs user-schema.json --output user-api-docs.md
```

## Output Options

### JSON Output

```bash
json-schema validate data.json schema.json --output json
```

```json
{
  "valid": false,
  "errors": [
    {
      "path": "/age",
      "message": "Expected integer, got string",
      "schemaPath": "/properties/age/type"
    }
  ],
  "stats": {
    "checks": 45,
    "passed": 44,
    "failed": 1
  }
}
```

### CSV Output

```bash
json-schema validate-batch *.json schema.json --output csv > results.csv
```

## Performance Tips

```bash
# Cache compiled schemas
json-schema validate data.json schema.json --cache

# Use compiled schema
json-schema compile schema.json --output schema.compiled
json-schema validate data.json schema.compiled

# Parallel validation for many files
json-schema validate "*.json" schema.json --parallel 4
```

## Troubleshooting

### Reference Resolution

```bash
# Missing $ref resolution
json-schema validate data.json schema.json --resolve-all

# Check schema validity first
json-schema lint schema.json
```

### Memory Issues

```bash
# For large files
json-schema validate large.json schema.json --streaming

# Limit error reporting
json-schema validate data.json schema.json --max-errors 10
```

## Pricing

**$7 USD** - One-time purchase

Includes:
- Full JSON Schema validation (draft-04, 06, 07, 2019-09, 2020-12)
- Schema generation from sample data
- Multiple output formats
- CI/CD integration
- Custom format validators
- Schema bundling and conversion
- TypeScript/OpenAPI export
- Documentation generation

---

*Ensure your JSON data is always valid and consistent.*
