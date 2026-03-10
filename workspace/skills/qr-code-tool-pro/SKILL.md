---
name: qr-code-tool
title: "QR Code Toolkit Pro - Professional QR Generator"
description: "Generate professional QR codes for URLs, WiFi credentials, contact cards, and more. No ads, custom styling, bulk generation."
keywords: ["qr code generator", "wifi qr code", "vcard qr code", "custom qr code", "bulk qr generator", "qr code no watermark", "professional qr code"]
---

# 📱 QR Code Toolkit Pro

> **专业二维码生成器 —— 营销、支付、WiFi分享全搞定**

Create professional QR codes for URLs, WiFi, contacts, and more. No ads, no tracking, your data stays yours.

[![Gumroad](https://img.shields.io/badge/Upgrade%20to%20Pro-$4-blue?style=for-the-badge)](https://9708247063907.gumroad.com/l/lompxr)

---

## When to Use

- Creating scannable links for print materials
- Sharing WiFi credentials securely
- Generating digital business cards
- Creating quick app download links
- Sharing locations or maps
- Event check-in codes

---

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
| 高清PNG/SVG导出 | ❌ | ✅ |
| **价格** | **免费** | **$4 一次性** |

---

## 🚀 升级到专业版

### 购买授权码

- **[🛒 Gumroad 购买 $4](https://9708247063907.gumroad.com/l/lompxr)**

### 激活授权

```bash
# 激活专业版
clawhub config set qr-code-tool.license "YOUR_LICENSE_KEY"

# 验证激活状态
clawhub config get qr-code-tool.license
```

---

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

---

## Error Correction Levels

| Level | Correction | Use Case |
|-------|-----------|----------|
| L | ~7% | Clean environments |
| M | ~15% | Default, good balance |
| Q | ~25% | Dirty/damaged possible |
| H | ~30% | Logos/overlays on QR |

---

## Dependencies

```bash
pip install qrcode[pil]
```

---

## 💎 Pro Version Benefits

- **🎨 Custom Styling** — Colors, shapes, eye patterns
- **🏷️ Logo Support** — Add your brand logo to QR codes
- **📶 WiFi Codes** — Instant WiFi connection QR codes
- **👤 vCard Support** — Digital business cards
- **📊 Batch Generation** — Generate hundreds at once
- **🖼️ HD Export** — PNG, SVG, PDF formats
- **📧 Priority Support** — Get help when you need it
- **🏢 Commercial License** — Use in commercial projects

**[🛒 Get Pro Now - $4](https://9708247063907.gumroad.com/l/lompxr)**

---

## Use Cases

- 🏪 **实体店** — WiFi二维码贴桌上
- 💼 **商务** — 电子名片二维码
- 🎟️ **活动** — 门票/签到二维码批量生成
- 💰 **个人** — 收款码美化

---

## 🤝 Support

- 📧 邮箱: support@your-domain.com
- 💬 微信: YourWeChatID
- 🐛 [GitHub Issues](../../issues)

---

## Related Tools

- **[Config Format Converter](https://9708247063907.gumroad.com/l/qpaweb)** — Convert JSON/YAML/TOML configs
- **[Batch File Renamer](https://9708247063907.gumroad.com/l/arybl)** — Rename files in bulk
- **[REST API Tester](https://9708247063907.gumroad.com/l/pzksc)** — Test APIs without leaving the terminal

---

<p align="center">
  <strong>⭐ Star this repo if it helps you!</strong>
</p>
