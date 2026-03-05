---
name: image-reader
description: Read and analyze images using OCR or Vision API. Use when user uploads screenshots, photos, or any image that needs to be understood.
---

# Image Reader Skill

Read and analyze images from user uploads.

## Methods

### Method 1: Local OCR (Tesseract)
```bash
# Extract text from image
tesseract {image_path} stdout -l eng+chi_sim
```

### Method 2: Vision API (if local OCR fails)
Use OpenAI GPT-4 Vision or similar API for:
- Complex UI screenshots
- Text-heavy images
- Need structure understanding

## Usage

When user sends an image:
1. Save image to `/tmp/{timestamp}.png`
2. Run OCR extraction
3. Describe what you see to user
4. Answer questions about the image

## Examples

**Screenshot analysis:**
```
用户发了一张Gumroad设置页面的截图

我：我看到你当前在Gumroad的Settings页面。左侧菜单有：
- Profile
- Payments  
- Advanced ← 你需要点击这个
- ...
```

**Error message reading:**
```
用户发了一张错误提示截图

我：图片显示错误信息："Access Token required"
```
