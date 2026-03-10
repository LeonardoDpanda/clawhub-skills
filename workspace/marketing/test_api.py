#!/usr/bin/env python3
"""
测试 X API 连接
"""

import json
import urllib.request
import urllib.error
import sys

BEARER_TOKEN = "AAAAAAAAAAAAAAAAAAAAADaa8AEAAAAA0P1MAna9qVQXqyWBxuvsl0LTEvA%3DJQDk7YM57qCCQlfdY1E0vjqIK4OkiAK86rQ4Rs9JLrRUTdPfKk"

def test_connection():
    """测试 API 连接"""
    url = "https://api.twitter.com/2/users/me"
    headers = {
        "Authorization": f"Bearer {BEARER_TOKEN}"
    }
    
    try:
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req, timeout=15) as response:
            data = json.loads(response.read().decode())
            user = data.get('data', {})
            print(f"✅ API 连接成功!")
            print(f"   用户名: @{user.get('username', 'N/A')}")
            print(f"   用户ID: {user.get('id', 'N/A')}")
            print(f"   名称: {user.get('name', 'N/A')}")
            return True
    except urllib.error.HTTPError as e:
        print(f"❌ API 错误: {e.code}")
        error_body = e.read().decode()
        try:
            error_data = json.loads(error_body)
            print(f"   详情: {error_data}")
        except:
            print(f"   响应: {error_body}")
        return False
    except urllib.error.URLError as e:
        print(f"❌ 连接错误: {e.reason}")
        return False
    except Exception as e:
        print(f"❌ 错误: {e}")
        return False

if __name__ == "__main__":
    success = test_connection()
    sys.exit(0 if success else 1)
