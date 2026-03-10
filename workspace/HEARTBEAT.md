# HEARTBEAT.md - Skill Auto-Publisher 定时任务

## Schedule
- Check interval: Every 30 minutes
- Trigger condition: Beijing time 01:00 (UTC 17:00)

## Daily Skill Auto-Generation Task (PAUSED - 推广优先阶段)

### Current Strategy (2026-03-10更新)
**阶段**: 推广冲刺期  
**目标**: 用现有35个Skills验证变现可行性  
**生成**: 暂停（0个/天）  
**推广**: 全力（Reddit 3帖/天 + HN + Dev.to）

### Trigger Logic (已暂停自动生成)
1. ~~Read `memory/heartbeat-state.json` for last run timestamp~~
2. ~~If current time is 01:00-01:30 Beijing time AND no run today:~~
3. **新逻辑**: 检查推广数据，每日生成数据报告
4. **Resume条件**: 找到变现信号（访问量>100 或 首笔销售）

### Resume Criteria
- [ ] 某个Skill Gumroad访问量 > 100
- [ ] 或 首笔销售完成
- [ ] 或 Reddit讨论度 > 10互动/帖
- [ ] 或 GitHub Stars日增长 > 5

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
