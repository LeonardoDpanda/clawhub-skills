---
name: data-format-converter
description: Convert data files between JSON, YAML, CSV, TOML, and XML formats with validation, pretty-printing, and schema checking. Use when migrating configuration files, transforming API responses, preparing data for analysis, or standardizing file formats across projects.
---

# Data Format Converter

Universal data format converter supporting JSON, YAML, CSV, TOML, and XML. Validate, transform, and beautify your data files with confidence.

## When to Use

- Migrating config files between formats
- Converting API responses for analysis
- Standardizing data formats across team
- Preparing data for different tools
- Validating file syntax before deployment

## When NOT to Use

- Binary data conversion
- Encrypted file handling
- Files > 100MB (use streaming tools)
- Complex database migrations

## Quick Start

### Convert Single File

```bash
# JSON to YAML
convert-format input.json output.yaml

# YAML to JSON (pretty)
convert-format --pretty config.yaml config.json

# CSV to JSON with headers
convert-format --headers data.csv data.json
```

### Supported Formats

| From/To | JSON | YAML | CSV | TOML | XML |
|---------|------|------|-----|------|-----|
| JSON | ✓ | ✓ | ✓ | ✓ | ✓ |
| YAML | ✓ | ✓ | ✓ | ✓ | ✗ |
| CSV | ✓ | ✓ | ✓ | ✗ | ✗ |
| TOML | ✓ | ✓ | ✗ | ✓ | ✗ |
| XML | ✓ | ✗ | ✗ | ✗ | ✓ |

## Usage Examples

### JSON to YAML (Config Migration)

```bash
convert-format package.json package.yaml
```

**Input (package.json):**
```json
{
  "name": "my-project",
  "version": "1.0.0",
  "scripts": {
    "start": "node app.js",
    "test": "jest"
  }
}
```

**Output (package.yaml):**
```yaml
name: my-project
version: 1.0.0
scripts:
  start: node app.js
  test: jest
```

### CSV to JSON (Data Analysis)

```bash
convert-format --headers users.csv users.json
```

**Input (users.csv):**
```csv
name,email,role
Alice,alice@example.com,admin
Bob,bob@example.com,user
```

**Output (users.json):**
```json
[
  {"name": "Alice", "email": "alice@example.com", "role": "admin"},
  {"name": "Bob", "email": "bob@example.com", "role": "user"}
]
```

### JSON to CSV (Spreadsheet Export)

```bash
convert-format --flatten products.json products.csv
```

### Validate Without Converting

```bash
validate-format config.yaml
# Output: ✓ Valid YAML

validate-format --schema schema.json data.yaml
# Output: ✓ Valid against schema
```

## Advanced Features

### Batch Conversion

```bash
# Convert all JSON files to YAML
convert-format --batch "*.json" --to yaml

# Convert directory recursively
convert-format --batch ./configs/**/*.yaml --to json --out ./json-configs/
```

### Schema Validation

```bash
# Validate JSON against JSON Schema
convert-format --validate --schema api-schema.json api-response.json

# Auto-detect format and validate
convert-format --validate-only data-file
```

### Pretty Printing Options

```bash
# JSON: 2-space indent (default)
convert-format --pretty --indent 2 data.json

# YAML: custom indentation
convert-format --yaml-indent 4 config.yaml

# Sort keys alphabetically
convert-format --sort-keys data.json
```

### Custom Transformations

```bash
# Add envelope wrapper
convert-format --wrap '{"data": {{content}}, "meta": {"converted": true}}' input.json

# Extract nested field
convert-format --extract 'users[*].email' data.json emails.txt

# Filter fields
convert-format --include-keys "name,email,role" users.json filtered.json
```

## Error Handling

Common errors and solutions:

| Error | Cause | Solution |
|-------|-------|----------|
| "Invalid JSON" | Trailing comma | Remove trailing commas |
| "Malformed YAML" | Tab indentation | Use spaces only |
| "CSV parse error" | Comma in field | Quote the field |
| "Encoding issue" | Non-UTF8 file | Convert encoding first |

## Best Practices

1. **Backup First**: Always backup files before batch conversion
2. **Validate After**: Use `--validate` flag for critical files
3. **Pretty Configs**: Keep config files pretty-printed for git diffs
4. **Minimize Prod**: Use compact JSON for production APIs
5. **Version Schemas**: Keep JSON schemas versioned with your data

## CLI Reference

```
convert-format [options] <input> [output]

Options:
  -f, --from <format>      Source format (auto-detect if omitted)
  -t, --to <format>        Target format (required)
  -p, --pretty             Pretty print output
  -i, --indent <n>         Indentation spaces (default: 2)
  -v, --validate           Validate before converting
  -s, --schema <file>      JSON Schema for validation
  -b, --batch <pattern>    Batch process files
  --headers                CSV has header row
  --flatten                Flatten nested structures
  --sort-keys              Sort object keys
  --encoding <enc>         Input encoding (default: utf8)

Examples:
  convert-format -t yaml config.json
  convert-format -b "*.json" -t yaml --pretty
  convert-format -v --schema api.json response.json
```
