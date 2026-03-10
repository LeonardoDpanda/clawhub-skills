---
name: sql-formatter
description: Format, beautify, and validate SQL queries with syntax highlighting support. Use when users need to clean up messy SQL, standardize query formatting, minify SQL for production, or validate syntax before execution.
---

# SQL Formatter

Format, beautify, and validate SQL queries for better readability and consistency.

## When to Use

- Cleaning up generated or minified SQL
- Standardizing SQL style across a team
- Preparing SQL for documentation
- Minifying SQL for production
- Validating query syntax
- Converting between SQL dialects (basic)

## When NOT to Use

- For query optimization (use EXPLAIN ANALYZE)
- To fix logical errors in queries
- For complex stored procedure debugging

## Usage Examples

### Basic Formatting

```bash
# Format a SQL query
echo "SELECT id,name,email FROM users WHERE active=1 ORDER BY name" | python3 -c "
import sys
sql = sys.stdin.read()

# Simple formatting
formatted = sql.replace(',', ', ').replace('=', ' = ')
keywords = ['SELECT', 'FROM', 'WHERE', 'ORDER BY', 'GROUP BY', 'HAVING', 'JOIN', 'LEFT JOIN', 'RIGHT JOIN', 'INNER JOIN', 'LIMIT', 'OFFSET']

for kw in keywords:
    formatted = formatted.replace(kw, '\n' + kw)
    formatted = formatted.replace(kw.lower(), '\n' + kw.upper())

print(formatted.strip())
"
```

### Python sqlparse Module

```bash
# Using sqlparse for professional formatting
python3 -c "
import sqlparse

sql = 'SELECT id,name,email FROM users WHERE active=1'
formatted = sqlparse.format(sql, reindent=True, keyword_case='upper')
print(formatted)
"
```

### JSON to SQL Insert

```bash
# Convert JSON data to SQL INSERT statements
echo '[{"id": 1, "name": "Alice", "email": "alice@example.com"}, {"id": 2, "name": "Bob", "email": "bob@example.com"}]' | python3 -c "
import json
import sys

data = json.load(sys.stdin)
if not data:
    print('-- No data provided')
    sys.exit(0)

table = 'users'
columns = list(data[0].keys())

def escape_value(v):
    if v is None:
        return 'NULL'
    elif isinstance(v, str):
        return \"'\" + v.replace(\"'\", \"''\") + \"'\"
    else:
        return str(v)

for row in data:
    values = [escape_value(row.get(c)) for c in columns]
    print(f\"INSERT INTO {table} ({', '.join(columns)}) VALUES ({', '.join(values)});\")
"
```

### SQL to JSON

```bash
# Parse simple SELECT results to JSON (simulated)
python3 -c "
# Simulating query results parsing
results = [
    {'id': 1, 'name': 'Alice', 'email': 'alice@example.com'},
    {'id': 2, 'name': 'Bob', 'email': 'bob@example.com'}
]

import json
print(json.dumps(results, indent=2))
"
```

### Query Validation

```bash
# Basic SQL syntax validation
python3 -c "
import re

def validate_sql(sql):
    errors = []
    
    # Check for common issues
    if not sql.strip().endswith(';') and not sql.strip().upper().startswith('SELECT'):
        errors.append('Query should end with semicolon')
    
    # Check for SELECT *
    if re.search(r'SELECT\s+\*', sql, re.IGNORECASE):
        errors.append('Consider specifying columns instead of SELECT *')
    
    # Check for missing WHERE on UPDATE/DELETE
    if re.search(r'^(UPDATE|DELETE)', sql.strip(), re.IGNORECASE):
        if not re.search(r'WHERE', sql, re.IGNORECASE):
            errors.append('⚠️ WARNING: UPDATE/DELETE without WHERE clause!')
    
    # Check for N+1 pattern indicators
    if re.search(r'WHERE\s+\w+\s*=\s*\?', sql, re.IGNORECASE):
        errors.append('Possible N+1 query pattern detected')
    
    return errors

sql = 'UPDATE users SET status = deleted'
errors = validate_sql(sql)
if errors:
    print('Issues found:')
    for e in errors:
        print(f'  - {e}')
else:
    print('✅ Basic validation passed')
"
```

## Formatting Options

| Option | Description |
|--------|-------------|
| `reindent` | Reformat with proper indentation |
| `keyword_case` | `upper`, `lower`, or `capitalize` |
| `identifier_case` | Case for table/column names |
| `strip_comments` | Remove SQL comments |
| `wrap_after` | Wrap lines after N characters |

## Common SQL Patterns

```sql
-- Standard SELECT
SELECT 
    u.id, 
    u.name, 
    u.email,
    p.title as project_name
FROM users u
LEFT JOIN projects p ON u.id = p.user_id
WHERE u.active = 1
ORDER BY u.created_at DESC
LIMIT 10;

-- INSERT with returning
INSERT INTO users (name, email) 
VALUES ('John', 'john@example.com')
RETURNING id;

-- UPDATE with join
UPDATE users 
SET status = 'premium'
WHERE id IN (
    SELECT user_id FROM payments 
    WHERE amount > 100
);
```

## Installation

```bash
# Install sqlparse for better formatting
pip install sqlparse

# Or use as module
python3 -m sqlparse --help
```

## One-Liner Formatter

```bash
# Quick format using Python
python3 -c "import sqlparse,sys;print(sqlparse.format(sys.stdin.read(),reindent=True,keyword_case='upper'))" <<< "select * from users where id=1"
```
