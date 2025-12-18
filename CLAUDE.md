# Claude Assistant Configuration

**Project**: Ambient Code Reference Repository
**Type**: Documentation/Infrastructure Template
**Purpose**: Demonstrate AI-assisted development best practices

---

## Project Standards

### Code Style

**Shell Scripts** (bash):
- Use `#!/bin/bash` shebang
- Include `set -e` for error handling
- Add comments for non-obvious logic
- Pass shellcheck validation
- Make executable: `chmod +x scripts/*.sh`

**Markdown**:
- Follow `.markdownlint.json` configuration
- See `docs/STYLE_GUIDE.md` for detailed guidelines
- Use ZeroMQ-style: succinct, actionable, no fluff
- Dual documentation required: `{topic}.md` + `{topic}-terry.md`

**Mermaid Diagrams**:
- All `.mmd` files must validate with `mmdc`
- Run `./scripts/validate-mermaid.sh` before committing
- Use clear, descriptive node labels
- Avoid complex nested structures

---

## Testing Patterns

### Validation Scripts

**Before Committing**:
```bash
# Validate Mermaid diagrams
./scripts/validate-mermaid.sh

# Check documentation pairs
./scripts/check-doc-pairs.sh

# Run all linters (Phase 2+)
./scripts/lint-all.sh
```

**CI/CD Checks**:
- Documentation validation (markdownlint)
- Mermaid syntax validation (mmdc)
- Doc pairs verification
- Security scans (no secrets, no app code)
- Shellcheck for scripts

### Manual Testing

**Setup Script**:
```bash
# Test setup completes in <10 minutes
time ./scripts/setup.sh
```

**Template Functionality**:
1. Use "Use this template" button on GitHub
2. Clone new repository
3. Run `./scripts/setup.sh`
4. Verify all directories exist
5. Confirm <10 minute completion

---

## Security Guidelines

### What NOT to Commit

**Never commit**:
- Secrets (API keys, tokens, passwords)
- Credentials (`.env` files with real values)
- Application code (this is infrastructure only)
- Red Hat branding
- "Amber" terminology (use "Codebase Agent" or "CBA")

**Security Checks**:
- `.github/workflows/security-checks.yml` scans for violations
- Patterns: `AKIA` (AWS keys), `ghp_` (GitHub tokens), etc.
- Blocks merge if secrets or app code detected

### Input Validation

**Scripts**:
- Validate user input before processing
- Check file/directory existence before operations
- Use quotes for variables with spaces: `"$VAR"`
- Sanitize inputs to prevent injection

---

## Architecture Principles

### Buffet Approach

**Core Principle**: Features must be independently adoptable

**Implementation**:
- No hard dependencies between features
- Each `.claude/context/*.md` module is standalone
- Documentation can be copied per-topic
- CI/CD workflows are self-contained

**Validation**:
- Extract feature to clean project
- Verify it works without other components
- Document any unavoidable dependencies

### Dual Documentation

**Standard Version** (`docs/{topic}.md`):
- Technical, concise
- Assumes domain knowledge
- Uses industry terminology
- Code examples without excessive commentary

**Terry Version** (`docs/{topic}-terry.md`):
- Accessible, educational
- Plain language
- "What Just Happened?" sections
- Troubleshooting included

**Enforcement**:
- `./scripts/check-doc-pairs.sh` validates pairs exist
- CI blocks merge if Terry version missing

### No Application Code

**Template is infrastructure only**:
- Configuration files (`.github/`, `.claude/`)
- Documentation patterns
- Automation scripts
- Diagrams and examples

**NOT included**:
- FastAPI/Flask/Django applications
- Database schemas
- Business logic
- API implementations

**Validation**:
- Security workflow checks for `src/`, `app/`, `lib/` directories
- Blocks merge if application code detected

---

## Workflow Guidelines

### Branch Strategy

**Pattern**: `feature/{stream}/{task-id}-{description}`

**Examples**:
- `feature/docs/T015-quickstart-standard`
- `feature/agent/T038-codebase-agent-config`
- `feature/cicd/T022-validate-docs-workflow`

### Commit Messages

**Format**: Conventional Commits

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `chore`: Maintenance tasks
- `ci`: CI/CD changes

**Examples**:
```
feat(docs): add quickstart guide with Terry version
fix(scripts): handle missing mmdc gracefully
docs(readme): clarify buffet approach
chore(deps): update mermaid-cli to v11
```

### Pull Request Checklist

**Every PR must**:
- [ ] Dual documentation pairs created (if applicable)
- [ ] Mermaid diagrams validated with `mmdc` (if applicable)
- [ ] Terry version reviewed for accessibility (if applicable)
- [ ] No Red Hat branding
- [ ] No "Amber" terminology (use "Codebase Agent" or "CBA")
- [ ] CI checks passing
- [ ] Follows `docs/STYLE_GUIDE.md` (for documentation)
- [ ] Scripts pass shellcheck (if applicable)

---

## Common Tasks

### Adding Documentation

1. Create standard version: `docs/{topic}.md`
2. Create Terry version: `docs/{topic}-terry.md`
3. Validate pair: `./scripts/check-doc-pairs.sh`
4. Add to comparison page: `docs/comparison/index.html`
5. Commit both files together

### Adding Mermaid Diagram

1. Create diagram: `docs/diagrams/{name}.mmd`
2. Validate syntax: `mmdc -i docs/diagrams/{name}.mmd -o /tmp/test.svg`
3. Run validation script: `./scripts/validate-mermaid.sh`
4. Reference in documentation
5. Commit

### Adding Agent Context Module

1. Create module: `.claude/context/{topic}.md`
2. Ensure module is independently usable (no hard dependencies)
3. Use technology-agnostic patterns
4. Test by copying module alone to test project
5. Reference from `.claude/agents/codebase-agent.md` if relevant
6. Commit

### Adding CI/CD Workflow

1. Create workflow: `.github/workflows/{name}.yml`
2. Test on feature branch
3. Verify failure cases (intentionally break something)
4. Create diagram if complex: `docs/diagrams/{name}-pipeline.mmd`
5. Document in `docs/development.md`
6. Commit

---

## Project-Specific Context

### Active Technologies
- **Languages**: Bash (scripts), JavaScript (comparison page), Markdown (docs)
- **Tools**: mermaid-cli, markdownlint-cli, shellcheck, asciinema
- **Platform**: GitHub (primary), GitLab (placeholder for Phase 2)

### Data Model
This is a template repository with no application data. "Data model" refers to documentation/configuration structure:
- Documentation Topic (standard + Terry pair)
- Mermaid Diagram (validated .mmd file)
- Asciinema Tutorial (.cast recording)
- CI/CD Workflow (GitHub Actions .yml)
- Agent Context Module (.claude/context/*.md)

### Recent Changes
- Phase 0: Added STYLE_GUIDE.md, PROJECT_BOARD.md
- Phase 1: Repository initialization, directory structure
- Phase 2: Setup script, validation scripts, first diagram (in progress)

---

## Terminology

**Use These Terms**:
- ✅ Codebase Agent (CBA)
- ✅ Terry Documentation
- ✅ Buffet Approach
- ✅ Dual Documentation

**Avoid These Terms**:
- ❌ Amber (old internal name for agent)
- ❌ Red Hat (no branding)
- ❌ AI slop (superlatives, excessive enthusiasm)

---

## Resources

- [STYLE_GUIDE.md](docs/STYLE_GUIDE.md) - Documentation standards
- [PROJECT_BOARD.md](.github/PROJECT_BOARD.md) - Team workflow
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines
- [ZeroMQ Guide](https://zeromq.org/get-started/) - Style inspiration
- [Mermaid Docs](https://mermaid.js.org/) - Diagram syntax

---

**Last Updated**: 2025-12-17 (Phase 2)
**Maintained By**: Repository maintainers
