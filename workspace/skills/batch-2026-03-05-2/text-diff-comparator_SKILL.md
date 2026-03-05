---
name: text-diff-comparator
description: Compare two text files or strings to find differences, generate patches, and visualize changes with side-by-side or unified diff output. Use when reviewing code changes, comparing document versions, finding what changed in config files, or generating patches for version control. NOT for comparing binary files or image differences.
---

# Text Diff Comparator

Compare text files and strings to identify differences, generate patches, and visualize changes.

## When to Use

- Reviewing code changes before commit
- Comparing configuration file versions
- Finding differences between document drafts
- Generating patches for bug fixes
- Checking what changed in log files
- Merging conflicting file versions
- Auditing document revisions

## When NOT to Use

- Comparing binary files (images, executables, PDFs)
- Comparing directories/folders recursively
- Image visual comparison
- Database schema comparison
- Large files (>100MB) - use specialized tools

## Quick Start

```bash
# Compare two files
diff-tool file1.txt file2.txt

# Compare with unified diff output (patch format)
diff-tool file1.txt file2.txt --unified

# Side-by-side comparison
diff-tool file1.txt file2.txt --side-by-side

# Compare strings directly
diff-tool --string1 "Hello World" --string2 "Hello Universe"

# Generate patch file
diff-tool file1.txt file2.txt --output patch.diff
```

## Comparison Modes

### Unified Diff (Default)

Standard patch format compatible with `git diff` and `patch` command:

```bash
diff-tool original.txt modified.txt
```

Output:
```diff
--- original.txt	2026-03-05 10:00:00
+++ modified.txt	2026-03-05 10:30:00
@@ -1,5 +1,5 @@
 Line 1: Common content
-Line 2: Original text
+Line 2: Modified text
 Line 3: Common content
 Line 4: Common content
-Line 5: To be removed
+Line 5: New replacement
```

### Side-by-Side View

Visual comparison for human review:

```bash
diff-tool file1.txt file2.txt --side-by-side
```

Output:
```
Line 1    │ Line 1: Common    │ Line 1: Common
Line 2    │ Line 2: Original  │ Line 2: Modified  ←
Line 3    │ Line 3: Common    │ Line 3: Common
Line 4    │ Line 4: Common    │ Line 4: Common
Line 5    │ Line 5: To remove │ Line 5: New       ←
```

### Inline Diff

Show changes within lines:

```bash
diff-tool file1.txt file2.txt --inline
```

Output:
```
Line 2: Original [-text-]{+modified text+}
Line 5: [-To be removed-]{+New replacement+}
```

## Advanced Comparison

### Ignore Options

```bash
# Ignore whitespace changes
diff-tool file1.txt file2.txt --ignore-whitespace

# Ignore case differences
diff-tool file1.txt file2.txt --ignore-case

# Ignore blank lines
diff-tool file1.txt file2.txt --ignore-blank-lines

# Ignore specific patterns
diff-tool file1.txt file2.txt --ignore-regex "^#.*"

# Ignore line endings (CRLF vs LF)
diff-tool file1.txt file2.txt --ignore-line-endings
```

### Context Control

```bash
# Show 5 lines of context (default is 3)
diff-tool file1.txt file2.txt --context 5

# Show all lines (no context limit)
diff-tool file1.txt file2.txt --full

# Show only changed lines

diff-tool file1.txt file2.txt --minimal
```

### Line-by-Line Comparison

```bash
# Compare specific line ranges
diff-tool file1.txt file2.txt --from-line 10 --to-line 50

# Compare by line numbers
diff-tool file1.txt file2.txt --line-numbers
```

## File Operations

### Directory Comparison

```bash
# Compare all files in two directories
diff-tool dir1/ dir2/ --recursive

# Compare specific file types only
diff-tool dir1/ dir2/ --include "*.txt"
diff-tool dir1/ dir2/ --exclude "*.log"
```

### Multiple File Comparison

```bash
# Compare lists of files
diff-tool --file-list list1.txt --file-list list2.txt

# Compare with base version
diff-tool --base base.txt --current current.txt
```

## Patch Generation & Application

### Generate Patch

```bash
# Standard unified diff patch
diff-tool file1.txt file2.txt --output fix.patch

# Git-style patch
diff-tool file1.txt file2.txt --git-format --output changes.patch

# Color-coded HTML patch
diff-tool file1.txt file2.txt --html --output changes.html
```

### Apply Patch

```bash
# Apply generated patch to original
diff-tool --apply patch.diff --to file1.txt --output file1_patched.txt

# Dry run (test without applying)
diff-tool --apply patch.diff --to file1.txt --dry-run

# Reverse patch (undo changes)
diff-tool --apply patch.diff --to file2.txt --reverse
```

## Statistics & Summary

### Change Statistics

```bash
# Summary of changes
diff-tool file1.txt file2.txt --stats
```

Output:
```
📊 Diff Statistics
━━━━━━━━━━━━━━━━━━
Files compared: 2
Lines in file1: 150
Lines in file2: 165
Lines added: 20
Lines removed: 5
Lines modified: 15
Similarity: 78%
```

### Similarity Score

```bash
# Get similarity percentage
diff-tool file1.txt file2.txt --similarity
# Output: Similarity: 87.5%
```

## Output Formats

### Colored Terminal Output

```bash
# Auto-detect terminal capability (default)
diff-tool file1.txt file2.txt --color

# Force color
diff-tool file1.txt file2.txt --color=always

# No color
diff-tool file1.txt file2.txt --color=never
```

### JSON Output

```bash
diff-tool file1.txt file2.txt --json
```

```json
{
  "similarity": 78.5,
  "lines_added": 20,
  "lines_removed": 5,
  "lines_modified": 15,
  "changes": [
    {
      "type": "modified",
      "line_number": 5,
      "old": "Line 2: Original text",
      "new": "Line 2: Modified text"
    }
  ]
}
```

### Markdown Diff

```bash
diff-tool file1.txt file2.txt --markdown --output diff.md
```

## Use Case Examples

### Code Review

```bash
# Compare your changes against main branch
diff-tool main.py my_changes.py --side-by-side

# Generate review patch
diff-tool main.py my_changes.py --git-format --output review.patch
```

### Configuration Audit

```bash
# Check what changed in config
diff-tool config.backup.conf config.current.conf

# Ignore comments and blank lines
diff-tool config.backup.conf config.current.conf \
  --ignore-regex "^#" --ignore-blank-lines
```

### Document Revision Tracking

```bash
# Compare document versions
diff-tool draft_v1.md draft_v2.md --inline

# Generate readable change report
diff-tool draft_v1.md draft_v2.md --markdown --output changes.md
```

### Log File Analysis

```bash
# Find new errors in logs
diff-tool yesterday.log today.log --grep "ERROR"

# Show only added lines
diff-tool yesterday.log today.log | grep "^+"
```

## Word-Level Comparison

```bash
# Compare word by word instead of line by line
diff-tool file1.txt file2.txt --word-diff

# Output:
# The quick [-brown-]{+red+} fox jumps
```

## Character-Level Comparison

```bash
# Show character-level changes
diff-tool file1.txt file2.txt --char-diff

# Useful for spotting typos
```

## Three-Way Merge

```bash
# Compare base, local, and remote versions
diff-tool --base base.txt --local local.txt --remote remote.txt

# Generate merge file
diff-tool --base base.txt --local local.txt --remote remote.txt --merge output.txt
```

## Integration Examples

### Git Hook

```bash
# Add to .git/hooks/pre-commit
#!/bin/bash
echo "Checking for accidental changes..."
diff-tool config.template.yml config.yml --stats
```

### CI/CD Pipeline

```bash
# Check if generated files match source
npm run build
diff-tool dist/index.html expected/index.html --quiet || exit 1
```

### Vim Integration

```bash
# Add to .vimrc
set diffexpr=diff_tool#diff()
```

## Troubleshooting

### Large Files

```bash
# For files > 10MB
diff-tool large1.txt large2.txt --streaming

# Sample comparison
diff-tool huge1.txt huge2.txt --sample 1000
```

### Binary Detection

```bash
# Skip binary files automatically
diff-tool dir1/ dir2/ --recursive --skip-binary

# Force text comparison of binary-looking files
diff-tool file1.bin file2.bin --force-text
```

### Encoding Issues

```bash
# Handle different encodings
diff-tool file1.txt file2.txt --encoding utf-8
diff-tool file1.txt file2.txt --encoding latin-1
```

## Performance Tips

| File Size | Recommended Options |
|-----------|---------------------|
| < 1 MB | Default settings |
| 1-10 MB | `--minimal` for faster comparison |
| 10-100 MB | `--streaming` mode |
| > 100 MB | Use `diff` command directly |

## Pricing

**$5 USD** - One-time purchase

Includes:
- Multiple diff formats (unified, side-by-side, inline)
- Patch generation and application
- Multiple ignore options
- Statistics and similarity scoring
- JSON and HTML output
- Word and character-level diff
- Three-way merge support
- Directory comparison

---

*See exactly what changed, line by line.*
