---
name: markdown-doc-generator
description: Generate professional Markdown documentation from code comments, file structures, and templates. Use when creating README files, API documentation, or project wikis. Auto-extracts JSDoc, Python docstrings, and Go comments to build comprehensive docs.
---

# Markdown Doc Generator

Intelligent documentation generator that transforms code into beautiful Markdown docs.

## When to Use

- Creating project README files
- Generating API documentation
- Building changelogs from git history
- Documenting code architecture
- Creating consistent project wikis
- Onboarding documentation

## When NOT to Use

- Simple one-page docs (write manually)
- Complex technical specifications (use dedicated tools)
- PDF or Word document generation
- Real-time collaborative editing

## Quick Start

### Generate README

```bash
# Auto-generate README from project structure
markdown-doc-generator readme --output README.md

# Include specific sections
markdown-doc-generator readme \
  --sections install,usage,api,contributing \
  --template modern
```

### API Documentation

```bash
# Generate from JavaScript/TypeScript JSDoc
markdown-doc-generator api src/**/*.js --output API.md

# Generate from Python docstrings
markdown-doc-generator api src/**/*.py --format google --output API.md
```

### Changelog Generation

```bash
# Generate from conventional commits
markdown-doc-generator changelog --from v1.0.0 --output CHANGELOG.md

# Include commit links
markdown-doc-generator changelog \
  --repo https://github.com/user/repo \
  --output CHANGELOG.md
```

## Advanced Usage

### Custom Templates

```bash
# Use custom template
markdown-doc-generator readme \
  --template ./templates/readme.hbs \
  --vars "project_name=MyApp,author=John" \
  --output README.md
```

### Architecture Diagrams

```bash
# Generate architecture doc with Mermaid diagrams
markdown-doc-generator architecture \
  --include src/ \
  --exclude "**/*.test.js" \
  --diagrams modules,dependencies \
  --output ARCHITECTURE.md
```

### Multi-language Support

```bash
# Extract docs from multiple languages
markdown-doc-generator api \
  "src/**/*.{js,py,go,rs}" \
  --output docs/api/ \
  --per-file
```

## Template Variables

| Variable | Description | Source |
|----------|-------------|--------|
| `{{project_name}}` | Project name | package.json / pyproject.toml |
| `{{version}}` | Current version | git tags / package.json |
| `{{description}}` | Project description | README header / package.json |
| `{{install_cmd}}` | Installation command | Detected from package files |
| `{{usage_example}}` | Usage example | Extracted from examples/ |
| `{{api_summary}}` | API overview | Extracted from code comments |

## Document Types

### README.md Structure

```markdown
# Project Name

> Description extracted from package.json

## Installation

\`\`\`bash
npm install project-name
\`\`\`

## Usage

[Auto-generated from examples/ folder]

## API Reference

[Auto-generated from JSDoc/docstrings]

## Contributing

[Template with project-specific instructions]

## License

[Extracted from LICENSE file]
```

### API.md Structure

```markdown
# API Reference

## Classes

### UserManager

Manage user accounts and authentication.

#### Methods

##### createUser(data)

Create a new user account.

**Parameters:**
- `data` (Object) - User data
  - `email` (string) - User email
  - `password` (string) - User password

**Returns:** Promise&lt;User&gt;

**Example:**
\`\`\`javascript
const user = await userManager.createUser({
  email: 'user@example.com',
  password: 'secure123'
});
\`\`\`
```

## Configuration

### .docrc.json

```json
{
  "templates": {
    "readme": "./templates/readme.hbs",
    "api": "./templates/api.hbs"
  },
  "extractors": {
    "js": {
      "include": ["src/**/*.js"],
      "exclude": ["**/*.test.js", "node_modules/**"]
    }
  },
  "output": {
    "readme": "README.md",
    "api": "docs/API.md"
  }
}
```

## Integration Examples

### Pre-commit Hook

```bash
#!/bin/bash
# Regenerate docs before commit
markdown-doc-generator readme --check || {
  echo "README out of date. Run: markdown-doc-generator readme"
  exit 1
}
```

### GitHub Actions

```yaml
name: Documentation
on: [push]
jobs:
  docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Generate Docs
        run: markdown-doc-generator readme --output README.md
      - name: Commit Changes
        run: |
          git config user.name "github-actions"
          git add README.md
          git diff --staged --quiet || git commit -m "docs: update README"
          git push
```

## Best Practices

1. **Keep examples updated** - Place working examples in `examples/`
2. **Write meaningful comments** - Quality docs come from quality comments
3. **Review generated output** - Always review before committing
4. **Version your docs** - Generate changelog with each release