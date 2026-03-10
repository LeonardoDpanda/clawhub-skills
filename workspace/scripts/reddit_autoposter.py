#!/usr/bin/env python3
"""
Reddit Auto Poster - GitHub Actions Version
Posts promotional content to multiple subreddits
"""

import json
import os
import sys
import argparse
from datetime import datetime

# Try PRAW first, fallback to playwright
try:
    import praw
    HAS_PRAW = True
except ImportError:
    HAS_PRAW = False

def get_credentials():
    """Get Reddit credentials from environment"""
    return {
        "username": os.getenv("REDDIT_USERNAME"),
        "password": os.getenv("REDDIT_PASSWORD"),
        "client_id": os.getenv("REDDIT_CLIENT_ID"),
        "client_secret": os.getenv("REDDIT_CLIENT_SECRET")
    }

def load_promotion_content():
    """Load prepared promotion content"""
    content = {
        "commandline": {
            "title": "I built 35+ CLI productivity tools that integrate with OpenClaw - All free on GitHub",
            "content": """Hey r/commandline!

I've been building a collection of CLI-focused Skills for OpenClaw (an AI assistant platform). These are tools I actually use daily:

**File & Text Tools:**
- batch-file-renamer - Rename files with regex and patterns
- text-diff-comparator - Compare files and generate patches
- markdown-formatter - Lint and format MD files

**Dev Tools:**
- rest-api-tester - Test APIs with custom headers
- cron-expression-parser - Human-readable cron explanations
- json-path-query - Extract data from JSON

All are open source and free. Would love feedback from this community!

🔗 GitHub: https://github.com/LeonardoDpanda/clawhub-skills

What other CLI tools would you want to see?"""
        },
        "webdev": {
            "title": "Built 35 Developer Tools for API Testing, Security Headers & SSL Checks",
            "content": """Hey r/webdev!

I've created a collection of web development tools that integrate directly into OpenClaw (AI assistant). No context switching needed.

**API & Security:**
- ssl-certificate-checker - Monitor cert expiry
- http-headers-analyzer - Security & performance audit
- rest-api-tester - Full-featured API client
- jwt-token-inspector - Decode and verify JWTs

**Data Tools:**
- json-schema-validator - Validate API responses
- csv-data-analyzer - Quick data quality reports
- url-shortener-expander - Security-check short links

Everything is free and open source. Check it out!

🔗 https://github.com/LeonardoDpanda/clawhub-skills

What web dev tools do you use daily that could be automated?"""
        },
        "selfhosted": {
            "title": "35 Self-Hosted Data Privacy Tools - Docker, Cron, System Monitoring",
            "content": """Hey r/selfhosted!

Built a collection of privacy-focused tools for OpenClaw that work great in self-hosted environments:

**Monitoring:**
- system-health-check - CPU/memory/disk monitoring
- website-monitor - Uptime tracking with alerts
- docker-compose-validator - Config linting

**Data Processing:**
- csv-processor - Local data transformation
- data-format-converter - JSON/YAML/CSV/XML
- password-generator - Offline secure passwords

**Scheduling:**
- cron-expression-parser - Human-readable schedules
- meeting-summarizer - Local transcription (no cloud)

All run locally, no data leaves your machine.

🔗 https://github.com/LeonardoDpanda/clawhub-skills

What self-hosted tools are on your wishlist?"""
        }
    }
    return content

def post_with_praw(subreddit, title, content, creds):
    """Post using PRAW (Reddit API)"""
    try:
        reddit = praw.Reddit(
            client_id=creds["client_id"],
            client_secret=creds["client_secret"],
            username=creds["username"],
            password=creds["password"],
            user_agent="ClawHub Skills Promoter v1.0"
        )
        
        sub = reddit.subreddit(subreddit)
        submission = sub.submit(title, selftext=content)
        
        print(f"✅ Posted to r/{subreddit}: {submission.url}")
        return True, submission.url
        
    except Exception as e:
        print(f"❌ r/{subreddit}: {str(e)}")
        return False, str(e)

def update_heartbeat_state(results):
    """Update heartbeat state with results"""
    state_path = "memory/heartbeat-state.json"
    
    try:
        with open(state_path, 'r') as f:
            state = json.load(f)
    except:
        state = {}
    
    if "promotionStatus" not in state:
        state["promotionStatus"] = {}
    
    state["promotionStatus"]["redditPostsToday"] = sum(1 for r in results if r[1])
    state["promotionStatus"]["lastRedditPostTime"] = datetime.now().isoformat()
    state["promotionStatus"]["redditAutoPostStatus"] = "completed"
    
    with open(state_path, 'w') as f:
        json.dump(state, f, indent=2)
    
    print(f"\n📊 Updated heartbeat state")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--subreddits", default="commandline,webdev,selfhosted",
                       help="Comma-separated list of subreddits")
    args = parser.parse_args()
    
    print("🚀 Starting Reddit Auto Poster\n")
    
    # Check credentials
    creds = get_credentials()
    if not all([creds["username"], creds["password"]]):
        print("❌ Reddit credentials not configured")
        sys.exit(1)
    
    # Load content
    content_map = load_promotion_content()
    subreddits = [s.strip() for s in args.subreddits.split(",")]
    
    print(f"📋 Target subreddits: {subreddits}\n")
    
    # Post to each subreddit
    results = []
    
    for subreddit in subreddits:
        if subreddit not in content_map:
            print(f"⚠️  No content prepared for r/{subreddit}, skipping")
            continue
        
        post = content_map[subreddit]
        
        if HAS_PRAW and creds["client_id"]:
            success, result = post_with_praw(subreddit, post["title"], post["content"], creds)
        else:
            print(f"⏭️  r/{subreddit}: PRAW not available, would post:")
            print(f"   Title: {post['title'][:50]}...")
            success, result = False, "PRAW not available"
        
        results.append((subreddit, success, result))
    
    # Summary
    success_count = sum(1 for r in results if r[1])
    print(f"\n📊 Summary:")
    print(f"   ✅ Posted: {success_count}/{len(results)}")
    
    for sub, success, result in results:
        status = "✅" if success else "❌"
        print(f"   {status} r/{sub}: {result if success else 'Failed'}")
    
    # Update state
    update_heartbeat_state(results)
    
    if success_count < len(results):
        sys.exit(1)
    
    print("\n✨ All done!")

if __name__ == "__main__":
    main()
