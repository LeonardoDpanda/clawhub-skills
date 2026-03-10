from playwright.sync_api import sync_playwright
import time

skills = [
    {"name": "password-generator", "desc": "Generate secure passwords", "price": 4},
    {"name": "csv-processor", "desc": "Process CSV files", "price": 5},
    {"name": "markdown-formatter", "desc": "Format Markdown", "price": 3},
    {"name": "system-health-check", "desc": "Monitor system health", "price": 5},
    {"name": "url-encoder", "desc": "Encode URLs", "price": 3},
    {"name": "csv-data-analyzer", "desc": "Analyze CSV data", "price": 6},
    {"name": "url-shortener-expander", "desc": "Shorten URLs", "price": 3},
    {"name": "text-diff-comparator", "desc": "Compare text", "price": 5},
    {"name": "json-schema-validator", "desc": "Validate JSON", "price": 7},
    {"name": "timestamp-converter", "desc": "Convert timestamps", "price": 3}
]

print("Starting browser automation...")
print("A browser window will open. Please login when prompted.")
print("=" * 60)

with sync_playwright() as p:
    browser = p.chromium.launch(headless=False)
    page = browser.new_page()
    
    print("\n[1/2] Opening ClawHub...")
    page.goto("https://clawhub.com")
    time.sleep(2)
    
    if page.locator('input[type="email"]').count() > 0 or "login" in page.url:
        print("Please login to ClawHub manually, then press Enter here...")
        input()
    
    print(f"\nPublishing {len(skills)} Skills to ClawHub...")
    
    for i, skill in enumerate(skills, 1):
        print(f"\n[{i}/{len(skills)}] Publishing: {skill['name']}")
        
        page.goto("https://clawhub.com/publish")
        time.sleep(2)
        
        try:
            page.fill('input[name="name"]', skill['name'])
            time.sleep(0.3)
            
            page.fill('textarea[name="description"]', skill['desc'])
            time.sleep(0.3)
            
            github_url = f"https://github.com/LeonardoDpanda/clawhub-skills/blob/main/{skill['name']}_SKILL.md"
            page.fill('input[name="github_url"]', github_url)
            time.sleep(0.3)
            
            page.click('button[type="submit"]')
            time.sleep(2)
            
            print(f"  OK: {skill['name']}")
            
        except Exception as e:
            print(f"  Error: {e}")
            print("  Please complete this skill manually, then press Enter...")
            input()
    
    print("\n[2/2] Opening Gumroad...")
    page.goto("https://gumroad.com/dashboard")
    time.sleep(2)
    
    if page.locator('input[type="email"]').count() > 0 or "login" in page.url:
        print("Please login to Gumroad manually, then press Enter here...")
        input()
    
    print(f"\nCreating {len(skills)} products on Gumroad...")
    
    for i, skill in enumerate(skills, 1):
        print(f"\n[{i}/{len(skills)}] Creating: {skill['name']} (${skill['price']})")
        
        try:
            page.click('a:has-text("New product")')
            time.sleep(2)
        except:
            page.goto("https://gumroad.com/products/new")
            time.sleep(2)
        
        try:
            page.fill('input[name="product[name]"]', f"{skill['name']} - OpenClaw Skill")
            time.sleep(0.3)
            
            page.fill('input[name="product[price]"]', str(skill['price'] * 100))
            time.sleep(0.3)
            
            page.select_option('select[name="product[currency]"]', 'usd')
            time.sleep(0.3)
            
            desc = f"{skill['desc']}\n\nGet on ClawHub: https://clawhub.com/skills/{skill['name']}"
            page.fill('textarea[name="product[description]"]', desc)
            time.sleep(0.3)
            
            page.click('button[type="submit"]')
            time.sleep(2)
            
            print(f"  OK: {skill['name']}")
            
        except Exception as e:
            print(f"  Error: {e}")
            print("  Please complete this product manually, then press Enter...")
            input()
    
    browser.close()

print("\n" + "=" * 60)
print("ALL DONE!")
print("=" * 60)
input("\nPress Enter to exit...")
