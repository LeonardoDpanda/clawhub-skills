#!/usr/bin/env python3
"""
ClawHub Batch Publisher - GitHub Actions Version
Publishes all pending Skills to ClawHub via API
"""

import json
import os
import sys
import requests
from pathlib import Path

CLAWHUB_API = "https://clawhub.ai/api/v1"
REGISTRY_PATH = "memory/skill-registry.json"

def get_api_token():
    """Get API token from environment"""
    token = os.getenv("CLAWHUB_API_TOKEN")
    if not token:
        print("❌ CLAWHUB_API_TOKEN not set")
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
    """Get skills ready for publication"""
    pending = []
    for skill in registry.get("skills", []):
        if skill.get("publishStatus") == "已准备(待API)":
            pending.append(skill)
    return pending

def publish_skill(skill, token):
    """Publish a single skill to ClawHub"""
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    payload = {
        "name": skill["name"],
        "description": skill["description"],
        "tags": ["developer-tools", "automation"],
        "license": "MIT-0",
        "sourceUrl": skill.get("githubPath", ""),
        "price": skill.get("priceUSD", 0)
    }
    
    try:
        response = requests.post(
            f"{CLAWHUB_API}/skills",
            headers=headers,
            json=payload,
            timeout=30
        )
        
        if response.status_code == 201:
            print(f"✅ Published: {skill['name']}")
            return True, response.json().get("url", "")
        elif response.status_code == 400 and "MIT-0" in response.text:
            print(f"⚠️  {skill['name']}: MIT-0 license not accepted")
            return False, "MIT-0_LICENSE_REQUIRED"
        else:
            print(f"❌ {skill['name']}: {response.status_code} - {response.text}")
            return False, response.text
            
    except Exception as e:
        print(f"❌ {skill['name']}: {str(e)}")
        return False, str(e)

def main():
    print("🚀 Starting ClawHub Batch Publisher\n")
    
    token = get_api_token()
    registry = load_registry()
    pending = get_pending_skills(registry)
    
    print(f"📋 Found {len(pending)} skills ready for publication\n")
    
    if not pending:
        print("✨ No pending skills found")
        return
    
    # Check for dry run
    dry_run = os.getenv("DRY_RUN", "false").lower() == "true"
    if dry_run:
        print("🔍 DRY RUN MODE - No actual publishing\n")
        for skill in pending:
            print(f"Would publish: {skill['name']}")
        return
    
    # Publish skills
    success_count = 0
    failed_count = 0
    mit0_blocked = False
    
    for skill in pending:
        success, result = publish_skill(skill, token)
        
        if success:
            success_count += 1
            skill["publishStatus"] = "已发布"
            skill["clawhubUrl"] = result
        else:
            failed_count += 1
            if result == "MIT-0_LICENSE_REQUIRED":
                mit0_blocked = True
    
    # Save registry
    save_registry(registry)
    
    # Summary
    print(f"\n📊 Summary:")
    print(f"   ✅ Published: {success_count}")
    print(f"   ❌ Failed: {failed_count}")
    
    if mit0_blocked:
        print(f"\n⚠️  MIT-0 license must be accepted at https://clawhub.ai")
        sys.exit(1)
    
    if failed_count > 0:
        sys.exit(1)
    
    print("\n✨ All done!")

if __name__ == "__main__":
    main()
