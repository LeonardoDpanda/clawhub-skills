---
name: jwt-token-inspector
description: Decode, verify, and inspect JWT (JSON Web Tokens) tokens. Use when users need to debug authentication tokens, inspect token payloads, verify signatures, check expiration times, or understand claims in OAuth/JWT workflows.
---

# JWT Token Inspector

Decode, inspect, and verify JWT tokens for debugging authentication and authorization.

## When to Use

- Debugging JWT authentication issues
- Inspecting token payload and claims
- Checking token expiration
- Verifying token signature
- Understanding OAuth token contents
- Troubleshooting "token expired" errors

## When NOT to Use

- To generate production tokens (use proper auth libraries)
- For token storage (decode only, don't log sensitive tokens)
- To bypass authentication (this tool is for debugging only)

## Usage Examples

### Decode JWT Payload

```bash
# Decode JWT header and payload (signature not decoded)
token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"

python3 -c "
import base64
import json

def decode_base64(data):
    padding = 4 - len(data) % 4
    if padding != 4:
        data += '=' * padding
    return base64.urlsafe_b64decode(data)

def decode_jwt(token):
    parts = token.split('.')
    if len(parts) != 3:
        return None, None
    
    header = json.loads(decode_base64(parts[0]))
    payload = json.loads(decode_base64(parts[1]))
    return header, payload

header, payload = decode_jwt('$token')
print('=== HEADER ===')
print(json.dumps(header, indent=2))
print('\n=== PAYLOAD ===')
print(json.dumps(payload, indent=2))
"
```

### Check Token Expiration

```bash
# Check if token is expired
python3 -c "
import base64
import json
import time

token = 'eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE3MDQwNjQwMDAsInN1YiI6InVzZXIxMjMifQ.signature'

def decode_jwt_payload(token):
    parts = token.split('.')
    padding = 4 - len(parts[1]) % 4
    if padding != 4:
        parts[1] += '=' * padding
    return json.loads(base64.urlsafe_b64decode(parts[1]))

payload = decode_jwt_payload(token)
exp = payload.get('exp')

if exp:
    exp_time = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(exp))
    current = time.time()
    
    if current > exp:
        print(f'❌ Token EXPIRED at {exp_time}')
    else:
        remaining = int(exp - current)
        print(f'✅ Token valid until {exp_time}')
        print(f'   Time remaining: {remaining // 3600}h {(remaining % 3600) // 60}m')
else:
    print('ℹ️ No expiration claim found')
"
```

### Inspect Common Claims

```bash
# Pretty print JWT claims
python3 -c "
import base64
import json

token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJleHAiOjE1MTYyNDAwMDAsInJvbGUiOiJhZG1pbiIsImVtYWlsIjoidXNlckBleGFtcGxlLmNvbSJ9.sample'

def decode_jwt(token):
    parts = token.split('.')
    padding = 4 - len(parts[1]) % 4
    if padding != 4:
        parts[1] += '=' * padding
    return json.loads(base64.urlsafe_b64decode(parts[1]))

payload = decode_jwt(token)

claim_descriptions = {
    'sub': 'Subject (user identifier)',
    'iss': 'Issuer',
    'aud': 'Audience',
    'exp': 'Expiration Time',
    'nbf': 'Not Before',
    'iat': 'Issued At',
    'jti': 'JWT ID',
    'role': 'User Role',
    'email': 'Email Address',
    'name': 'Display Name'
}

print('=== JWT CLAIMS ===')
for claim, value in payload.items():
    desc = claim_descriptions.get(claim, 'Custom Claim')
    print(f'{claim:10} ({desc}): {value}')
"
```

## Common JWT Claims

| Claim | Full Name | Description |
|-------|-----------|-------------|
| `sub` | Subject | User identifier |
| `iss` | Issuer | Who issued the token |
| `aud` | Audience | Intended recipient |
| `exp` | Expiration | Unix timestamp when token expires |
| `nbf` | Not Before | Token valid after this time |
| `iat` | Issued At | When token was created |
| `jti` | JWT ID | Unique token identifier |

## Python Module

```python
import jwt
import base64
import json

# Decode without verification (for debugging only)
decoded = jwt.decode(token, options={"verify_signature": False})
print(decoded)

# Or manual decode
parts = token.split('.')
header = json.loads(base64.urlsafe_b64decode(parts[0] + '=='))
payload = json.loads(base64.urlsafe_b64decode(parts[1] + '=='))
```

## Security Notes

⚠️ **Warning**: Only use this tool for debugging your own tokens. Never:
- Paste production tokens into untrusted tools
- Log tokens with sensitive claims
- Share decoded tokens containing PII

## Quick Reference

```bash
# One-liner decode
echo "TOKEN" | cut -d'.' -f2 | base64 -d 2>/dev/null || echo "PART" | base64 -d

# Full decode with Python
python3 -c "import base64, json; t='TOKEN'; p=t.split('.'); print(json.dumps(json.loads(base64.urlsafe_b64decode(p[1]+'==')), indent=2))"
```
