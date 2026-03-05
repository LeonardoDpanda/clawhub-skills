---
name: csv-data-analyzer
description: Analyze CSV files to extract statistics, detect patterns, identify anomalies, and generate data quality reports. Use when exploring datasets, validating data imports, profiling data quality, detecting outliers, or summarizing large CSV files. NOT for modifying CSV data or converting formats (use config-format-converter for conversions).
---

# CSV Data Analyzer

Powerful CSV analysis tool for data exploration, quality assessment, and statistical profiling.

## When to Use

- Exploring unknown datasets and understanding structure
- Data quality assessment before import
- Detecting outliers and anomalies
- Generating column statistics (min, max, mean, median)
- Finding duplicate rows or values
- Checking data distribution
- Validating data types and formats

## When NOT to Use

- Converting CSV to other formats (use config-format-converter)
- Modifying or cleaning CSV data
- Merging multiple CSV files
- Complex data transformations
- Machine learning model training

## Quick Start

```bash
# Basic statistics for all columns
csv-analyzer data.csv

# Analyze specific columns only
csv-analyzer data.csv --columns "name,age,salary"

# Generate full data quality report
csv-analyzer data.csv --full-report

# Check for duplicates
csv-analyzer data.csv --duplicates
```

## Core Features

### 1. Column Profiling

Automatically detects column types and statistics:

```bash
csv-analyzer sales.csv
```

Sample output:
```
📊 CSV Analysis: sales.csv
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Rows: 10,542 | Columns: 8 | Size: 1.2 MB

Column: product_id
├─ Type: String
├─ Unique: 10,542 (100%)
├─ Nulls: 0 (0%)
└─ Sample: SKU-10001, SKU-10002...

Column: price
├─ Type: Numeric
├─ Range: $9.99 - $999.99
├─ Mean: $127.50
├─ Median: $89.99
├─ Std Dev: $98.30
├─ Nulls: 12 (0.1%)
└─ Outliers: 23 values > $500
```

### 2. Data Quality Scoring

```bash
# Get overall data quality score (0-100)
csv-analyzer data.csv --quality-score

# Check for specific issues
csv-analyzer data.csv --check-nulls --check-duplicates --check-formats
```

Quality metrics include:
- **Completeness**: Percentage of non-null values
- **Uniqueness**: Duplicate row detection
- **Validity**: Format compliance (emails, dates, URLs)
- **Consistency**: Type consistency across column

### 3. Statistical Analysis

```bash
# Detailed numeric statistics
csv-analyzer data.csv --stats numeric --columns "revenue,cost,profit"

# Correlation matrix
csv-analyzer data.csv --correlation

# Frequency distribution
csv-analyzer data.csv --frequency --column "category"
```

## Analysis Commands

### Structure Analysis

```bash
# Basic file structure
csv-analyzer file.csv --structure
# Output: Rows, columns, headers, delimiter detection

# Column type inference
csv-analyzer file.csv --types
# Output: String, Integer, Float, Date, Boolean, Email, URL

# Memory usage estimation
csv-analyzer file.csv --memory-profile
```

### Data Quality Checks

```bash
# Find null/empty values
csv-analyzer file.csv --nulls

# Find duplicate rows
csv-analyzer file.csv --duplicates

# Find duplicate values in specific column
csv-analyzer file.csv --duplicates --column "email"

# Validate email formats
csv-analyzer file.csv --validate email --column "contact_email"

# Validate date formats
csv-analyzer file.csv --validate date --column "birth_date"

# Find inconsistent data types
csv-analyzer file.csv --type-inconsistencies
```

### Statistical Summary

```bash
# Numeric column statistics
csv-analyzer file.csv --describe
# Output: count, mean, std, min, 25%, 50%, 75%, max

# Categorical value counts
csv-analyzer file.csv --value-counts --column "status"

# Top N values
csv-analyzer file.csv --top 10 --column "product_name"

# Bottom N values
csv-analyzer file.csv --bottom 10 --column "sales_rank"
```

### Advanced Analysis

```bash
# Detect outliers using IQR method
csv-analyzer file.csv --outliers --column "price"

# Time series analysis (if date column present)
csv-analyzer file.csv --time-series --date-column "order_date"

# Text length analysis
csv-analyzer file.csv --text-stats --column "description"

# Pattern detection
csv-analyzer file.csv --patterns --column "phone_number"
```

## Output Formats

### Human-Readable (Default)

```bash
csv-analyzer data.csv
```

### JSON Output

```bash
csv-analyzer data.csv --json
# For programmatic processing
```

### Markdown Report

```bash
csv-analyzer data.csv --markdown --output report.md
# Generates formatted report file
```

### CSV Summary

```bash
csv-analyzer data.csv --summary-csv --output summary.csv
# Summary statistics as CSV
```

## Use Case Examples

### E-commerce Data Audit

```bash
csv-analyzer orders.csv --full-report --output orders_audit.md
```

Checks:
- Order ID uniqueness
- Price validity (positive numbers)
- Email format compliance
- Date ranges
- State/country codes

### Employee Database Validation

```bash
csv-analyzer employees.csv \
  --validate email --column "work_email" \
  --validate date --column "hire_date" \
  --check-duplicates --column "employee_id"
```

### Sales Data Profiling

```bash
csv-analyzer sales_2024.csv \
  --stats numeric --columns "amount,quantity" \
  --outliers --column "amount" \
  --frequency --column "region"
```

### Survey Data Analysis

```bash
csv-analyzer survey_responses.csv \
  --value-counts --column "satisfaction" \
  --nulls \
  --text-stats --column "feedback"
```

## Advanced Features

### Large File Handling

```bash
# Sample first N rows for quick analysis
csv-analyzer large_file.csv --sample 1000

# Analyze in chunks
csv-analyzer huge_file.csv --chunk-size 50000 --progress

# Memory-efficient mode
csv-analyzer massive_file.csv --streaming
```

### Custom Validation Rules

```bash
# Define custom validation rules file
cat > validation_rules.yaml << EOF
rules:
  - column: age
    type: integer
    min: 18
    max: 120
  - column: email
    pattern: '^[\w\.-]+@[\w\.-]+\.\w+$'
  - column: status
    allowed_values: ['active', 'inactive', 'pending']
EOF

csv-analyzer data.csv --validate-rules validation_rules.yaml
```

### Comparative Analysis

```bash
# Compare two CSV files
csv-analyzer --compare old_data.csv new_data.csv
# Shows: new rows, deleted rows, modified rows
```

## Performance Tips

| File Size | Recommended Flags |
|-----------|-------------------|
| < 10 MB | Standard analysis |
| 10-100 MB | `--sample 10000` for initial exploration |
| 100 MB - 1 GB | `--streaming` mode |
| > 1 GB | `--sample 100000` or cloud-based tools |

## Troubleshooting

### Encoding Issues

```bash
# Auto-detect encoding
csv-analyzer file.csv --encoding auto

# Specify encoding explicitly
csv-analyzer file.csv --encoding utf-8
csv-analyzer file.csv --encoding latin-1
csv-analyzer file.csv --encoding gbk
```

### Delimiter Detection

```bash
# Auto-detect delimiter (default)
csv-analyzer file.csv

# Force specific delimiter
csv-analyzer file.csv --delimiter ';'
csv-analyzer file.csv --delimiter '\t'
```

### Handling Headers

```bash
# File has no header row
csv-analyzer file.csv --no-header

# Custom header names
csv-analyzer file.csv --headers "col1,col2,col3"
```

## Integration Examples

### Pre-Import Validation Pipeline

```bash
#!/bin/bash
set -e

echo "🔍 Analyzing data file..."
csv-analyzer import_data.csv --quality-score --json > analysis.json

QUALITY=$(jq '.quality_score' analysis.json)
if (( $(echo "$QUALITY < 80" | bc -l) )); then
    echo "❌ Data quality too low ($QUALITY%). Aborting import."
    exit 1
fi

echo "✅ Data quality acceptable ($QUALITY%). Proceeding with import."
```

### GitHub Actions Workflow

```yaml
- name: Validate CSV Data
  run: |
    csv-analyzer data.csv --quality-score --json > quality.json
    if [ $(jq '.quality_score' quality.json) -lt 90 ]; then
      echo "Data quality check failed"
      exit 1
    fi
```

## Pricing

**$6 USD** - One-time purchase

Includes:
- Complete CSV profiling and analysis
- Data quality scoring
- Statistical summaries
- Duplicate detection
- Format validation
- Outlier detection
- Multiple output formats
- Large file support

---

*Know your data before you trust it.*
