---
name: password-generator
description: Generate secure passwords with customizable length, character sets, and strength requirements. Use when creating strong passwords for accounts, generating API keys, setting up secure credentials, or needing cryptographically random strings. NOT for storing passwords, retrieving existing passwords, or password manager functionality.
---

# Password Generator

Generate cryptographically secure passwords with full customization options.

## When to Use

- Creating passwords for new accounts
- Generating API keys and secrets
- Setting up database credentials
- Creating secure tokens
- Needing random strings for testing

## When NOT to Use

- **DO NOT** use for storing or retrieving existing passwords
- **DO NOT** use as a password manager
- **DO NOT** use for sharing passwords over insecure channels
- **DO NOT** use for passwords you need to remember (use passphrases instead)

## Usage Examples

### Basic Password (Default 16 chars)
```
Generate a secure password
```

### Custom Length
```
Generate a 32-character password
```

### Include Specific Characters
```
Generate password with uppercase, lowercase, numbers, and symbols
```

### API Key Format
```
Generate a 40-character alphanumeric API key
```

### Passphrase (Memorable)
```
Generate a passphrase with 4 words
```

## Parameters

| Parameter | Default | Options |
|-----------|---------|---------|
| length | 16 | 8-128 |
| uppercase | true | true/false |
| lowercase | true | true/false |
| numbers | true | true/false |
| symbols | true | true/false |
| exclude_chars | "" | similar chars like '0O', 'l1' |
| count | 1 | 1-10 (generate multiple) |

## Output Formats

**Standard:**
```
🔐 Generated Password: X7m#pK9vL2$nQ4wR
Length: 16 characters
Strength: Strong (uppercase + lowercase + numbers + symbols)
Entropy: ~95 bits
```

**Multiple:**
```
🔐 Generated Passwords:
1. X7m#pK9vL2$nQ4wR
2. Bt5&jM8qP3!wE6zX
3. Hn2@fR4yK7#mD9vL
```

**Passphrase:**
```
🔐 Generated Passphrase: correct-horse-battery-staple
Words: 4
Strength: Very Strong (~44 bits entropy per word)
```

## Strength Guidelines

| Use Case | Minimum Length | Character Sets |
|----------|---------------|----------------|
| Online accounts | 12 | All 4 types |
| Banking/Finance | 16 | All 4 types |
| API keys | 32 | Alphanumeric |
| Encryption keys | 64 | All 4 types |
| Temporary/Testing | 8 | At least 2 types |

## Security Notes

- Uses cryptographically secure random number generation
- Generated passwords are NOT stored
- Copy to clipboard with confirmation
- Auto-clear clipboard after 60 seconds (if supported)
- No network transmission of generated passwords

## Common Patterns

### Quick Strong Password
```
Password 20 chars with all types
```

### Simple Alphanumeric
```
Generate alphanumeric password 24 chars, no symbols
```

### Word-Based Passphrase
```
Generate passphrase 6 words hyphen-separated
```

### Multiple Options
```
Generate 5 passwords 12 chars each
```
