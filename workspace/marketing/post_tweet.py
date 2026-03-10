#!/usr/bin/env python3
"""
发布推文到 X (Twitter)
用法: python3 post_tweet.py "推文内容"
"""

import sys
import json
import urllib.request
import urllib.error
from urllib.parse import quote

BEARER_TOKEN = "AAAAAAAAAAAAAAAAAAAAADaa8AEAAAAA0P1MAna9qVQXqyWBxuvsl0LTEvA%3DJQDk7YM57qCCQlfdY1E0vjqIK4OkiAK86rQ4Rs9JLrRUTdPfKk"

def post_tweet(text):
    """发布推文到 X"""
    url = "https://api.twitter.com/2/tweets"
    headers = {
        "Authorization": f"Bearer {BEARER_TOKEN}",
        "Content-Type": "application/json"
    }
    payload = json.dumps({"text": text}).encode('utf-8')
    
    try:
        req = urllib.request.Request(url, data=payload, headers=headers, method="POST")
        with urllib.request.urlopen(req, timeout=15) as response:
            data = json.loads(response.read().decode())
            tweet_id = data.get('data', {}).get('id')
            print(f"✅ 推文发布成功!")
            print(f"推文ID: {tweet_id}")
            print(f"链接: https://twitter.com/i/web/status/{tweet_id}")
            return True
    except urllib.error.HTTPError as e:
        print(f"❌ HTTP错误: {e.code}")
        print(e.read().decode())
        return False
    except Exception as e:
        print(f"❌ 错误: {e}")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("用法: python3 post_tweet.py '推文内容'")
        sys.exit(1)
    
    tweet_text = sys.argv[1]
    
    # 验证推文长度
    if len(tweet_text) > 280:
        print(f"❌ 推文太长 ({len(tweet_text)} 字符)，限制280字符")
        sys.exit(1)
    
    success = post_tweet(tweet_text)
    sys.exit(0 if success else 1)
