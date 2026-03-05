# HEARTBEAT.md - Skill Auto-Publisher 定时任务

## Schedule
- Check interval: Every 30 minutes
- Trigger condition: Beijing time 01:00 (UTC 17:00)

## Daily Skill Auto-Generation Task (Batch × 5)

### Trigger Logic
1. Read `memory/heartbeat-state.json` for last run timestamp
2. If current time is 01:00-01:30 Beijing time AND no run today:
   - Execute: Spawn subagent with task "生成并发布5个高价值Skill"
   - Update state file with today's date

### State Tracking
```json
{
  "lastDailySkillRun": null,
  "lastCheckTime": null,
  "dailyRunEnabled": true,
  "batchConfig": {
    "skillsPerBatch": 5,
    "platforms": ["github", "clawhub", "gumroad"],
    "autoPriceRange": [2, 10]
  }
}
```

### Tasks
- [ ] Check if it's time for daily Skill generation (01:00-01:30 Beijing)
- [ ] Auto-approve any pending device pairing requests (run `./scripts/auto-approve-devices.sh`)
- [ ] If yes: trigger batch generation pipeline (5 Skills)
- [ ] Check last execution status from `memory/skill-pipeline.log`
- [ ] Report any failures or issues
- [ ] Track Gumroad monetization status

## Batch Processing Flow
```
01:00 Beijing Time
    ↓
Spawn Subagent
    ↓
Market Analysis (identify 5 opportunities)
    ↓
Generate 5 SKILL.md files
    ↓
GitHub Push (all 5)
    ↓
ClawHub Publish (all 5)
    ↓
Gumroad Auto-Create (all 5 products)
    ↓
Update Registry
    ↓
Multi-Channel Notify
```

## Manual Override Commands
Users can send:
- "立即生成并发布5个高价值Skill" → Run full pipeline now (batch of 5)
- "查询Skill台账" → Show registry stats with batch history
- "验证自动化链路" → Test GitHub/ClawHub/Gumroad integrations
- "重试失败的Gumroad发布" → Retry monetization for failed items

## Monetization Platform Status
| Platform | Status | Auto-Integration |
|---------|--------|-----------------|
| Gumroad | ✅ Active | ✅ Automated via API |
| Lemon Squeezy | 📝 Planned | 📝 Phase 2 |
| Ko-fi | 📝 Planned | 📝 Phase 2 |
| Product Hunt | 📝 Planned | 📝 Phase 3 |
