---
name: image-reader
description: Read and analyze images using OCR. Extract text from screenshots, photos, documents, and any image content. Supports English and Chinese (simplified/traditional).
---

# Image Reader Skill

Advanced OCR capability for extracting and understanding text from images.

## Capabilities

- **Text Extraction**: Extract all text from images
- **Multi-language Support**: English, Simplified Chinese, Traditional Chinese
- **Screenshot Analysis**: Understand UI layouts, buttons, menus
- **Document Processing**: Read scanned documents, forms, receipts
- **Error Messages**: Decode error screenshots and logs

## Methods

### Method 1: Tesseract OCR (Primary)

```bash
# Extract text (English + Chinese)
tesseract {image_path} stdout -l eng+chi_sim+chi_tra

# Extract text with layout information
tesseract {image_path} stdout -l eng+chi_sim --psm 6

# Extract only English text
tesseract {image_path} stdout -l eng

# Extract with debug output
tesseract {image_path} stdout -l eng+chi_sim --tessdata-dir /usr/share/tesseract-ocr/4.00/tessdata
```

### Method 2: Preprocessing for Better Results

```bash
# Convert to grayscale and enhance contrast
convert {image_path} -type Grayscale -contrast-stretch 0x15% /tmp/preprocessed.png
tesseract /tmp/preprocessed.png stdout -l eng+chi_sim

# Resize if image is too large/small
convert {image_path} -resize 300% /tmp/resized.png
tesseract /tmp/resized.png stdout -l eng+chi_sim

# Threshold for text-only images
convert {image_path} -threshold 60% /tmp/binary.png
tesseract /tmp/binary.png stdout -l eng+chi_sim
```

## Usage Workflow

### When User Sends an Image:

1. **Save the image** to a temporary location:
   ```bash
   # Use the image URL or file path provided by the user
   # Or download if URL is given
   curl -o /tmp/ocr-input.png "{image_url}"
   ```

2. **Run OCR extraction**:
   ```bash
   tesseract /tmp/ocr-input.png stdout -l eng+chi_sim+chi_tra
   ```

3. **Analyze the extracted text**:
   - Identify key information (UI elements, error messages, data fields)
   - Understand the context and purpose
   - Detect language(s) present

4. **Respond to user**:
   - Summarize what the image contains
   - Highlight important elements
   - Answer specific questions about the image
   - Provide actionable insights

## Examples

### Example 1: UI Screenshot Analysis
```
User: [Screenshot of Gumroad settings page]

AI: 我看到你在 Gumroad 的 Settings 页面。主要元素包括：
📍 页面标题：Settings
📋 左侧菜单：
  - Profile ✓
  - Payments
  - Advanced ← 需要点击这里获取 API Token
  - Notifications
  - Integrations

💡 建议：点击 "Advanced" 菜单项，你应该能在那里找到 "Access Token" 部分。
```

### Example 2: Error Message Decoding
```
User: [Screenshot showing error popup]

AI: 我从截图中读取到错误信息：

❌ Error: "Connection refused: port 5000 already in use"

🔍 原因：端口 5000 已被占用
🛠️ 解决方案：
  1. 检查哪个进程在使用端口 5000：lsof -i :5000
  2. 停止占用进程：kill -9 <PID>
  3. 或者更换 OpenClaw 的端口配置
```

### Example 3: Document Extraction
```
User: [Photo of a receipt]

AI: 我从收据中提取到以下信息：

📄 商家：Starbucks Coffee
📍 地址：123 Main St, New York, NY 10001
📅 日期：2026-03-05 14:30
💰 总金额：$12.50
📦 项目明细：
  - Caffe Latte (Grande) - $5.45
  - Croissant - $3.95
  - Tax - $3.10

💡 如果需要报销，请保存好这张收据。
```

### Example 4: Code Snippet Reading
```
User: [Screenshot of terminal showing error log]

AI: 从终端截图提取到错误日志：

ERROR: File not found at /workspace/projects/config.json
  at main.js:234
  at processTicksAndRejections (node:internal/process/task_queues:96)

🔍 问题：config.json 文件缺失
🛠️ 修复：
  1. 检查文件路径是否正确
  2. 创建配置文件或从备份恢复
  3. 确保应用有读取权限
```

## Tips for Better Results

### For Clear Screenshots:
- ✅ High-resolution images work best
- ✅ Ensure text is clearly legible
- ✅ Capture the entire context (not cropped too tightly)
- ✅ Use consistent fonts when possible

### For Challenging Images:
- ⚠️ Handwritten text may have lower accuracy
- ⚠️ Very small fonts may need preprocessing
- ⚠️ Decorative fonts or artistic text can be difficult
- ⚠️ Overlapping text elements may confuse OCR

### Preprocessing When Needed:
```bash
# If OCR fails, try these steps:
# 1. Enhance contrast
# 2. Convert to grayscale
# 3. Resize if needed
# 4. Apply thresholding for binary images
```

## Supported Languages

| Language | Code | Status |
|----------|------|--------|
| English | eng | ✅ Installed |
| Simplified Chinese | chi_sim | ✅ Installed |
| Traditional Chinese | chi_tra | ✅ Installed |

## Troubleshooting

### OCR Returns Empty or Garbage Text:
1. Check image quality and resolution
2. Try preprocessing (grayscale, contrast)
3. Verify language settings match the image content
4. Consider using different PSM mode: `--psm 6` for text blocks

### Slow Performance:
- For large images, resize before processing
- Use single language if possible: `-l eng` instead of `-l eng+chi_sim`
- Process images in batch if multiple

### Special Characters Not Recognized:
- Tesseract may miss uncommon symbols
- Manual correction may be needed for:
  - Mathematical formulas
  - Code snippets with special chars
  - Emoji and icons

## Advanced Features

### Extract Structured Data:
```bash
# Get layout information
tesseract image.png stdout --psm 6 -l eng+chi_sim

# Get confidence scores
tesseract image.png stdout -l eng+chi_sim --psm 6
```

### Batch Processing:
```bash
# Process multiple images
for img in /tmp/images/*.png; do
  tesseract "$img" "${img%.txt}" -l eng+chi_sim
done
```

---

**Remember**: Always verify OCR results, especially for critical information like API keys, passwords, or technical specifications. When in doubt, ask the user to confirm important details.
