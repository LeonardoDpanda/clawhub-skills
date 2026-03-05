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
print("=" * 60)

with sync_playwright() as p:
    browser = p.chromium.launch(headless=False)
    page = browser.new_page()
    
    print("\n[Step 1] Opening ClawHub...")
    page.goto("https://clawhub.com")
    time.sleep(2)
    
    if "login" in page.url:
        print("Please login manually, then press Enter...")
        input()
    
    print(f"\nPublishing {len(skills)} Skills...")
    for i, skill in enumerate(skills, 1):
        print(f"[{i}/{len(skills)}] {skill['name']}")
        page.goto("https://clawhub.com/publish")
        time.sleep(2)
        page.fill('input[name="name"]', skill['name'])
        page.fill('textarea[name="description"]', skill['desc'])
        page.fill('input[name="github_url"]', f"https://github.com/LeonardoDpanda/clawhub-skills/blob/main/{skill['name']}_SKILL.md")
        page.click('button[type="submit"]')
        time.sleep(3)
    
    print("\n[Step 2] Opening Gumroad...")
    page.goto("https://gumroad.com/dashboard")
    time.sleep(2)
    
    if "login" in page.url:
        print("Please login to Gumroad, then press Enter...")
        input()
    
    print(f"\nCreating {len(skills)} products...")
    for i, skill in enumerate(skills, 1):
        print(f"[{i}/{len(skills)}] {skill['name']} (${skill['price']})")
        page.goto("https://gumroad.com/products/new")
        time.sleep(2)
        page.fill('input[name="product[name]"]', f"{skill['name']} - OpenClaw Skill")
        page.fill('input[name="product[price]"]', str(skill['price'] * 100))
        page.select_option('select[name="product[currency]"]', 'usd')
        page.fill('textarea[name="product[description]"]', f"{skill['desc']}\n\nhttps://clawhub.com/skills/{skill['name']}")
        page.click('button[type="submit"]')
        time.sleep(3)
    
    browser.close()

print("\n" + "=" * 60)
print("ALL DONE!")
input("Press Enter to exit...")
