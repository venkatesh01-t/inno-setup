---
name: dependency-auditor
description: "Scans all project dependencies for known CVEs, outdated packages, license compliance issues, and unused dependencies. Generates security advisories and update plans."
---

# Dependency Auditor & Security Scanner

## Trigger Conditions
- Before production deployments
- User asks to "audit dependencies", "check for vulnerabilities"
- When adding new dependencies
- Monthly security review

## Protocol 1: Full Dependency Audit

### Step 1: Security Scan
```bash
# Node.js
npm audit --json
npx better-npm-audit audit

# Python
pip-audit
safety check

# Go
govulncheck ./...

# Rust
cargo audit
```

### Step 2: License Compliance
Flag any dependency with:
- GPL (copyleft — may require open-sourcing your code)
- AGPL (strongest copyleft — definitely requires open-sourcing)
- Unknown/missing license
- Allowed: MIT, Apache-2.0, BSD-2/3, ISC, Unlicense

### Step 3: Unused Dependency Detection
Look for dependencies in package.json that are never imported:
```bash
# Check for unused deps
npx depcheck
```

### Step 4: Outdated Package Check
```bash
npm outdated
```

## Protocol 2: Risk Assessment

### For Each Vulnerability:
| Field | Description |
|-------|-------------|
| Package | Affected package name |
| Severity | Critical / High / Medium / Low |
| CVE | CVE identifier |
| Description | What the vulnerability allows |
| Impact | How it affects YOUR application |
| Fix | Upgrade path or workaround |
| Breaking | Will the fix break anything? |

## Protocol 3: Update Strategy

### Safe Update Order
1. **Patch updates** (1.0.0 → 1.0.1): Usually safe, just bug fixes
2. **Minor updates** (1.0.0 → 1.1.0): New features, should be backward compatible
3. **Major updates** (1.0.0 → 2.0.0): Breaking changes, read changelog first

### Before Major Updates:
1. Read the CHANGELOG/migration guide
2. Check if any APIs you use are deprecated
3. Update in a separate branch
4. Run full test suite
5. Test critical user flows manually

## Report Format
```markdown
# 🛡️ Dependency Audit Report — [Date]

## Summary
- Total dependencies: XX
- Vulnerabilities: X critical, X high, X medium, X low
- Outdated: X packages
- Unused: X packages
- License issues: X packages

## 🔴 Critical Vulnerabilities
| Package | CVE | Version | Fix | Breaking? |
|---------|-----|---------|-----|-----------|

## 🟠 Outdated Packages (Major)
| Package | Current | Latest | Breaking Changes |
|---------|---------|--------|-----------------|

## 🟡 Unused Dependencies (Remove)
| Package | Size | Why Unused |
|---------|------|-----------|

## Action Plan
1. [Highest priority fix]
2. [Next priority]
```
