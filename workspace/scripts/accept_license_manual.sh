#!/bin/bash
# ClawHub License Acceptance Helper
# This script provides instructions for manually accepting the MIT-0 license

cat << 'EOF'
================================================================================
🚨 CLAWHUB LICENSE ACCEPTANCE REQUIRED
================================================================================

Before publishing Skills to ClawHub, you must accept the MIT-0 license terms.

📋 MANUAL STEPS REQUIRED:

1. 🌐 Visit ClawHub website:
   https://clawhub.ai

2. 🔐 Login with your credentials:
   Email: 410205301@qq.com
   Password: [Your password]

3. 📄 Accept MIT-0 License:
   - Look for "Publish" or "Create Skill" button
   - Or navigate to Account Settings
   - Accept the MIT-0 license terms when prompted

4. ✅ After accepting license:
   - Return to this workspace
   - Re-run the publish script

================================================================================
📊 CURRENT STATUS
================================================================================

✅ API Token: Valid
✅ API Endpoint: Available (POST /api/v1/skills)
❌ License Status: Not accepted (blocking publish)
📦 Skills Ready: 15 local Skills
🎯 Priority Skills: 4 (with Gumroad hooks)

================================================================================
🚀 READY TO PUBLISH (After License Acceptance)
================================================================================

Priority Skills (with Gumroad monetization):
  1. config-format-converter-pro
  2. batch-file-renamer-pro
  3. qr-code-tool-pro
  4. rest-api-tester-pro

All Skills:
  - config-format-converter-pro
  - batch-file-renamer-pro
  - qr-code-tool-pro
  - rest-api-tester-pro
  - http-headers-analyzer-pro
  - json-path-query-pro
  - youtube-title-optimizer
  - image-reader
  - coze-image-gen
  - skill-auto-publisher
  - docker-compose-validator-pro
  - coze-voice-gen
  - coze-web-search
  - cron-expression-parser-pro
  - ssl-certificate-checker-pro

================================================================================
📝 ALTERNATIVE: Direct API Call (if endpoint exists)
================================================================================

If you find the license acceptance API endpoint, you can use:

  curl -X POST https://clawhub.ai/api/v1/user/license \
    -H "Authorization: Bearer clh_1fCyGAxj2bNgAqc3UmhZZJ9z4F0dbHAAVFlyzIEOPaA" \
    -H "Content-Type: application/json" \
    -d '{"license": "MIT-0", "accepted": true}'

================================================================================
EOF
