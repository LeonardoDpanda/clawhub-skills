---
name: config-format-converter
description: Convert and validate configuration files between JSON, YAML, and TOML formats. Use when working with config files that need format conversion, syntax validation, or pretty-printing. Supports package.json, pyproject.toml, .yaml/.yml configs, and any structured data files. Ideal for cross-platform project setup, CI/CD config migration, and developer tooling workflows.
---

# Config Format Converter

Universal configuration file format converter for JSON, YAML, and TOML.

## When to Use

- Converting `package.json` to `pyproject.toml` or vice versa
- Migrating CI/CD configs between formats (`.yaml` ↔ `.json`)
- Normalizing config files for cross-platform projects
- Validating syntax before committing config changes
- Pretty-printing minified config files

## ⚡ 版本对比

| 功能 | 免费版 | 专业版 | 企业版 |
|-----|--------|--------|--------|
| 单文件转换 | ✅ | ✅ | ✅ |
| 基础格式(JSON/YAML/TOML) | ✅ | ✅ | ✅ |
| 批量文件转换 | ❌ | ✅ | ✅ |
| 高级格式(XML/INI/Properties) | ❌ | ✅ | ✅ |
| API 接口调用 | ❌ | ✅ | ✅ |
| 自定义转换模板 | ❌ | ✅ | ✅ |
| 私有化部署 | ❌ | ❌ | ✅ |
| SLA 技术支持 | ❌ | ❌ | ✅ |
| **价格** | **免费** | **¥29/月** | **联系销售** |

## 🚀 升级到专业版

### 购买授权码

1. **微信/支付宝支付**
   - 扫码支付 → 自动发送授权码到邮箱
   - [点击购买 ¥29/月](https://your-store.com/buy?plan=pro)
   - [点击购买 ¥199/年（省17%）](https://your-store.com/buy?plan=pro-yearly)

2. **国际支付（Stripe/PayPal）**
   - [Gumroad 购买 $5/月](https://9708247063907.gumroad.com/l/qpaweb)

### 激活授权

```bash
# 激活专业版
clawhub config set config-format-converter.license "YOUR_LICENSE_KEY"

# 验证激活状态
clawhub config get config-format-converter.license
```

## Quick Start

### Convert Between Formats

```python
import json
import yaml
import toml

# JSON to YAML
with open('package.json') as f:
    data = json.load(f)
with open('package.yaml', 'w') as f:
    yaml.dump(data, f, default_flow_style=False, sort_keys=False)

# YAML to JSON
with open('docker-compose.yaml') as f:
    data = yaml.safe_load(f)
with open('docker-compose.json', 'w') as f:
    json.dump(data, f, indent=2)

# TOML to JSON
with open('pyproject.toml') as f:
    data = toml.load(f)
with open('pyproject.json', 'w') as f:
    json.dump(data, f, indent=2)
```

### Batch Convert (专业版功能)

```python
import os
import json
import yaml

# 批量转换目录下所有 JSON 为 YAML
for filename in os.listdir('configs/'):
    if filename.endswith('.json'):
        with open(f'configs/{filename}') as f:
            data = json.load(f)
        output = filename.replace('.json', '.yaml')
        with open(f'configs/{output}', 'w') as f:
            yaml.dump(data, f, default_flow_style=False)
        print(f"Converted: {filename} -> {output}")
```

### Validate Config Syntax

```python
import json
import yaml

def validate_json(filepath):
    try:
        with open(filepath) as f:
            json.load(f)
        return True, "Valid JSON"
    except json.JSONDecodeError as e:
        return False, str(e)

def validate_yaml(filepath):
    try:
        with open(filepath) as f:
            yaml.safe_load(f)
        return True, "Valid YAML"
    except yaml.YAMLError as e:
        return False, str(e)
```

## Common Workflows

### Migrate npm Project to Python Poetry

```python
import json
import toml

# Read package.json
with open('package.json') as f:
    pkg = json.load(f)

# Create pyproject.toml structure
pyproject = {
    'tool': {
        'poetry': {
            'name': pkg.get('name', ''),
            'version': pkg.get('version', '0.1.0'),
            'description': pkg.get('description', ''),
            'authors': [],
            'dependencies': {}
        }
    }
}

# Write TOML
with open('pyproject.toml', 'w') as f:
    toml.dump(pyproject, f)
```

## Dependencies

```bash
pip install pyyaml toml
```

## Support

- 📧 邮箱: support@your-domain.com
- 💬 微信: YourWeChatID
- 📖 文档: https://docs.your-domain.com
