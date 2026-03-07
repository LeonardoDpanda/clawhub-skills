---
name: git-commit-assistant
description: Generate conventional commit messages by analyzing git diff and code changes. Use when writing git commits to ensure consistency, readability, and automatic changelog generation. Supports Conventional Commits specification with smart scope detection.
---

# Git Commit Assistant

AI-powered commit message generator that ensures consistent, meaningful commit history.

## When to Use

- Before committing changes to git
- Standardizing team commit message format
- Enabling automatic changelog generation
- Improving code review readability
- Onboarding new team members to commit conventions

## When NOT to Use

- One-time personal projects
- Non-code file commits (docs, assets)
- Merge commits (handled automatically)
- Revert commits (use git revert)

## Quick Start

### Generate Commit Message

```bash
# Stage changes and generate commit message
git add .
git-commit-assistant suggest

# Output:
# feat(auth): add OAuth2 integration with Google
#
# - Implement Google OAuth2 flow
# - Add user profile synchronization
# - Update authentication middleware
```

### Auto-Commit

```bash
# Generate message and commit in one command
git-commit-assistant commit

# Equivalent to:
# git add . && git commit -m "$(git-commit-assistant suggest --raw)"
```

### Dry Run

```bash
# Preview without committing
git-commit-assistant suggest --dry-run

# Show multiple options
git-commit-assistant suggest --count 3
```

## Advanced Usage

### Custom Scope Detection

```bash
# Automatically detect scope from changed files
git-commit-assistant suggest --auto-scope

# Force specific scope
git-commit-assistant suggest --scope api
```

### Breaking Changes

```bash
# Mark as breaking change
git-commit-assistant suggest --breaking

# Output:
# feat(api)!: remove deprecated v1 endpoints
#
# BREAKING CHANGE: API v1 endpoints removed
```

### Multi-line Commits

```bash
# Generate detailed commit body
git-commit-assistant suggest --verbose

# Output:
# fix(database): resolve connection pool exhaustion
#
# - Increase max pool size from 10 to 50
# - Add connection timeout handling
# - Implement graceful shutdown
#
# Fixes #123
```

## Commit Types

| Type | Description | Example |
|------|-------------|---------|
| `feat` | New feature | `feat(auth): add login form` |
| `fix` | Bug fix | `fix(api): handle null response` |
| `docs` | Documentation | `docs(readme): update install guide` |
| `style` | Code style | `style(lint): fix indentation` |
| `refactor` | Code refactoring | `refactor(utils): simplify helpers` |
| `perf` | Performance | `perf(query): optimize joins` |
| `test` | Tests | `test(auth): add login tests` |
| `chore` | Maintenance | `chore(deps): update packages` |
| `ci` | CI/CD | `ci(actions): add deploy step` |
| `build` | Build system | `build(webpack): upgrade to v5` |

## Scopes

Auto-detected from project structure:

```
src/
  components/    → scope: components
  utils/         → scope: utils  
  api/           → scope: api
  auth/          → scope: auth
tests/           → scope: tests
docs/            → scope: docs
```

## Configuration

### .commit-assistant.json

```json
{
  "convention": "conventional-commits",
  "maxSubjectLength": 72,
  "scopes": ["api", "ui", "auth", "db", "docs"],
  "types": ["feat", "fix", "docs", "chore"],
  "template": "{type}({scope}): {subject}",
  "autoCommit": false,
  "signoff": true
}
```

### Git Alias

```bash
# Add to .gitconfig
git config --global alias.cm '!git-commit-assistant commit'
git config --global alias.cs 'commit-assistant suggest'

# Usage
git cm    # Commit with generated message
git cs    # Show suggestion
```

## Git Hook Integration

### prepare-commit-msg

```bash
#!/bin/bash
# .git/hooks/prepare-commit-msg
COMMIT_MSG_FILE=$1
COMMIT_SOURCE=$2

# Only suggest if no message provided
if [ -z "$COMMIT_SOURCE" ]; then
  git-commit-assistant suggest --raw > "$COMMIT_MSG_FILE"
fi
```

### commit-msg (Validation)

```bash
#!/bin/bash
# .git/hooks/commit-msg
COMMIT_MSG_FILE=$1

git-commit-assistant validate "$COMMIT_MSG_FILE" || {
  echo "Invalid commit message format"
  exit 1
}
```

## CI/CD Integration

### Validate Commit History

```bash
# Check all commits in PR
git-commit-assistant validate --from main --to HEAD

# Check last N commits
git-commit-assistant validate --last 10
```

### Generate Changelog Preview

```bash
# Preview changelog for next release
git-commit-assistant changelog --unreleased
```

## Team Workflow

### 1. Setup

```bash
# Team lead configures conventions
git-commit-assistant init --template angular
```

### 2. Daily Usage

```bash
# Developers commit with assistant
git add .
git-commit-assistant commit

# Or review suggestion first
git-commit-assistant suggest
# Edit if needed, then commit
```

### 3. Release

```bash
# Generate changelog automatically
git-commit-assistant changelog --from v1.0.0 > CHANGELOG.md
```

## Best Practices

1. **Review suggestions** - AI assists, you decide
2. **Keep commits atomic** - One logical change per commit
3. **Use present tense** - "add feature" not "added feature"
4. **Reference issues** - Include `Fixes #123` in body
5. **Be specific** - "fix bug" → "fix login timeout bug"