---
name: base64-toolkit
description: Encode and decode Base64 strings, files, and images. Use when users need to encode data for transmission, decode API responses, handle Basic Auth tokens, embed images in CSS/HTML, or process data URIs.
---

# Base64 Toolkit

Encode and decode Base64 data for files, strings, images, and URLs.

## When to Use

- Encoding binary data for text transmission
- Decoding API responses (images, files)
- Creating data URIs for embedded images
- Working with Basic Auth headers
- Encoding credentials or tokens
- Embedding fonts in CSS

## When NOT to Use

- For encryption (Base64 is encoding, not encryption)
- For large file storage (increases size by ~33%)

## Usage Examples

### String Encoding/Decoding

```bash
# Encode string to Base64
echo -n "Hello World" | base64
# Output: SGVsbG8gV29ybGQ=

# Decode Base64 to string
echo "SGVsbG8gV29ybGQ=" | base64 -d
# Output: Hello World
```

### File Encoding

```bash
# Encode file to Base64
base64 document.pdf > document.pdf.b64

# Decode back to file
cat document.pdf.b64 | base64 -d > document_restored.pdf

# Verify integrity
md5sum document.pdf document_restored.pdf
```

### URL-Safe Base64

```bash
# URL-safe encoding (replaces +/ with -_)
python3 -c "
import base64
data = b'Hello+World/Test='
encoded = base64.urlsafe_b64encode(data)
print(encoded.decode())
"

# Decode URL-safe
echo "SGVsbG8rV29ybGQvVGVzdD0=" | tr '_-' '/+' | base64 -d
```

### Image to Data URI

```bash
# Convert image to data URI for CSS/HTML
python3 -c "
import base64
import sys

with open('image.png', 'rb') as f:
    encoded = base64.b64encode(f.read()).decode()
    
ext = 'png'  # or 'jpeg', 'gif', 'svg+xml'
print(f'data:image/{ext};base64,{encoded[:50]}...')
"
```

### Basic Auth Header

```bash
# Create Basic Auth header
python3 -c "
import base64
credentials = 'username:password'
encoded = base64.b64encode(credentials.encode()).decode()
print(f'Authorization: Basic {encoded}')
"
```

### Decode JWT Payload (Base64)

```bash
# Decode JWT payload (middle section)
echo "eyJzdWIiOiIxMjM0NTY3ODkwIn0" | base64 -d 2>/dev/null || \
echo "eyJzdWIiOiIxMjM0NTY3ODkwIn0" | base64 -d

# Handle padding issues
python3 -c "
import base64
payload = 'eyJzdWIiOiIxMjM0NTY3ODkwIn0'
# Add padding if needed
padding = 4 - len(payload) % 4
if padding != 4:
    payload += '=' * padding
decoded = base64.urlsafe_b64decode(payload)
print(decoded.decode())
"
```

## Common Operations

| Task | Command |
|------|---------|
| Encode string | `echo -n "text" \| base64` |
| Decode string | `echo "b64text" \| base64 -d` |
| Encode file | `base64 file.bin > file.b64` |
| Decode file | `base64 -d file.b64 > file.bin` |
| Check valid | `base64 -d <<< "text" && echo "Valid"` |
| Strip newlines | `base64 -w 0 file` (Linux) |

## Python Module

```python
import base64

# String to Base64
text = "Hello World"
encoded = base64.b64encode(text.encode()).decode()
print(f"Encoded: {encoded}")

# Base64 to string
decoded = base64.b64decode(encoded).decode()
print(f"Decoded: {decoded}")

# File to Base64
with open('image.png', 'rb') as f:
    file_b64 = base64.b64encode(f.read()).decode()

# URL-safe encoding
url_safe = base64.urlsafe_b64encode(b'hello/world+test').decode()
```

## Data URI Examples

```css
/* Embedded background image */
.background {
  background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==');
}
```

```html
<!-- Embedded image -->
<img src="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEASABIAAD..." alt="Embedded">
```

## Validation

```bash
# Check if string is valid Base64
python3 -c "
import base64
import re

def is_valid_base64(s):
    pattern = r'^[A-Za-z0-9+/]*={0,2}$'
    if not re.match(pattern, s):
        return False
    try:
        base64.b64decode(s)
        return True
    except:
        return False

print(is_valid_base64('SGVsbG8gV29ybGQ='))  # True
print(is_valid_base64('Not@Valid#'))        # False
"
```
