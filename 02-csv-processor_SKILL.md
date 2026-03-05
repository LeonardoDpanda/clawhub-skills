---
name: csv-processor
description: Process CSV files with filtering, sorting, aggregation, column operations, and format conversion. Use when analyzing spreadsheet data, transforming CSV formats, extracting subsets of data, performing calculations on tabular data, or preparing data for import/export. NOT for creating new spreadsheets from scratch, complex database operations, or real-time data streaming.
---

# CSV Processor

Powerful CSV data processing with filtering, transformation, and analysis capabilities.

## When to Use

- Analyzing exported data from spreadsheets
- Transforming CSV formats for different tools
- Filtering large datasets by criteria
- Sorting and aggregating tabular data
- Calculating statistics on columns
- Merging or splitting CSV files
- Converting between CSV, JSON, and TSV

## When NOT to Use

- **DO NOT** use for creating spreadsheets from scratch (use Excel/Sheets)
- **DO NOT** use for complex database queries (use SQL)
- **DO NOT** use for real-time streaming data
- **DO NOT** use for files over 100MB (use specialized tools)
- **DO NOT** use for binary data processing

## Usage Examples

### View CSV Structure
```
Analyze CSV file data.csv
```

Output:
```
📊 CSV Analysis: data.csv
Rows: 1,500 | Columns: 8
Headers: id, name, email, department, salary, join_date, status, location

Sample Data (first 5 rows):
1 | 101 | John Smith | john@company.com | Engineering | 85000 | 2023-01-15 | active | NYC
2 | 102 | Jane Doe | jane@company.com | Marketing | 72000 | 2022-08-20 | active | LA
...

Column Types:
- id: integer
- name: string
- email: string
- department: string
- salary: integer
- join_date: date (YYYY-MM-DD)
- status: string (active/inactive)
- location: string
```

### Filter Data
```
Filter CSV where department = Engineering and salary > 80000
```

### Sort Data
```
Sort CSV by salary descending, then by name ascending
```

### Aggregate Statistics
```
Calculate average salary by department from data.csv
```

Output:
```
📊 Aggregation Results: Average Salary by Department

Engineering:    $92,450 (count: 45)
Product:        $88,200 (count: 23)
Sales:          $76,800 (count: 38)
Marketing:      $71,500 (count: 19)
Operations:     $68,300 (count: 15)

Overall Average: $79,450
```

### Column Operations
```
Select columns: name, email, department from data.csv
```

### Convert Format
```
Convert data.csv to JSON format
```

### Merge Files
```
Merge file1.csv and file2.csv on column 'id'
```

## Operations Reference

### Filtering
```
Filter CSV where {column} {operator} {value}

Operators: =, !=, >, <, >=, <=, contains, startswith, endswith, in [list]

Examples:
- Filter where status = active
- Filter where salary > 50000
- Filter where name contains "Smith"
- Filter where department in ["Engineering", "Product"]
- Filter where date >= 2024-01-01
```

### Sorting
```
Sort CSV by {column1} {direction}, {column2} {direction}

Directions: asc, desc

Examples:
- Sort by last_name asc
- Sort by salary desc, name asc
- Sort by created_date desc
```

### Aggregation Functions
```
Calculate {function}({column}) by {group_column}

Functions: sum, avg, min, max, count, unique_count

Examples:
- Calculate sum(revenue) by month
- Calculate avg(score) by category
- Calculate count(*) by status
- Calculate max(price) by brand
```

### Column Operations
```
- Select columns: col1, col2, col3
- Add column: new_col = expression
- Remove columns: col1, col2
- Rename column: old_name → new_name
- Split column: email → [username, domain] by "@"
- Merge columns: first_name + " " + last_name → full_name
```

## Advanced Examples

### Multi-Step Processing
```
Process data.csv:
1. Filter where status = active
2. Select columns: name, department, salary, join_date
3. Sort by join_date desc
4. Save to active_employees.csv
```

### Data Cleaning
```
Clean data.csv:
- Remove rows with empty email
- Trim whitespace from all text columns
- Standardize: department to lowercase
- Remove duplicates based on email
```

### Statistical Summary
```
Generate statistics for data.csv:
- Numeric columns: min, max, avg, median
- Text columns: unique count, most common
- Date columns: range, distribution by year
```

## Format Conversions

| From | To | Command |
|------|-----|---------|
| CSV | JSON | Convert to JSON |
| CSV | TSV | Convert to TSV |
| CSV | Markdown | Convert to markdown table |
| CSV | SQL INSERT | Generate SQL insert statements |
| JSON | CSV | Convert JSON array to CSV |

## Performance Notes

- Files up to 10MB: Instant processing
- Files 10-50MB: May take 10-30 seconds
- Files 50-100MB: May take 1-3 minutes
- Files over 100MB: Recommended to split first

## Error Handling

Common issues:
- **Malformed CSV**: Reports row numbers with errors
- **Encoding issues**: Auto-detects UTF-8, Latin-1
- **Missing headers**: Option to treat first row as data
- **Inconsistent columns**: Reports rows with extra/missing fields
