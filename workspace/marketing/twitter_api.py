#!/usr/bin/env python3
"""
X (Twitter) API 测试和推文发布脚本
使用方法: python3 twitter_api.py
"""

import os
import json
import urllib.request
import urllib.error
from urllib.parse import urlencode
import base64
import hmac
import hashlib
import time

# X API 凭证
API_KEY = "zht8UIxLcSWiA8KIkFV9lqYYt"
API_SECRET = "GBm0Xqj9yNiJl9DkIpMO9MmPYoDBISvEZaltgqzfoDDUEDwchh"
BEARER_TOKEN = "AAAAAAAAAAAAAAAAAAAAADaa8AEAAAAA0P1MAna9qVQXqyWBxuvsl0LTEvA%3DJQDk7YM57qCCQlfdY1E0vjqIK4OkiAK86rQ4Rs9JLrRUTdPfKk"

def test_bearer_token():
    """测试 Bearer Token 是否有效"""
    print("=" * 50)
    print("测试 Bearer Token...")
    print("=" * 50)
    
    url = "https://api.twitter.com/2/users/me"
    headers = {
        "Authorization": f"Bearer {BEARER_TOKEN}"
    }
    
    try:
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req, timeout=10) as response:
            data = json.loads(response.read().decode())
            print("✅ Bearer Token 有效!")
            print(f"用户名: @{data.get('data', {}).get('username', 'N/A')}")
            print(f"用户ID: {data.get('data', {}).get('id', 'N/A')}")
            return True, data.get('data', {}).get('id')
    except urllib.error.HTTPError as e:
        print(f"❌ Bearer Token 无效: {e.code}")
        print(e.read().decode())
        return False, None
    except Exception as e:
        print(f"❌ 连接错误: {e}")
        return False, None

def create_tweet_v2(text):
    """使用 Twitter API v2 发布推文"""
    print("\n" + "=" * 50)
    print("发布推文...")
    print("=" * 50)
    
    url = "https://api.twitter.com/2/tweets"
    headers = {
        "Authorization": f"Bearer {BEARER_TOKEN}",
        "Content-Type": "application/json"
    }
    payload = json.dumps({"text": text}).encode()
    
    try:
        req = urllib.request.Request(url, data=payload, headers=headers, method="POST")
        with urllib.request.urlopen(req, timeout=10) as response:
            data = json.loads(response.read().decode())
            print("✅ 推文发布成功!")
            print(f"推文ID: {data.get('data', {}).get('id')}")
            tweet_id = data.get('data', {}).get('id')
            print(f"链接: https://twitter.com/user/status/{tweet_id}")
            return True, data
    except urllib.error.HTTPError as e:
        print(f"❌ 发布失败: {e.code}")
        print(e.read().decode())
        return False, None
    except Exception as e:
        print(f"❌ 错误: {e}")
        return False, None

def get_user_tweets(user_id):
    """获取用户最近的推文"""
    print("\n" + "=" * 50)
    print("获取最近推文...")
    print("=" * 50)
    
    url = f"https://api.twitter.com/2/users/{user_id}/tweets?max_results=5"
    headers = {
        "Authorization": f"Bearer {BEARER_TOKEN}"
    }
    
    try:
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req, timeout=10) as response:
            data = json.loads(response.read().decode())
            print("✅ 获取成功!")
            tweets = data.get('data', [])
            for tweet in tweets:
                print(f"- {tweet.get('text', '')[:50]}...")
            return tweets
    except Exception as e:
        print(f"❌ 错误: {e}")
        return []

def main():
    print("🚀 X (Twitter) API 测试工具")
    print("=" * 50)
    
    # 测试 API 连接
    valid, user_id = test_bearer_token()
    
    if valid:
        print("\n✅ API 凭证验证成功!")
        
        # 获取最近推文
        if user_id:
            get_user_tweets(user_id)
        
        # 询问是否发布测试推文
        print("\n" + "=" * 50)
        response = input("是否发布首条推文? (y/n): ")
        if response.lower() == 'y':
            first_tweet = """🚀 刚发布了一套开发者工具集

用OpenClaw写了15+ CLI工具，帮我省了几百小时：

✅ API测试 - 比Postman快10倍启动
✅ 文件批量重命名 - 1000张照片60秒搞定  
✅ 配置格式转换 - JSON/YAML/TOML秒切
✅ QR码生成 - 专业无广告

用命令行的人懂这个痛点

#OpenClaw #DevTools #CLI"""
            create_tweet_v2(first_tweet)
    else:
        print("\n❌ API 凭证无效，请检查:")
        print("1. Bearer Token 是否正确")
        print("2. 是否需要在 X Developer Portal 配置权限")
        print("3. 访问 https://developer.twitter.com/en/portal/dashboard")

if __name__ == "__main__":
    main()
