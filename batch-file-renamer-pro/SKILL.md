---
name: batch-file-renamer
title: "Batch File Renamer Pro - Bulk Rename Tool with EXIF Support"
description: "Batch rename files with powerful patterns, regex support, and preview functionality. Perfect for photographers, media libraries, and project cleanup."
keywords: ["batch rename files", "bulk file renamer", "photo renaming tool", "exif rename", "file organizer", "regex rename", "automatic file rename"]
---

# 📁 Batch File Renamer Pro

> **1000个文件1分钟重命名 —— 摄影师/自媒体人的救星**

Powerful batch file renaming with patterns, regex, EXIF support, and preview mode.

[![Gumroad](https://img.shields.io/badge/Upgrade%20to%20Pro-$3-blue?style=for-the-badge)](https://9708247063907.gumroad.com/l/arybl)

---

## When to Use

- Renaming hundreds of photos from `IMG_001.jpg` to `Vacation_2025_001.jpg`
- Adding timestamps to log files
- Cleaning up messy download folders
- Standardizing naming conventions across projects
- Sequential numbering for ordered content
- Removing special characters from filenames

---

## ⚡ 版本对比

| 功能 | 免费版 | 专业版 |
|-----|--------|--------|
| 单文件重命名 | ✅ | ✅ |
| 基础替换 | ✅ | ✅ |
| 批量重命名(≤50文件) | ✅ | ✅ |
| 批量重命名(无限) | ❌ | ✅ |
| 正则表达式匹配 | ❌ | ✅ |
| 序号批量生成 | ❌ | ✅ |
| EXIF元数据提取 | ❌ | ✅ |
| 自动时间戳 | ❌ | ✅ |
| 预览模式 | ❌ | ✅ |
| **价格** | **免费** | **$3 一次性** |

---

## 🚀 升级到专业版

### 购买授权码

- **[🛒 Gumroad 购买 $3](https://9708247063907.gumroad.com/l/arybl)**

### 激活授权

```bash
# 激活专业版
clawhub config set batch-file-renamer.license "YOUR_LICENSE_KEY"

# 验证激活状态
clawhub config get batch-file-renamer.license
```

---

## Quick Start

### Basic Rename

```python
import os
import re
from datetime import datetime

def batch_rename(directory, pattern, replacement):
    """
    Rename files matching pattern
    
    Args:
        directory: Path to files
        pattern: Regex pattern to match
        replacement: Replacement string
    """
    renamed = []
    for filename in os.listdir(directory):
        new_name = re.sub(pattern, replacement, filename)
        if new_name != filename:
            old_path = os.path.join(directory, filename)
            new_path = os.path.join(directory, new_name)
            os.rename(old_path, new_path)
            renamed.append((filename, new_name))
    return renamed

# Example: Add prefix
batch_rename('./photos', r'^(.*)$', r'Vacation_2025_\1')
```

### Sequential Numbering (专业版)

```python
def number_files(directory, prefix='', digits=3, extension=None):
    """Add sequential numbers to files"""
    files = sorted([f for f in os.listdir(directory) 
                   if extension is None or f.endswith(extension)])
    
    renamed = []
    for i, filename in enumerate(files, 1):
        old_path = os.path.join(directory, filename)
        ext = os.path.splitext(filename)[1]
        new_name = f"{prefix}{str(i).zfill(digits)}{ext}"
        new_path = os.path.join(directory, new_name)
        os.rename(old_path, new_path)
        renamed.append((filename, new_name))
    
    return renamed

# Usage
number_files('./downloads', prefix='Project_', digits=3)
# Result: Project_001.pdf, Project_002.jpg, ...
```

### Preview Mode (专业版安全功能)

```python
def preview_rename(directory, pattern, replacement):
    """Preview changes without renaming"""
    changes = []
    for filename in os.listdir(directory):
        new_name = re.sub(pattern, replacement, filename)
        if new_name != filename:
            changes.append(f"{filename} -> {new_name}")
    return changes

# Preview first
preview = preview_rename('./files', r'IMG_(\d+)', r'Photo_\1')
for change in preview:
    print(change)
```

---

## Common Patterns

| Pattern | Description | Example |
|---------|-------------|---------|
| `r'^IMG_(\d+)'` | Match IMG_ prefix | `IMG_001.jpg` |
| `r'\s+'` | Replace spaces | `My File.txt` → `My_File.txt` |
| `r'[^\w\.]'` | Remove special chars | `file@#$%.txt` → `file.txt` |
| `r'\.jpeg$'` | Change extension | `.jpeg` → `.jpg` |

---

## Best Practices

1. **Always preview first** - Use `preview_rename()` before actual rename
2. **Backup important files** - Renaming is irreversible
3. **Test on single file** - Verify pattern works as expected
4. **Use regex groups** - Capture parts of filename with `(\d+)` etc.

---

## Dependencies

```bash
pip install re
```

---

## 💎 Pro Version Benefits

- **📸 EXIF Support** — Extract photo metadata for naming
- **🎵 ID3 Tags** — Music file metadata extraction
- **🔍 Regex Power** — Advanced pattern matching
- **👁️ Preview Mode** — See changes before committing
- **📁 Subfolder Support** — Recursive batch processing
- **📧 Priority Support** — Get help when you need it
- **🏢 Commercial License** — Use in commercial projects

**[🛒 Get Pro Now - $3](https://9708247063907.gumroad.com/l/arybl)**

---

## 🤝 Support

- 📧 邮箱: support@your-domain.com
- 💬 微信: YourWeChatID
- 🐛 [GitHub Issues](../../issues)

---

## Related Tools

- **[Config Format Converter](https://9708247063907.gumroad.com/l/qpaweb)** — Convert JSON/YAML/TOML configs
- **[REST API Tester](https://9708247063907.gumroad.com/l/pzksc)** — Test APIs without leaving the terminal
- **[QR Code Toolkit](https://9708247063907.gumroad.com/l/lompxr)** — Generate professional QR codes

---

<p align="center">
  <strong>⭐ Star this repo if it helps you!</strong>
</p>
