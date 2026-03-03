---
name: qr-code-tool
description: Generate QR codes for URLs, text, WiFi credentials, contact cards, and more. Use when creating scannable links for marketing materials, sharing WiFi passwords, generating business cards, or creating quick access to digital content. Supports custom styling, error correction levels, and multiple export formats.
---

# QR Code Tool

Create QR codes for URLs, WiFi, contacts, and more.

## When to Use

- Creating scannable links for print materials
- Sharing WiFi credentials securely
- Generating digital business cards
- Creating quick app download links
- Sharing locations or maps
- Event check-in codes

## ⚡ 版本对比

| 功能 | 免费版 | 专业版 |
|-----|--------|--------|
| 基础URL二维码 | ✅ | ✅ |
| 黑白样式 | ✅ | ✅ |
| 自定义颜色 | ❌ | ✅ |
| 添加Logo | ❌ | ✅ |
| WiFi自动连接码 | ❌ | ✅ |
| 名片(vCard) | ❌ | ✅ |
| 批量生成 | ❌ | ✅ |
| 高清PNG导出 | ❌ | ✅ |
| **价格** | **免费** | **$4 一次性** |

## 🚀 升级到专业版

### 购买授权码

- [Gumroad 购买 $4](https://9708247063907.gumroad.com/l/lompxr)

### 激活授权

```bash
# 激活专业版
clawhub config set qr-code-tool.license "YOUR_LICENSE_KEY"

# 验证激活状态
clawhub config get qr-code-tool.license
```

## Quick Start

### Basic URL QR Code

```python
import qrcode

def generate_qr(data, output_path='qr_code.png'):
    """Generate simple QR code"""
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(data)
    qr.make(fit=True)
    
    img = qr.make_image(fill_color="black", back_color="white")
    img.save(output_path)
    return output_path

# Usage
generate_qr('https://example.com', 'website_qr.png')
```

### WiFi QR Code (专业版)

```python
def generate_wifi_qr(ssid, password, security='WPA', output='wifi_qr.png'):
    """
    Generate WiFi connection QR code
    Format: WIFI:S:ssid;T:security;P:password;;
    """
    wifi_string = f"WIFI:S:{ssid};T:{security};P:{password};;"
    return generate_qr(wifi_string, output)

# Usage
generate_wifi_qr('MyHomeNetwork', 'secret123', 'WPA')
# Scan to auto-connect to WiFi
```

### Contact Card vCard (专业版)

```python
def generate_vcard_qr(name, phone, email, output='contact_qr.png'):
    """Generate vCard QR code"""
    vcard = f"""BEGIN:VCARD
VERSION:3.0
FN:{name}
TEL:{phone}
EMAIL:{email}
END:VCARD"""
    return generate_qr(vcard, output)

# Usage
generate_vcard_qr('John Doe', '+1234567890', 'john@example.com')
```

### Styled QR Code (专业版)

```python
def generate_styled_qr(data, output='styled_qr.png', **kwargs):
    """Generate QR with custom styling"""
    qr = qrcode.QRCode(
        version=kwargs.get('version', 1),
        error_correction=getattr(
            qrcode.constants, 
            f"ERROR_CORRECT_{kwargs.get('error_correction', 'M')}"
        ),
        box_size=kwargs.get('box_size', 10),
        border=kwargs.get('border', 4),
    )
    qr.add_data(data)
    qr.make(fit=True)
    
    # Custom colors
    fill_color = kwargs.get('fill_color', 'black')
    back_color = kwargs.get('back_color', 'white')
    
    img = qr.make_image(fill_color=fill_color, back_color=back_color)
    img.save(output)
    return output

# Styled examples
generate_styled_qr('https://mysite.com', 'blue_qr.png', 
                   fill_color='blue', back_color='lightblue')
```

## Error Correction Levels

| Level | Correction | Use Case |
|-------|-----------|----------|
| L | ~7% | Clean environments |
| M | ~15% | Default, good balance |
| Q | ~25% | Dirty/damaged possible |
| H | ~30% | Logos/overlays on QR |

## Dependencies

```bash
pip install qrcode[pil]
```
