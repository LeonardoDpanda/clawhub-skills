#!/usr/bin/env python3
"""
Gumroad 产品批量创建脚本
在本地运行，自动登录并创建产品

安装依赖:
pip install playwright
playwright install chromium

使用方法:
python gumroad_batch_create.py
"""

import json
import time
from playwright.sync_api import sync_playwright

# ============ 配置区域 ============
GUMROAD_EMAIL = "your-email@example.com"  # 替换为你的邮箱
GUMROAD_PASSWORD = "your-password"         # 替换为你的密码

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

# ============ 自动化脚本 ============

def create_product(page, product, index):
    """创建单个产品"""
    print(f"\n[{index+1}/{len(PRODUCTS)}] 创建产品: {product['name']}")
    
    try:
        # 点击 "New product" 按钮
        page.goto("https://app.gumroad.com/products")
        time.sleep(2)
        
        # 点击 New product
        new_product_btn = page.locator('text=New product').first
        new_product_btn.click()
        time.sleep(2)
        
        # 选择 "Digital product"
        digital_option = page.locator('text=Digital product').first
        digital_option.click()
        time.sleep(2)
        
        # 填写产品名称
        name_input = page.locator('input[name="name"]').first
        name_input.fill(product['name'])
        time.sleep(1)
        
        # 填写价格
        price_input = page.locator('input[name="price"]').first
        price_input.fill(str(product['price']))
        time.sleep(1)
        
        # 填写描述
        desc_input = page.locator('textarea[name="description"]').first
        desc_input.fill(product['description'])
        time.sleep(1)
        
        # 填写自定义 URL
        url_input = page.locator('input[name="custom_permalink"]').first
        url_input.fill(product['url'])
        time.sleep(1)
        
        # 填写标签
        tags_input = page.locator('input[name="tags"]').first
        tags_input.fill(product['tags'])
        time.sleep(1)
        
        # 点击保存
        save_btn = page.locator('button:has-text("Save")').first
        save_btn.click()
        time.sleep(3)
        
        print(f"✅ 成功创建: {product['name']}")
        return True
        
    except Exception as e:
        print(f"❌ 创建失败: {product['name']} - {str(e)}")
        return False

def main():
    print("=" * 50)
    print("Gumroad 产品批量创建脚本")
    print("=" * 50)
    
    if GUMROAD_EMAIL == "your-email@example.com":
        print("\n⚠️  请先编辑脚本，填写你的 Gumroad 邮箱和密码！")
        return
    
    with sync_playwright() as p:
        # 启动浏览器
        browser = p.chromium.launch(headless=False)  # headless=True 可无界面运行
        context = browser.new_context(viewport={'width': 1280, 'height': 800})
        page = context.new_page()
        
        try:
            # 登录 Gumroad
            print("\n🔄 正在登录 Gumroad...")
            page.goto("https://app.gumroad.com/login")
            time.sleep(2)
            
            # 填写邮箱
            email_input = page.locator('input[name="email"]').first
            email_input.fill(GUMROAD_EMAIL)
            time.sleep(1)
            
            # 填写密码
            password_input = page.locator('input[name="password"]').first
            password_input.fill(GUMROAD_PASSWORD)
            time.sleep(1)
            
            # 点击登录
            login_btn = page.locator('button[type="submit"]').first
            login_btn.click()
            time.sleep(5)
            
            print("✅ 登录成功！\n")
            
            # 批量创建产品
            success_count = 0
            for index, product in enumerate(PRODUCTS):
                if create_product(page, product, index):
                    success_count += 1
                time.sleep(3)  # 间隔避免被封
            
            print(f"\n{'=' * 50}")
            print(f"📊 完成统计: {success_count}/{len(PRODUCTS)} 个产品创建成功")
            print(f"{'=' * 50}")
            
        except Exception as e:
            print(f"\n❌ 发生错误: {str(e)}")
            
        finally:
            # 保持浏览器打开，方便查看结果
            input("\n按回车键关闭浏览器...")
            browser.close()

if __name__ == "__main__":
    main()
