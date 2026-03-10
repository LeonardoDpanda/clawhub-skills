---
name: color-code-converter
description: Convert between color formats including HEX, RGB, RGBA, HSL, HSV, and CMYK. Use when users need to convert colors for web design, CSS styling, image editing, or color palette creation. Supports batch conversion and color harmony generation.
---

# Color Code Converter

Convert colors between formats and generate harmonious color palettes.

## When to Use

- Converting brand colors between formats
- Creating CSS color schemes
- Matching colors across design tools
- Generating color palettes
- Converting RGBA to HEX with alpha

## When NOT to Use

- For image color extraction (use image processing tools)
- When precise print color matching is needed (use Pantone)

## Usage Examples

### HEX to RGB

```bash
# Convert HEX to RGB
python3 -c "
hex_color = '#FF5733'
hex_color = hex_color.lstrip('#')
r = int(hex_color[0:2], 16)
g = int(hex_color[2:4], 16)
b = int(hex_color[4:6], 16)
print(f'RGB: rgb({r}, {g}, {b})')
print(f'RGB CSS: {r}, {g}, {b}')
"
```

### RGB to HEX

```bash
# Convert RGB to HEX
python3 -c "
r, g, b = 255, 87, 51
hex_color = f'#{r:02x}{g:02x}{b:02x}'
print(f'HEX: {hex_color.upper()}')
"
```

### RGB to HSL

```bash
# Convert RGB to HSL
python3 -c "
def rgb_to_hsl(r, g, b):
    r, g, b = r/255.0, g/255.0, b/255.0
    max_c, min_c = max(r, g, b), min(r, g, b)
    l = (max_c + min_c) / 2
    
    if max_c == min_c:
        h = s = 0
    else:
        d = max_c - min_c
        s = d / (2 - max_c - min_c) if l > 0.5 else d / (max_c + min_c)
        if max_c == r: h = (g - b) / d + (6 if g < b else 0)
        elif max_c == g: h = (b - r) / d + 2
        else: h = (r - g) / d + 4
        h /= 6
    
    return round(h * 360), round(s * 100), round(l * 100)

h, s, l = rgb_to_hsl(255, 87, 51)
print(f'HSL: hsl({h}, {s}%, {l}%)')
"
```

### Generate Color Shades

```bash
# Generate lighter/darker shades
python3 -c "
def hex_to_rgb(hex_c):
    hex_c = hex_c.lstrip('#')
    return tuple(int(hex_c[i:i+2], 16) for i in (0, 2, 4))

def rgb_to_hex(rgb):
    return '#{:02x}{:02x}{:02x}'.format(*rgb).upper()

def adjust_brightness(rgb, factor):
    return tuple(min(255, max(0, int(c * factor))) for c in rgb)

base = '#FF5733'
rgb = hex_to_rgb(base)

print(f'Base: {base}')
print(f'Lighter (20%): {rgb_to_hex(adjust_brightness(rgb, 1.2))}')
print(f'Darker (20%): {rgb_to_hex(adjust_brightness(rgb, 0.8))}')
"
```

## Supported Formats

| Format | Example | Description |
|--------|---------|-------------|
| HEX | `#FF5733` | 6-digit hexadecimal |
| HEX Short | `#F53` | 3-digit shorthand |
| RGB | `rgb(255, 87, 51)` | Red, Green, Blue (0-255) |
| RGBA | `rgba(255, 87, 51, 0.8)` | RGB with alpha (0-1) |
| HSL | `hsl(9, 100%, 60%)` | Hue (0-360), Saturation, Lightness |
| HSV | `hsv(9, 80%, 100%)` | Hue, Saturation, Value |
| CMYK | `cmyk(0%, 66%, 80%, 0%)` | Cyan, Magenta, Yellow, Black |

## Color Harmony

```bash
# Generate complementary colors
python3 -c "
def complementary(hsl):
    h, s, l = hsl
    return ((h + 180) % 360, s, l)

# Generate triadic colors
def triadic(hsl):
    h, s, l = hsl
    return [(h, s, l), ((h + 120) % 360, s, l), ((h + 240) % 360, s, l)]

base = (9, 100, 60)  # HSL
print(f'Base: hsl{base}')
print(f'Complementary: hsl{complementary(base)}')
print('Triadic:', [f'hsl{c}' for c in triadic(base)])
"
```

## Quick Reference

| Action | Command |
|--------|---------|
| HEX → RGB | `tuple(int(hex[i:i+2], 16) for i in (0, 2, 4))` |
| RGB → HEX | `'#{:02x}{:02x}{:02x}'.format(r, g, b)` |
| RGB → HSL | Use colorsys module |
| Lighten | Multiply RGB values by factor > 1 |
| Darken | Multiply RGB values by factor < 1 |

## Python Module

```python
import colorsys

# RGB to HLS (note: colorsys uses HLS, not HSL)
r, g, b = 255/255, 87/255, 51/255
h, l, s = colorsys.rgb_to_hls(r, g, b)
print(f'HSL: ({h*360:.0f}, {s*100:.0f}%, {l*100:.0f}%)')
```
