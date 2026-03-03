# Fix encoding issues
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=======================START AUTO PUBLISH=======================" -ForegroundColor Green

try {
    # 1. Navigate to skill directory
    Write-Host "`n1. Navigating to D:\ClawHub_Skills..." -ForegroundColor Cyan
    Set-Location D:\ClawHub_Skills -ErrorAction Stop

    # 2. Pull latest from GitHub
    Write-Host "`n2. Pulling latest from GitHub..." -ForegroundColor Cyan
    git pull origin main

    # 3. Add all new files
    Write-Host "`n3. Adding all new files..." -ForegroundColor Cyan
    git add .

    # 4. Commit changes
    $commitMsg = "Auto-publish: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') New OpenClaw skills"
    Write-Host "`n4. Committing changes: $commitMsg" -ForegroundColor Cyan
    git commit -m $commitMsg

    # 5. Push to GitHub
    Write-Host "`n5. Pushing to GitHub..." -ForegroundColor Cyan
    git push origin main

    # 6. Publish to ClawHub
    Write-Host "`n6. Publishing to ClawHub..." -ForegroundColor Cyan
    clawhub publish .

    Write-Host "`n=======================PUBLISH SUCCESSFUL!=======================" -ForegroundColor Green
}
catch {
    Write-Host "`n? ERROR: $_" -ForegroundColor Red
    Write-Host "`n=======================PUBLISH FAILED!=======================" -ForegroundColor Red
}

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
Read-Host