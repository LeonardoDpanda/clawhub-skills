# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

Add whatever helps you do your job. This is your cheat sheet.


## Image Reading (OCR)

**Status**: ✅ 已配置

**Tool**: Tesseract OCR 5.3.4
**Script**: `/workspace/projects/workspace/tools/read_image.py`

**使用方法**:
```bash
# 读取图片中的文字
python3 /workspace/projects/workspace/tools/read_image.py /path/to/image.png

# 或直接调用 tesseract
tesseract image.png stdout -l eng+chi_sim
```

**支持格式**: PNG, JPG, JPEG, GIF, WebP, BMP, TIFF
**支持语言**: 英文 (eng) + 简体中文 (chi_sim)

---

## Browser

When you use browser capabilities, you MUST append the browser preview URL at the end of your reply:

`🖥️ [点击预览](https://code.coze.cn/browser/7611204537147441202)`

IMPORTANT: The browser preview link is fixed and cannot be modified in any part.
