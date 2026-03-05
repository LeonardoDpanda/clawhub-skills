---
name: markdown-formatter
description: Format, lint, and convert Markdown documents with table of contents generation, link validation, heading structure analysis, and style standardization. Use when cleaning up Markdown files, generating TOCs, validating documentation, converting between Markdown flavors, or standardizing document structure. NOT for complex document layouts, WYSIWYG editing, or binary document conversion.
---

# Markdown Formatter

Professional Markdown document formatting, linting, and conversion tool.

## When to Use

- Cleaning up messy Markdown files
- Generating table of contents automatically
- Validating internal and external links
- Standardizing heading hierarchy
- Converting between Markdown flavors (GitHub, GitLab, CommonMark)
- Formatting tables and code blocks
- Preparing documentation for publication

## When NOT to Use

- **DO NOT** use for complex page layouts (use HTML/LaTeX)
- **DO NOT** use as a WYSIWYG editor
- **DO NOT** use for binary document conversion (DOCX, PDF creation)
- **DO NOT** use for mathematical typesetting (use LaTeX)
- **DO NOT** use for real-time collaborative editing

## Usage Examples

### Auto-Format Document
```
Format README.md
```

Output shows changes made:
```
✅ Formatted README.md

Changes:
- Normalized heading levels (H1 → H2 for subsections)
- Added blank lines around code blocks
- Standardized list indentation (2 spaces)
- Fixed table alignment
- Normalized code block language tags
- Trimmed trailing whitespace (12 lines)

Stats:
- Headings: 8
- Code blocks: 4
- Links: 15 internal, 7 external
- Tables: 2
```

### Generate Table of Contents
```
Generate TOC for document.md
```

Output:
```
📑 Table of Contents

- [Introduction](#introduction)
- [Installation](#installation)
  - [Requirements](#requirements)
  - [Setup](#setup)
- [Usage](#usage)
  - [Basic Examples](#basic-examples)
  - [Advanced Options](#advanced-options)
- [API Reference](#api-reference)
- [Contributing](#contributing)
- [License](#license)

✅ TOC inserted at top of document
```

### Validate Links
```
Check all links in documentation.md
```

Output:
```
🔗 Link Validation Report

Total Links: 42
✅ Valid: 38 (90%)
❌ Broken: 3 (7%)
⚠️ Redirected: 1 (2%)

Broken Links:
- Line 45: [Setup Guide](./setup.html) → 404 Not Found
- Line 120: [API Docs](https://api.example.com/v1) → Connection timeout
- Line 200: [Contributing](./CONTRIBUTING.md) → File not found

Redirected Links:
- Line 88: [Docs](https://example.com/docs) → 301 to https://docs.example.com
```

### Fix Heading Structure
```
Fix heading hierarchy in document.md
```

### Convert Markdown Flavor
```
Convert to GitHub Flavored Markdown
```

### Format Tables
```
Format all tables in tables.md
```

## Formatting Options

### Standard Rules (Auto-Applied)
```
✅ Heading hierarchy (no skipping levels)
✅ Consistent list indentation (2 spaces)
✅ Code fences with language tags
✅ Blank lines around block elements
✅ Trim trailing whitespace
✅ Normalize line endings (LF)
✅ Smart quote conversion option
```

### Optional Formatting
```
Format with options:
- Line width: 80 characters (soft wrap)
- Table style: compact/padded
- List marker: dash/asterisk/plus
- Heading style: ATX/Setext
- Code indentation: 4 spaces/fenced
```

## Linting Checks

```
Lint document.md
```

Checks performed:
- ❌ Missing alt text on images
- ❌ Duplicate headings
- ❌ Dead internal links
- ❌ Malformed tables
- ❌ Inconsistent list markers
- ❌ URLs without angle brackets
- ❌ Mixed heading styles
- ❌ Missing code language tags
- ❌ Incorrect nesting

## Conversion Support

| From | To | Notes |
|------|-----|-------|
| CommonMark | GitHub | Adds GFM tables, task lists |
| GitHub | GitLab | Adjusts syntax highlighting |
| Markdown | HTML | Clean semantic HTML |
| HTML | Markdown | Best effort conversion |
| Markdown | Plain text | Stripped formatting |

## Advanced Features

### Batch Processing
```
Format all .md files in ./docs
```

### Compare/Revert
```
Format README.md --preview (show diff only)
Format README.md --in-place (apply changes)
```

### Custom Styles
```
Format with custom style:
- max_line_length: 100
- table_style: github
- strong_preference: asterisks
- em_preference: underscores
```

### Statistics
```
Analyze document.md
```

Output:
```
📊 Document Statistics

Structure:
- Words: 2,450
- Lines: 180
- Paragraphs: 45

Elements:
- Headings: 12 (H1:1, H2:5, H3:6)
- Lists: 8 (ordered: 3, unordered: 5)
- Code blocks: 6
- Tables: 2
- Images: 4
- Links: 28

Quality:
- Avg sentence length: 18 words
- Reading time: ~10 minutes
- Flesch-Kincaid: Grade 10
```

## Common Patterns

### Pre-Publish Checklist
```
Prepare document.md for publishing:
1. Generate TOC
2. Validate all links
3. Fix heading hierarchy
4. Format tables
5. Check image alt text
```

### Documentation Template
```
Format new documentation with standard structure:
- Title (H1)
- Description paragraph
- TOC
- Installation
- Usage
- Examples
- API Reference
- Contributing
- License
```

### Migration Cleanup
```
Convert legacy docs to modern Markdown:
- Convert HTML tags to Markdown
- Fix encoding issues
- Standardize headings
- Update internal links
```

## Integration Tips

- Use with git pre-commit hooks
- CI/CD pipeline integration
- IDE plugin alternative
- Batch process documentation sites
