---
name: json-path-query
description: Query and extract data from JSON documents using JSONPath syntax. Use when filtering complex JSON data, extracting nested values, or transforming JSON structures without writing custom code.
---

# JSON Path Query

Extract and manipulate JSON data using JSONPath expressions, similar to XPath for XML.

## When to Use

- Extracting specific fields from large JSON documents
- Filtering arrays based on conditions
- Querying nested JSON structures
- Transforming JSON data for reporting
- Validating JSON structure

## When NOT to Use

- Complex data transformations (use jq for advanced processing)
- JSON modification (this is primarily for querying)
- Schema validation (use json-schema-validator)
- API testing (use rest-api-tester)

## JSONPath Syntax Reference

| Expression | Description |
|------------|-------------|
| `$` | Root object/element |
| `.` | Child operator |
| `..` | Recursive descent |
| `*` | Wildcard (all objects/elements) |
| `[]` | Subscript operator |
| `[start:end]` | Array slice operator |
| `[?()]` | Filter (expression) |

## Examples

### Basic Queries

```bash
# Sample JSON data
cat > /tmp/sample.json << 'JSON'
{
  "store": {
    "book": [
      {"title": "Book A", "price": 10, "category": "fiction"},
      {"title": "Book B", "price": 20, "category": "tech"},
      {"title": "Book C", "price": 15, "category": "fiction"}
    ],
    "bicycle": {
      "color": "red",
      "price": 100
    }
  }
}
JSON

# Using Python jsonpath-ng
python3 << PYTHON
import json
from jsonpath_ng import parse

data = json.load(open('/tmp/sample.json'))

# Get all book titles
print("All book titles:")
for match in parse('$.store.book[*].title').find(data):
    print(f"  {match.value}")

# Get first book
print("\nFirst book:")
print(parse('$.store.book[0]').find(data)[0].value)

# Get all prices
print("\nAll prices:")
for match in parse('$..price').find(data):
    print(f"  {match.value}")
PYTHON
```

### Filter Expressions

```bash
#!/bin/bash
JSON_FILE="$1"
QUERY="$2"

python3 << PYTHON
import json
import sys
from jsonpath_ng import parse

try:
    with open('$JSON_FILE') as f:
        data = json.load(f)
    
    jsonpath_expression = parse('$QUERY')
    matches = jsonpath_expression.find(data)
    
    for match in matches:
        print(json.dumps(match.value, indent=2))
except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)
PYTHON
```

### Common Query Patterns

```bash
#!/bin/bash
# JSONPath Query Examples

query_json() {
    local file="$1"
    local path="$2"
    
    python3 << PYTHON
import json
from jsonpath_ng import parse

with open('$file') as f:
    data = json.load(f)

for match in parse('$path').find(data):
    if isinstance(match.value, (dict, list)):
        print(json.dumps(match.value, indent=2))
    else:
        print(match.value)
PYTHON
}

# Query patterns
echo "1. Get all names:"
query_json data.json "$.users[*].name"

echo "2. Filter by condition:"
query_json data.json "$.users[?(@.age > 30)].name"

echo "3. Get nested property:"
query_json data.json "$.company.address.city"

echo "4. Find by value:"
query_json data.json "$..[?(@.status == 'active')]"

echo "5. Array slice:"
query_json data.json "$.items[0:3]"
```

### Complete JSONPath Tool

```bash
#!/bin/bash
# jsonpath-tool - Query JSON with JSONPath

usage() {
    echo "Usage: $0 <json-file> <jsonpath-query>"
    echo
    echo "Examples:"
    echo "  $0 data.json '\$.users[*].name'"
    echo "  $0 data.json '\$.store.book[?(@.price < 10)]'"
    echo "  $0 data.json '\$..author'"
    exit 1
}

if [ $# -lt 2 ]; then
    usage
fi

JSON_FILE="$1"
QUERY="$2"

if [ ! -f "$JSON_FILE" ]; then
    echo "Error: File not found: $JSON_FILE"
    exit 1
fi

python3 << PYTHON
import json
import sys
from jsonpath_ng import parse
from jsonpath_ng.exceptions import JSONPathError

try:
    # Load JSON
    with open('$JSON_FILE') as f:
        data = json.load(f)
    
    # Parse and execute query
    jsonpath_expr = parse('$QUERY')
    matches = jsonpath_expr.find(data)
    
    if not matches:
        print("No matches found")
        sys.exit(0)
    
    # Output results
    if len(matches) == 1:
        result = matches[0].value
        if isinstance(result, (dict, list)):
            print(json.dumps(result, indent=2, ensure_ascii=False))
        else:
            print(result)
    else:
        results = [m.value for m in matches]
        print(json.dumps(results, indent=2, ensure_ascii=False))
        
except JSONPathError as e:
    print(f"JSONPath Error: {e}", file=sys.stderr)
    sys.exit(1)
except json.JSONDecodeError as e:
    print(f"JSON Parse Error: {e}", file=sys.stderr)
    sys.exit(1)
except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)
PYTHON
```

### JSONPath Cheat Sheet

```bash
#!/bin/bash
cat << 'CHEATSHEET'
╔══════════════════════════════════════════════════════════╗
║              JSONPath Cheat Sheet                        ║
╠══════════════════════════════════════════════════════════╣
║  Syntax          │  Description                          ║
╠══════════════════╪═══════════════════════════════════════╣
║  $               │  Root object                          ║
║  .property       │  Child property                       ║
║  ['property']    │  Child property (alternative)         ║
║  [index]         │  Array element at index               ║
║  [start:end]     │  Array slice                          ║
║  [*]             │  All array elements                   ║
║  ..property      │  Recursive descent                    ║
║  [?()]           │  Filter expression                    ║
╚══════════════════╧═══════════════════════════════════════╝

Filter Operators:
  ==    Equal
  !=    Not equal
  <     Less than
  <=    Less than or equal
  >     Greater than
  >=    Greater than or equal
  =~    Regular expression match
  in    Contains (array)
  nin   Not contains (array)

Examples:
  $.users[*].name              # All user names
  $.users[0]                   # First user
  $.users[-1:]                 # Last user
  $.users[?(@.age > 30)]       # Users over 30
  $.users[?(@.name =~ 'J.*')]  # Users with names starting with J
  $..price                     # All prices anywhere in JSON
  $.store.book[0:2]            # First 2 books
CHEATSHEET
```

### Installation Helper

```bash
#!/bin/bash
# Install jsonpath-ng if not present

if ! python3 -c "import jsonpath_ng" 2>/dev/null; then
    echo "Installing jsonpath-ng..."
    pip3 install jsonpath-ng
fi

echo "✅ jsonpath-ng ready to use"
```

## Sample Queries for Common APIs

```bash
# GitHub API - Get repository names
jsonpath-query repos.json "$.[*].full_name"

# AWS EC2 - Get instance IDs
jsonpath-query instances.json "$.Reservations[*].Instances[*].InstanceId"

# Kubernetes - Get pod names
jsonpath-query pods.json "$.items[*].metadata.name"

# Docker - Get container names
jsonpath-query containers.json "$..Names"
```

## Pricing

**$5 USD** - One-time purchase
- Complete JSONPath query support
- Filter expressions and operators
- Array slicing and wildcards
- Recursive descent queries
- Ready-to-use scripts and examples
