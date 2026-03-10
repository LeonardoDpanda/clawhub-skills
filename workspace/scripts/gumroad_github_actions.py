#!/usr/bin/env python3
"""
Gumroad 产品批量创建脚本 - GitHub Actions 版本
无界面模式运行
"""

import os
import sys
import json
import time
from playwright.sync_api import sync_playwright

# 从环境变量读取账号信息
GUMROAD_EMAIL = os.environ.get('GUMROAD_EMAIL')
GUMROAD_PASSWORD = os.environ.get('GUMROAD_PASSWORD')

# 要创建的产品列表
PRODUCTS = [
    {
        "name": "SSL Certificate Checker",
        "price": 5,
        "description": """🔒 Professional SSL/TLS certificate analysis tool

Quickly verify HTTPS security, monitor certificate expiration, and troubleshoot SSL issues for any domain.

✅ Features:
• Check certificate expiration dates
• Verify certificate chain and issuer
• View cipher suites and security config
• Calculate days until expiry
• Generate full security reports

💡 Perfect for DevOps engineers and system administrators

📦 Includes: Complete SKILL.md with examples and scripts""",
        "url": "ssl-certificate-checker",
        "tags": "ssl, tls, security, devops, certificate"
    },
    {
        "name": "JWT Token Inspector",
        "price": 5,
        "description": """🔑 Decode and inspect JWT tokens instantly

Essential tool for API developers debugging authentication issues.

✅ Features:
• Decode JWT headers and payload
• Verify token signatures
• Debug auth flow problems
• Support for common JWT libraries

💡 Perfect for backend developers and API engineers

📦 Includes: Complete documentation and usage examples""",
        "url": "jwt-token-inspector",
        "tags": "jwt, token, api, authentication, security"
    },
    {
        "name": "HTTP Headers Analyzer",
        "price": 4,
        "description": """🔍 Analyze HTTP headers for security and performance

Comprehensive HTTP response header analysis for web developers.

✅ Features:
• Security headers check (HSTS, CSP, X-Frame-Options)
• Performance settings analysis
• Caching configuration review
• Missing headers warnings

💡 Perfect for web developers and security auditors

📦 Includes: Detailed analysis guide and best practices""",
        "url": "http-headers-analyzer",
        "tags": "http, headers, security, performance, webdev"
    },
    {
        "name": "Docker Compose Validator",
        "price": 6,
        "description": """🐳 Validate Docker Compose files before deployment

Catch errors and security issues in your docker-compose.yml files.

✅ Features:
• Syntax error detection
• Security best practices check
• Common misconfiguration warnings
• Deprecated option alerts

💡 Perfect for DevOps engineers and container developers

📦 Includes: Validation scripts and configuration guide""",
        "url": "docker-compose-validator",
        "tags": "docker, compose, devops, validation, containers"
    },
    {
        "name": "JSON Path Query",
        "price": 5,
        "description": """📊 Query JSON data like a pro

Extract and filter data from complex JSON structures using JSONPath syntax.

✅ Features:
• JSONPath expression support
• Nested data extraction
• Array filtering
• API response processing

💡 Perfect for data engineers and API developers

📦 Includes: Query examples and syntax reference""",
        "url": "json-path-query",
        "tags": "json, query, data, api, extraction"
    }
]

def create_product(page, product, index, total):
    """创建单个产品"""
    print(f"\n[{index+1}/{total}] Creating: {product['name']}")
    
    try:
        # 进入产品创建页面
        page.goto("https://app.gumroad.com/products/new")
        time.sleep(3)
        
        # 选择 Digital product
        digital_btn = page.locator('text=Digital product').first
        if digital_btn.is_visible():
            digital_btn.click()
            time.sleep(2)
        
        # 填写产品名称
        name_input = page.locator('input[name="name"], input[placeholder*="name" i]').first
        name_input.fill(product['name'])
        time.sleep(1)
        
        # 填写价格
        price_input = page.locator('input[name="price"], input[placeholder*="price" i]').first
        price_input.fill(str(product['price']))
        time.sleep(1)
        
        # 填写描述
        desc_input = page.locator('textarea[name="description"], textarea[placeholder*="description" i]').first
        desc_input.fill(product['description'])
        time.sleep(1)
        
        # 填写自定义 URL
        url_input = page.locator('input[name="custom_permalink"], input[placeholder*="URL" i]').first
        if url_input.is_visible():
            url_input.fill(product['url'])
            time.sleep(1)
        
        # 点击保存/发布
        save_btn = page.locator('button:has-text("Save"), button:has-text("Publish"), button[type="submit"]').first
        save_btn.click()
        time.sleep(5)
        
        print(f"✅ Success: {product['name']}")
        return True
        
    except Exception as e:
        print(f"❌ Failed: {product['name']} - {str(e)}")
        # 保存截图用于调试
        page.screenshot(path=f"error_{product['url']}.png")
        return False

def main():
    print("=" * 60)
    print("Gumroad Auto Product Creator - GitHub Actions")
    print("=" * 60)
    
    if not GUMROAD_EMAIL or not GUMROAD_PASSWORD:
        print("\n❌ Error: GUMROAD_EMAIL and GUMROAD_PASSWORD must be set!")
        sys.exit(1)
    
    with sync_playwright() as p:
        # 启动浏览器（无界面模式）
        browser = p.chromium.launch(headless=True)
        context = browser.new_context(
            viewport={'width': 1280, 'height': 800},
            user_agent='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        )
        page = context.new_page()
        
        try:
            # 登录 Gumroad
            print("\n🔄 Logging in to Gumroad...")
            page.goto("https://app.gumroad.com/login")
            time.sleep(3)
            
            # 填写邮箱
            email_input = page.locator('input[name="email"], input[type="email"]').first
            email_input.fill(GUMROAD_EMAIL)
            time.sleep(1)
            
            # 填写密码
            password_input = page.locator('input[name="password"], input[type="password"]').first
            password_input.fill(GUMROAD_PASSWORD)
            time.sleep(1)
            
            # 点击登录
            login_btn = page.locator('button[type="submit"]').first
            login_btn.click()
            time.sleep(5)
            
            # 检查是否登录成功
            if "login" in page.url:
                print("❌ Login failed! Check credentials.")
                page.screenshot(path="login_error.png")
                sys.exit(1)
            
            print("✅ Login successful!\n")
            
            # 批量创建产品
            success_count = 0
            failed_products = []
            
            for index, product in enumerate(PRODUCTS):
                if create_product(page, product, index, len(PRODUCTS)):
                    success_count += 1
                else:
                    failed_products.append(product['name'])
                time.sleep(5)  # 间隔避免被封
            
            # 输出结果
            print(f"\n{'=' * 60}")
            print(f"📊 Results: {success_count}/{len(PRODUCTS)} products created")
            print(f"{'=' * 60}")
            
            if failed_products:
                print(f"\n❌ Failed products:")
                for name in failed_products:
                    print(f"   - {name}")
            
            # 保存最终结果截图
            page.goto("https://app.gumroad.com/products")
            time.sleep(3)
            page.screenshot(path="final_result.png")
            
        except Exception as e:
            print(f"\n❌ Fatal error: {str(e)}")
            page.screenshot(path="fatal_error.png")
            sys.exit(1)
            
        finally:
            browser.close()
    
    print("\n✅ Done!")

if __name__ == "__main__":
    main()
