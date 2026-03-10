#!/usr/bin/env python3
"""
Gumroad Batch Product Creator - GitHub Actions Version
Creates Gumroad products for all pending Skills
"""

import json
import os
import sys
import argparse
from pathlib import Path

# Try to import requests, fallback to urllib
try:
    import requests
    HAS_REQUESTS = True
except ImportError:
    HAS_REQUESTS = False
    import urllib.request
    import urllib.parse

GUMROAD_API = "https://api.gumroad.com/v2"
REGISTRY_PATH = "memory/skill-registry.json"

def get_access_token():
    """Get Gumroad access token"""
    token = os.getenv("GUMROAD_ACCESS_TOKEN")
    if not token:
        print("❌ GUMROAD_ACCESS_TOKEN not set")
        sys.exit(1)
    return token

def load_registry():
    """Load skill registry"""
    with open(REGISTRY_PATH, 'r') as f:
        return json.load(f)

def save_registry(registry):
    """Save updated registry"""
    with open(REGISTRY_PATH, 'w') as f:
        json.dump(registry, f, indent=2, ensure_ascii=False)

def get_pending_skills(registry):
    """Get skills waiting for Gumroad creation"""
    pending = []
    for skill in registry.get("skills", []):
        status = skill.get("monetizationStatus", "")
        if status in ["待上线", "待变现"]:
            pending.append(skill)
    return pending

def create_gumroad_product(skill, token):
    """Create a Gumroad product for a skill"""
    
    # Prepare product data
    name = skill["name"].replace("-", " ").title()
    description = f"""{skill['description']}

🎯 What you get:
- Complete SKILL.md documentation
- Working code examples
- Integration guides
- Free updates

💡 Perfect for OpenClaw users who want to boost their productivity.

🔗 GitHub: {skill.get('githubPath', 'Coming soon')}
"""
    
    price = skill.get("priceUSD", 5) * 100  # Convert to cents
    
    data = {
        "access_token": token,
        "name": f"{name} - OpenClaw Skill",
        "description": description,
        "price": price,
        "currency": "usd",
        "is_physical": "false",
        "is_recurring": "false"
    }
    
    try:
        if HAS_REQUESTS:
            response = requests.post(
                f"{GUMROAD_API}/products",
                data=data,
                timeout=30
            )
            
            if response.status_code == 200:
                result = response.json()
                if result.get("success"):
                    product = result.get("product", {})
                    print(f"✅ Created: {name}")
                    return True, product.get("short_url", product.get("url", ""))
                else:
                    print(f"❌ {name}: API returned failure")
                    return False, result
            else:
                print(f"❌ {name}: HTTP {response.status_code}")
                return False, response.text
        else:
            # Fallback to urllib
            encoded_data = urllib.parse.urlencode(data).encode('utf-8')
            req = urllib.request.Request(
                f"{GUMROAD_API}/products",
                data=encoded_data,
                method='POST'
            )
            with urllib.request.urlopen(req, timeout=30) as response:
                result = json.loads(response.read().decode('utf-8'))
                if result.get("success"):
                    product = result.get("product", {})
                    print(f"✅ Created: {name}")
                    return True, product.get("short_url", product.get("url", ""))
                else:
                    return False, result
                    
    except Exception as e:
        print(f"❌ {name}: {str(e)}")
        return False, str(e)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--batch-size", type=int, default=10, help="Number of products to create")
    args = parser.parse_args()
    
    print("🚀 Starting Gumroad Batch Creator\n")
    
    token = get_access_token()
    registry = load_registry()
    pending = get_pending_skills(registry)
    
    # Limit batch size
    to_process = pending[:args.batch_size]
    
    print(f"📋 Found {len(pending)} pending skills")
    print(f"🎯 Processing batch of {len(to_process)}\n")
    
    if not to_process:
        print("✨ No pending skills found")
        return
    
    # Create products
    success_count = 0
    failed_count = 0
    
    for skill in to_process:
        success, result = create_gumroad_product(skill, token)
        
        if success:
            success_count += 1
            skill["monetizationStatus"] = "已创建产品"
            skill["gumroadUrl"] = result
            skill["gumroadCreatedAt"] = "2026-03-11"
        else:
            failed_count += 1
    
    # Save registry
    save_registry(registry)
    
    # Save pending list
    remaining = pending[args.batch_size:]
    os.makedirs("logs", exist_ok=True)
    with open("logs/gumroad-batch-pending.md", 'w') as f:
        f.write(f"# Gumroad Pending Products\n\n")
        f.write(f"Remaining: {len(remaining)}\n\n")
        for s in remaining:
            f.write(f"- {s['name']} (${s.get('priceUSD', 5)})\n")
    
    # Summary
    print(f"\n📊 Summary:")
    print(f"   ✅ Created: {success_count}")
    print(f"   ❌ Failed: {failed_count}")
    print(f"   ⏳ Remaining: {len(remaining)}")
    
    if failed_count > 0:
        sys.exit(1)
    
    print("\n✨ Batch complete!")

if __name__ == "__main__":
    main()
