---
name: csv-data-processor
description: Process, analyze, and transform CSV files with powerful filtering, merging, and statistical operations. Use when working with CSV data that needs cleaning, aggregation, format conversion, or multi-file operations. Supports large files, complex filters, and batch processing.
---

# CSV Data Processor

Professional CSV data processing tool for handling complex data operations efficiently.

## When to Use

- Need to filter rows based on multiple conditions
- Merging multiple CSV files with different schemas
- Converting CSV to other formats (JSON, Excel, SQL)
- Performing statistical analysis on data columns
- Cleaning and normalizing messy CSV data
- Batch processing large CSV files

## When NOT to Use

- Simple one-time viewing (use `cat` or spreadsheet)
- Real-time streaming data processing
- Binary data manipulation
- Database operations (use dedicated DB tools)

## Quick Start

### Filter Rows by Condition

```bash
# Filter rows where age > 25 AND city = "Beijing"
csv-data-processor filter data.csv --where "age>25" --where "city=Beijing"

# Filter with OR condition
csv-data-processor filter data.csv --where "status=active||status=pending"
```

### Merge Multiple Files

```bash
# Merge all CSV files in directory
csv-data-processor merge ./data/*.csv --output merged.csv

# Merge with custom key columns
csv-data-processor merge file1.csv file2.csv --on id --output result.csv
```

### Convert Formats

```bash
# CSV to JSON
csv-data-processor convert data.csv --to json --output data.json

# CSV to Excel
csv-data-processor convert data.csv --to xlsx --output data.xlsx
```

### Statistical Analysis

```bash
# Basic statistics for all numeric columns
csv-data-processor stats data.csv

# Statistics for specific columns
csv-data-processor stats data.csv --columns age,salary --group-by department
```

## Advanced Usage

### Complex Filtering

```bash
# Multi-condition with regex
csv-data-processor filter data.csv \
  --where "email=~/@company\.com$/" \
  --where "created_at>=2024-01-01" \
  --where "status!=deleted"
```

### Data Cleaning

```bash
# Remove duplicates, trim whitespace, handle nulls
csv-data-processor clean data.csv \
  --dedupe --columns email \
  --trim --fill-null "N/A" \
  --output cleaned.csv
```

### Batch Processing

```bash
# Process all CSVs in parallel
csv-data-processor batch ./raw_data/*.csv \
  --script "filter --where status=active | stats --group-by category" \
  --output-dir ./processed/
```

## Options Reference

| Option | Description | Example |
|--------|-------------|---------|
| `--where` | Filter condition | `age>18` |
| `--on` | Join key column | `user_id` |
| `--to` | Output format | `json`, `xlsx`, `sql` |
| `--columns` | Select specific columns | `name,email,phone` |
| `--group-by` | Group statistics | `department` |
| `--dedupe` | Remove duplicates | - |
| `--trim` | Trim whitespace | - |

## Performance Tips

- Use `--chunk-size` for files >100MB
- Enable `--parallel` for batch operations
- Use column selection to reduce memory usage
- Index frequently filtered columns

## Examples

### E-commerce Order Analysis

```bash
# Analyze monthly sales by category
csv-data-processor filter orders.csv --where "status=completed" | \
  csv-data-processor stats --columns amount --group-by "strftime('%Y-%m', order_date)"
```

### User Data Cleanup

```bash
# Clean user export and convert to JSON
csv-data-processor clean users_export.csv \
  --dedupe --columns email \
  --trim \
  --convert --to json \
  --output users_clean.json
```