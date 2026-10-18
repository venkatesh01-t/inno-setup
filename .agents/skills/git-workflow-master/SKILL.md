---
name: git-workflow-master
description: "Expert git workflow management — conventional commits, branching strategies, PR templates, conflict resolution, changelog generation, and release management."
---

# Git Workflow Master

## Trigger Conditions
- User asks about git strategy, branching, commits
- Before creating PRs or releases
- When resolving merge conflicts
- Setting up a new repo

## Protocol 1: Conventional Commits

### Format
```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types
| Type | When to Use |
|------|------------|
| `feat` | New feature for the user |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, no code change |
| `refactor` | Code change that doesn't fix or add |
| `perf` | Performance improvement |
| `test` | Adding or fixing tests |
| `build` | Build system or dependencies |
| `ci` | CI/CD changes |
| `chore` | Other changes (tooling, etc.) |

### Examples
```
feat(auth): add OAuth2 login with Google
fix(api): handle null response from payment gateway
docs(readme): add setup instructions for Windows
refactor(db): extract query builder into utility
perf(images): implement lazy loading for gallery
```

## Protocol 2: Branch Strategy

### Trunk-Based (Recommended for small teams)
```
main ─────────────────────────────────────────►
  ├── feat/auth-google ──── PR ──── merge ──┤
  ├── fix/payment-null ──── PR ──── merge ──┤
  └── feat/dashboard ────── PR ──── merge ──┤
```

### Git Flow (For larger teams / release cycles)
```
main ──────────────────────────────────────────►
  │                                    ↑
develop ──────────────────────────────►│
  ├── feature/auth ──── PR ──┤       │
  ├── feature/dash ──── PR ──┤       │
  └── release/1.0 ───────────────────┘
```

## Protocol 3: PR Template
```markdown
## What
[Brief description of changes]

## Why
[Business/technical motivation]

## How
[Implementation approach]

## Testing
- [ ] Unit tests added/updated
- [ ] Manual testing completed
- [ ] Edge cases covered

## Screenshots
[If UI changes]

## Checklist
- [ ] Code follows project conventions
- [ ] Self-reviewed
- [ ] No console.logs or debug code
- [ ] Documentation updated
```

## Protocol 4: Automated Changelog
Generate from conventional commits:
```markdown
# Changelog

## [1.2.0] - 2026-10-07

### Added
- OAuth2 login with Google (feat(auth))
- Dashboard analytics page (feat(dashboard))

### Fixed  
- Null response handling in payment gateway (fix(api))
- Memory leak in WebSocket connection (fix(ws))

### Changed
- Extracted query builder into utility (refactor(db))
- Improved image loading performance (perf(images))
```
