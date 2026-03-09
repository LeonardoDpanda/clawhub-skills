---
name: meeting-summarizer
description: Automatically transcribe meeting audio or text and generate structured summaries with action items. Use when processing meeting recordings, meeting transcripts, or voice notes that need organization into key decisions, discussion points, and assigned tasks.
---

# Meeting Summarizer

Transform messy meeting content into structured, actionable summaries. Extract key decisions, discussion points, and action items automatically.

## When to Use

- Processing meeting recordings or transcripts
- Converting voice notes to structured summaries
- Extracting action items from team discussions
- Creating meeting minutes from raw notes
- Following up on decisions made in calls

## When NOT to Use

- Real-time transcription (process after meeting ends)
- Legal proceedings requiring verbatim accuracy
- Content without clear discussion structure

## Quick Start

### Summarize a Meeting Transcript

```markdown
@meeting-summarizer

Transcript:
[粘贴会议记录或转录文本]

Generate:
1. Executive Summary (2-3 sentences)
2. Key Decisions Made
3. Discussion Points
4. Action Items with owners
5. Follow-up Topics
```

### Process Audio Recording

```bash
# Upload audio file for transcription + summary
process-meeting-audio --file /path/to/recording.mp3 --output summary.md
```

## Output Format

Generated summaries include:

```markdown
# Meeting Summary - [Date]

## Executive Summary
Brief overview of what was discussed and decided.

## Key Decisions
- Decision 1
- Decision 2

## Discussion Points
1. **Topic A**: Key points discussed
2. **Topic B**: Key points discussed

## Action Items
| Task | Owner | Due Date | Priority |
|------|-------|----------|----------|
| Task 1 | @person | YYYY-MM-DD | High |
| Task 2 | @person | YYYY-MM-DD | Medium |

## Follow-up Topics
- Items to address in next meeting
```

## Advanced Usage

### Custom Output Sections

Request specific sections:
- Risk Assessment
- Budget Impact
- Technical Requirements
- Stakeholder Updates
- Timeline Changes

### Multi-Language Support

```markdown
Summarize in: English, Chinese, Spanish, Japanese
```

### Integration Options

- **Slack**: Auto-post summaries to channels
- **Notion**: Create database entries
- **Jira**: Generate tickets from action items
- **Email**: Send to participants

## Best Practices

1. **Clean Input**: Remove irrelevant chit-chat for better results
2. **Context**: Mention project/team name for relevant formatting
3. **Follow-ups**: Review generated action items for accuracy
4. **Storage**: Save summaries in searchable format

## Tips

- Works best with 15+ minutes of structured discussion
- Identifies action items by keywords: "will do", "responsible for", "follow up"
- Highlights decisions with phrases like "agreed to", "decided", "approved"
- Can process multiple languages in same transcript
