---
name: password-generator
description: Generate secure, customizable passwords and passphrases with configurable length, character sets, and entropy requirements. Use when creating strong passwords for accounts, generating API keys, creating secure tokens, or testing password strength. NOT for recovering lost passwords or cracking existing passwords.
---

# Password Generator

Generate cryptographically secure passwords with full customization control.

## When to Use

- Creating strong passwords for new accounts
- Generating API keys and access tokens
- Setting up secure database credentials
- Creating temporary secure passwords for sharing
- Testing password strength requirements
- Generating WPA2/WPA3 WiFi passwords

## When NOT to Use

- Recovering forgotten passwords (this generates new ones)
- Password cracking or brute force attacks
- Storing passwords without a secure vault
- Reusing generated passwords across multiple critical accounts

## Quick Start

```bash
# Generate a strong 16-character password
password-generator --length 16

# Generate password with specific requirements
password-generator --length 20 --uppercase --lowercase --numbers --symbols

# Generate memorable passphrase (Diceware style)
password-generator --passphrase --words 6

# Generate multiple passwords at once
password-generator --length 12 --count 5
```

## Features

### Password Types

| Type | Description | Example |
|------|-------------|---------|
| Random | Full character randomization | `K9#mP2$vL7@nQ4` |
| Memorable | Diceware-style passphrase | `correct-horse-battery-staple` |
| PIN | Numeric only | `739284` |
| Alphanumeric | Letters + numbers only | `aK3mP9vL2nQ7` |
| Token | URL-safe base64 | `a3K9mP_2vL7nQ4` |

### Character Sets

Control exactly which characters are allowed:

```bash
# Uppercase letters (A-Z)
password-generator --uppercase

# Lowercase letters (a-z)
password-generator --lowercase

# Numbers (0-9)
password-generator --numbers

# Special symbols (!@#$%^&*)
password-generator --symbols

# Custom character set
password-generator --custom "ABCDEF123456"

# Exclude ambiguous characters (0, O, l, 1, I)
password-generator --no-ambiguous
```

## Advanced Usage

### Entropy-Based Generation

Specify minimum entropy instead of length:

```bash
# 128-bit entropy (bank-grade)
password-generator --entropy 128

# 256-bit entropy (maximum security)
password-generator --entropy 256
```

### Pattern Requirements

```bash
# Require at least 2 of each character type
password-generator --length 16 --min-upper 2 --min-lower 2 --min-numbers 2 --min-symbols 2

# Exclude specific characters
password-generator --exclude "0OIl"

# Start with letter (for systems that require it)
password-generator --start-alpha
```

### Passphrase Generation

```bash
# 6-word passphrase (77-bit entropy)
password-generator --passphrase --words 6

# With custom word separator
password-generator --passphrase --words 5 --separator "_"

# Capitalize words
password-generator --passphrase --words 6 --capitalize

# Include number substitution
password-generator --passphrase --words 5 --substitute-numbers
```

## Output Formats

```bash
# Copy to clipboard automatically
password-generator --length 20 --clipboard

# Output as JSON for scripting
password-generator --length 16 --json
# Output: {"password": "K9#mP2$vL7@nQ4wX", "entropy": 105.2}

# Silent mode (password only, for piping)
password-generator --length 20 --silent | pbcopy

# Save to file securely (600 permissions)
password-generator --length 32 --save ~/.ssh/db_password
```

## Security Considerations

### Generation Source

Uses system CSPRNG (Cryptographically Secure Pseudo-Random Number Generator):
- Linux: `/dev/urandom`
- macOS: `arc4random`
- Windows: `BCryptGenRandom`

### Best Practices

1. **Minimum 12 characters** for general use
2. **Minimum 16 characters** for sensitive accounts
3. **20+ characters** for high-security applications
4. **Never store plaintext** - use password managers
5. **Unique per account** - never reuse

### Entropy Reference

| Length | Types | Possible Combinations | Entropy |
|--------|-------|----------------------|---------|
| 8 | All | 6.6 × 10^15 | 52 bits |
| 12 | All | 4.7 × 10^23 | 79 bits |
| 16 | All | 3.4 × 10^31 | 105 bits |
| 20 | All | 2.4 × 10^39 | 131 bits |
| 6 words | Diceware | 2.2 × 10^23 | 77 bits |
| 8 words | Diceware | 1.4 × 10^31 | 103 bits |

## Examples by Use Case

### Banking/Medical (High Security)

```bash
password-generator --entropy 128 --json
```

### Email Account

```bash
password-generator --length 20 --no-ambiguous --clipboard
```

### WiFi Network

```bash
password-generator --length 24 --uppercase --lowercase --numbers --symbols
```

### Database User

```bash
password-generator --length 32 --silent > /secure/db_creds.txt
chmod 600 /secure/db_creds.txt
```

### Shared Temporary Access

```bash
password-generator --passphrase --words 4 --capitalize
# Output: Tiger-Blue-Mountain-Seven
```

## Integration Examples

### Shell Alias

```bash
alias pw='password-generator --length 16 --clipboard --no-ambiguous'
alias pwp='password-generator --passphrase --words 5 --clipboard'
```

### CI/CD Pipeline

```bash
# Generate database password for deployment
DB_PASSWORD=$(password-generator --length 32 --silent)
kubectl create secret generic db-secret --from-literal=password="$DB_PASSWORD"
```

### Python Script Integration

```python
import subprocess

result = subprocess.run(
    ['password-generator', '--length', '20', '--silent'],
    capture_output=True, text=True
)
password = result.stdout.strip()
```

## Troubleshooting

### "Insufficient entropy for requirements"

Your constraints are too strict for the length:
```bash
# ERROR: password-generator --length 8 --min-upper 3 --min-lower 3 --min-numbers 3
# Fix: Increase length or reduce minimum requirements
password-generator --length 12 --min-upper 2 --min-lower 2 --min-numbers 2
```

### System random source unavailable

Ensure your system has proper entropy:
```bash
# Check available entropy (Linux)
cat /proc/sys/kernel/random/entropy_avail

# Install haveged if needed
sudo apt-get install haveged
```

## Pricing

**$4 USD** - One-time purchase

Includes:
- Complete SKILL.md documentation
- All password generation modes
- Passphrase generation
- Entropy calculation
- Clipboard integration
- JSON output for scripting

---

*Generate passwords that even quantum computers will struggle with.*
