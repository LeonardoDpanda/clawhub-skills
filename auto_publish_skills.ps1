# Core config: Fix authentication and domain redirect (replace Token)
$env:CLAWHUB_TOKEN = "clh_bvEZkqyJ9vQdxccv_U3GTcwjGBmLypGofQJA88hlsSQ"  # Replace with your clh_ prefixed Token
$env:CLAWHUB_REGISTRY = "https://www.clawhub.ai"  # Force valid domain

# Fix encoding issues
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=======================START AUTO PUBLISH=======================" -ForegroundColor Green

try {
    # 1. Navigate to skill storage directory
    Write-Host "`n1. Navigating to D:\ClawHub_Skills..." -ForegroundColor Cyan
    Set-Location D:\ClawHub_Skills -ErrorAction Stop

    # 2. Pull latest content from GitHub remote repository (avoid conflicts)
    Write-Host "`n2. Pulling latest from GitHub..." -ForegroundColor Cyan
    git pull origin main

    # 3. Add all new files to Git staging area
    Write-Host "`n3. Adding all new files..." -ForegroundColor Cyan
    git add .

    # 4. Commit updates (allow empty commit to avoid errors when no files)
    $commitMsg = "Auto-publish: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') New OpenClaw skills"
    Write-Host "`n4. Committing changes: $commitMsg" -ForegroundColor Cyan
    git commit -m $commitMsg --allow-empty

    # 5. Push to GitHub remote repository
    Write-Host "`n5. Pushing to GitHub..." -ForegroundColor Cyan
    git push origin main

    # 6. Publish to ClawHub platform (with forced Registry parameter)
    Write-Host "`n6. Publishing to ClawHub..." -ForegroundColor Cyan
    clawhub publish . --registry "https://www.clawhub.ai"

    # Publish success prompt
    Write-Host "`n=======================PUBLISH SUCCESSFUL!=======================" -ForegroundColor Green
}
catch {
    # Error capture and prompt
    Write-Host "`n❌ ERROR DETAIL: $_" -ForegroundColor Red
    Write-Host "`n=======================PUBLISH FAILED!=======================" -ForegroundColor Red
}

# Pause window for result review
Read-Host -Prompt "Press Enter to exit"