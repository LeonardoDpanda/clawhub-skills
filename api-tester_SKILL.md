---
name: rest-api-tester
description: Test REST APIs with customizable headers, authentication, and request bodies. Use when debugging API endpoints, testing authentication flows, validating responses, or automating API checks. Supports GET, POST, PUT, DELETE, PATCH methods with JSON, form-data, and raw body formats. Ideal for developers testing webhooks, microservices, and third-party integrations.
---

# REST API Tester

Test REST APIs with custom headers, auth, and request bodies.

## When to Use

- Debugging API endpoints during development
- Testing authentication flows
- Validating webhook payloads
- Checking API response times
- Automating health checks
- Testing third-party integrations

## ⚡ 版本对比

| 功能 | 免费版 | 专业版 |
|-----|--------|--------|
| GET/POST请求 | ✅ | ✅ |
| 基础Headers | ✅ | ✅ |
| 保存请求集合 | ❌ | ✅ |
| 自动化测试套件 | ❌ | ✅ |
| 性能基准测试 | ❌ | ✅ |
| 响应验证 | ❌ | ✅ |
| Webhook测试服务器 | ❌ | ✅ |
| 环境变量 | ❌ | ✅ |
| **价格** | **免费** | **$5 一次性** |

## 🚀 升级到专业版

### 购买授权码

- [Gumroad 购买 $5](https://9708247063907.gumroad.com/l/pzksc)

### 激活授权

```bash
# 激活专业版
clawhub config set rest-api-tester.license "YOUR_LICENSE_KEY"

# 验证激活状态
clawhub config get rest-api-tester.license
```

## Quick Start

### Simple GET Request

```python
import requests

def test_get(url, headers=None):
    """Test a GET endpoint"""
    try:
        response = requests.get(url, headers=headers, timeout=30)
        return {
            'status': response.status_code,
            'headers': dict(response.headers),
            'body': response.json() if response.headers.get('content-type', '').startswith('application/json') else response.text,
            'time': response.elapsed.total_seconds()
        }
    except Exception as e:
        return {'error': str(e)}

# Usage
test_get('https://api.github.com/users/octocat')
```

### POST with JSON Body

```python
def test_post(url, data, headers=None):
    """Test POST endpoint with JSON body"""
    default_headers = {'Content-Type': 'application/json'}
    if headers:
        default_headers.update(headers)
    
    try:
        response = requests.post(
            url, 
            json=data, 
            headers=default_headers,
            timeout=30
        )
        return {
            'status': response.status_code,
            'body': response.json() if response.headers.get('content-type', '').startswith('application/json') else response.text
        }
    except Exception as e:
        return {'error': str(e)}

# Usage
test_post('https://httpbin.org/post', {'key': 'value'})
```

### Test with Authentication

```python
def test_with_auth(url, token=None, username=None, password=None):
    """Test API with Bearer token or Basic auth"""
    headers = {}
    
    if token:
        headers['Authorization'] = f'Bearer {token}'
    elif username and password:
        import base64
        credentials = base64.b64encode(f'{username}:{password}'.encode()).decode()
        headers['Authorization'] = f'Basic {credentials}'
    
    return test_get(url, headers)

# Bearer token
test_with_auth('https://api.example.com/data', token='your_token_here')

# Basic auth
test_with_auth('https://api.example.com/data', username='admin', password='secret')
```

### Full API Test Suite (专业版)

```python
def comprehensive_api_test(base_url, endpoints):
    """Test multiple endpoints"""
    results = {}
    
    for endpoint, config in endpoints.items():
        url = f"{base_url}{config['path']}"
        method = config.get('method', 'GET')
        headers = config.get('headers', {})
        data = config.get('data')
        
        try:
            if method == 'GET':
                response = requests.get(url, headers=headers, timeout=30)
            elif method == 'POST':
                response = requests.post(url, json=data, headers=headers, timeout=30)
            elif method == 'PUT':
                response = requests.put(url, json=data, headers=headers, timeout=30)
            elif method == 'DELETE':
                response = requests.delete(url, headers=headers, timeout=30)
            
            results[endpoint] = {
                'status': response.status_code,
                'success': 200 <= response.status_code < 300,
                'time': response.elapsed.total_seconds()
            }
        except Exception as e:
            results[endpoint] = {'error': str(e), 'success': False}
    
    return results

# Usage
endpoints = {
    'health': {'path': '/health', 'method': 'GET'},
    'create_user': {'path': '/users', 'method': 'POST', 'data': {'name': 'Test'}},
    'get_user': {'path': '/users/1', 'method': 'GET'}
}

comprehensive_api_test('https://api.example.com', endpoints)
```

## Dependencies

```bash
pip install requests
```
