---
name: batch-file-renamer
description: Rename files in bulk using patterns, regex, sequential numbering, date insertion, and metadata-based renaming. Use when organizing photo libraries, standardizing naming conventions, adding timestamps, cleaning up downloaded files, or preparing files for archival.
---

# Batch File Renamer

Powerful bulk file renaming with pattern matching, regex support, sequential numbering, date insertion, and live preview. Rename hundreds of files in seconds.

## When to Use

- Organizing photo libraries with consistent naming
- Adding timestamps to downloaded files
- Standardizing file naming conventions
- Cleaning up messy filenames from downloads
- Preparing files for archival or distribution
- Sequential numbering for sequences
- Removing special characters or spaces

## When NOT to Use

- Renaming system files or executables
- Files currently in use by other programs
- Network paths with unstable connections
- Batch operations without backup

## Quick Start

### Basic Rename

```bash
# Add prefix to all files
batch-rename "*.jpg" --prefix "vacation_2024_"

# Replace text in filenames
batch-rename "*.txt" --replace "old" --with "new"

# Sequential numbering
batch-rename "*.png" --pattern "image_{001}.png"
```

### Preview Before Apply

```bash
# Always preview first!
batch-rename "*.jpg" --prefix "sorted_" --preview

# Output:
# [PREVIEW] 5 files will be renamed:
#   IMG_001.jpg → sorted_IMG_001.jpg
#   IMG_002.jpg → sorted_IMG_002.jpg
# ...
# Use --apply to execute
```

## Pattern Syntax

### Placeholders

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `{name}` | Original filename | `photo.jpg` |
| `{ext}` | File extension | `jpg` |
| `{n}` | Sequential number | `1, 2, 3...` |
| `{nn}` | Zero-padded (2 digits) | `01, 02, 03...` |
| `{nnn}` | Zero-padded (3 digits) | `001, 002...` |
| `{date}` | Current date | `2024-03-04` |
| `{time}` | Current time | `14-30-22` |
| `{datetime}` | Date + time | `2024-03-04_14-30-22` |
| `{created}` | File creation date | `2024-01-15` |
| `{modified}` | Last modified date | `2024-03-01` |

### Pattern Examples

```bash
# Date prefix + original name
batch-rename "*.jpg" --pattern "{date}_{name}"
# Result: 2024-03-04_photo.jpg

# Sequential with custom name
batch-rename "*.pdf" --pattern "document_{nnn}.{ext}"
# Result: document_001.pdf, document_002.pdf...

# Photo organization by date taken
batch-rename "*.jpg" --pattern "{exif_date}_{nnn}.{ext}" --exif
# Result: 2024-01-15_001.jpg
```

## Common Operations

### Replace Text

```bash
# Simple replace
batch-rename "*report*" --replace "draft" --with "final"

# Remove text
batch-rename "*.txt" --remove " - Copy"

# Regex replace (remove numbers)
batch-rename "*.mp3" --regex "^\\d+\\s*" --replace ""
```

### Add Prefix/Suffix

```bash
# Add prefix
batch-rename "*.jpg" --prefix "2024-vacation-"

# Add suffix before extension
batch-rename "*.pdf" --suffix "-signed"
# Result: contract-signed.pdf

# Combine both
batch-rename "*.docx" --prefix "ProjectA_" --suffix "_v2"
```

### Change Case

```bash
# Lowercase all
batch-rename "*" --lowercase

# Uppercase all
batch-rename "*" --uppercase

# Title case
batch-rename "*" --title-case
# Result: my file.txt → My File.txt
```

### Clean Filenames

```bash
# Replace spaces with underscores
batch-rename "*" --replace " " --with "_"

# Remove special characters
batch-rename "*" --clean
# Removes: < > : " / \\ | ? *

# Normalize unicode (accents to ASCII)
batch-rename "*" --ascii-only
```

## Advanced Usage

### EXIF Data (Photos)

```bash
# Rename by photo date taken
batch-rename "*.jpg" --pattern "{exif_year}-{exif_month}-{exif_day}_{nnn}.jpg"

# Include camera model
batch-rename "*.jpg" --pattern "{exif_date}_{exif_model}_{nnn}.jpg"

# Organize by date folders
batch-rename "*.jpg" --move-to "{exif_year}/{exif_month}/"
```

### Music Files (ID3 Tags)

```bash
# Rename MP3s by metadata
batch-rename "*.mp3" --pattern "{artist} - {title}.mp3"

# Album organization
batch-rename "*.mp3" --pattern "{artist}/{album}/{track} - {title}.mp3" --move-to
```

### Conditional Renaming

```bash
# Only files larger than 1MB
batch-rename "*.log" --min-size 1M --pattern "large_{name}"

# Only files modified today
batch-rename "*.tmp" --modified-today --pattern "today_{name}"

# Filter by pattern
batch-rename "*.jpg" --filter "IMG_*" --prefix "camera_"
```

### Undo/Rollback

```bash
# Save undo log (recommended)
batch-rename "*.jpg" --prefix "sorted_" --log

# Undo last operation
batch-rename --undo

# View operation history
batch-rename --history
```

## Configuration File

Create `rename-rules.json`:

```json
{
  "rules": [
    {
      "pattern": "*.jpg",
      "target": "{date}_{name}",
      "exif": true
    },
    {
      "pattern": "*.mp4",
      "target": "video_{nnn}.{ext}",
      "start": 1
    },
    {
      "regex": "^IMG_(\\d+).*",
      "replace": "Photo_$1"
    }
  ]
}
```

Apply:
```bash
batch-rename --config rename-rules.json
```

## Real-World Examples

### Photo Library Organization

```bash
# Organize vacation photos
batch-rename "*.jpg" \
  --exif \
  --pattern "2024-Vacation-{exif_month}-{exif_day}_{nnn}.jpg" \
  --preview

# Create date folders and move
batch-rename "*.jpg" \
  --exif \
  --move-to "./2024-Vacation/{exif_month}-{exif_day}/" \
  --pattern "{nnn}.jpg"
```

### Download Cleanup

```bash
# Clean up browser downloads
batch-rename "*" \
  --clean \
  --lowercase \
  --replace " " --with "-"
```

### Project Files

```bash
# Standardize project assets
batch-rename "*.png" \
  --prefix "project-name_" \
  --pattern "project-name_{nnn}.png"
```

## Safety Features

- **Preview Mode**: Always shows changes before applying
- **Duplicate Detection**: Warns about naming conflicts
- **Undo Log**: Saves operations for rollback
- **Dry Run**: Test without any file changes
- **Backup**: Optional backup of original names

## CLI Reference

```
batch-rename <pattern> [options]

Options:
  -p, --pattern <template>  Rename using template
  --prefix <text>           Add prefix
  --suffix <text>           Add suffix before extension
  --replace <old>           Text to replace
  --with <new>              Replacement text
  --remove <text>           Remove text
  --regex <pattern>         Use regex matching
  --lowercase               Convert to lowercase
  --uppercase               Convert to uppercase
  --title-case              Convert to title case
  --clean                   Remove special characters
  --ascii-only              Convert unicode to ASCII
  --exif                    Use EXIF data (photos)
  --id3                     Use ID3 tags (music)
  --start <n>               Starting number for {n}
  --step <n>                Number increment (default: 1)
  --min-size <size>         Minimum file size
  --max-size <size>         Maximum file size
  --modified-today          Only files modified today
  --filter <pattern>        Filter source files
  --move-to <path>          Move to directory
  --preview                 Preview changes only
  --apply                   Apply changes (required)
  --log                     Save undo log
  --undo                    Undo last operation
  --config <file>           Load rules from file

Examples:
  batch-rename "*.jpg" --prefix "2024_" --preview
  batch-rename "*.mp3" --pattern "{artist} - {title}.mp3"
  batch-rename "*.txt" --replace "draft" --with "final" --apply
```
