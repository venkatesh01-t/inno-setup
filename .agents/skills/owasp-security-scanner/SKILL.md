---
name: owasp-security-scanner
description: "Automated OWASP Top 10 vulnerability scanning, secret detection, dependency CVE analysis, and security hardening recommendations. Acts as an AI security engineer."
---

# OWASP Security Scanner

## Trigger Conditions
- User asks to "scan for vulnerabilities", "security audit", "check security"
- Before any deployment to production
- When reviewing authentication/authorization code
- When handling user input, file uploads, or external data

## Protocol: Full Security Scan

### Scan 1: OWASP Top 10 (2025)

#### A01 — Broken Access Control
- Search for: Missing auth middleware on routes
- Search for: Direct object references without ownership checks
- Search for: Missing RBAC/ABAC enforcement
- Commands: `grep -rn "req.params.id" --include="*.ts" --include="*.js"`

#### A02 — Cryptographic Failures
- Search for: Hardcoded secrets, API keys, passwords
- Search for: Weak hashing (MD5, SHA1 for passwords)
- Search for: Missing HTTPS enforcement
- Pattern: `grep -rn "password\|secret\|api_key\|token" --include="*.env*"`

#### A03 — Injection
- Search for: String concatenation in SQL queries
- Search for: Unsanitized user input in templates (XSS)
- Search for: eval(), Function(), innerHTML with user data
- Search for: Command injection via child_process

#### A04 — Insecure Design
- Check: Is there rate limiting on auth endpoints?
- Check: Are there account lockout mechanisms?
- Check: Is there proper session management?

#### A05 — Security Misconfiguration
- Check: CORS policy (not wildcard in production)
- Check: Security headers (CSP, X-Frame-Options, HSTS)
- Check: Debug mode disabled in production
- Check: Default credentials changed

#### A06 — Vulnerable Components
- Run: `npm audit` / `pip audit` / `cargo audit`
- Check: Are dependencies up to date?
- Check: Are there known CVEs?

#### A07 — Auth Failures
- Check: Password policy enforcement
- Check: MFA implementation
- Check: JWT expiration and rotation
- Check: Session fixation prevention

#### A08 — Data Integrity Failures
- Check: CI/CD pipeline security
- Check: Dependency integrity (lockfile)
- Check: Deserialization safety

#### A09 — Logging & Monitoring
- Check: Are auth failures logged?
- Check: Are sensitive operations audited?
- Check: Is PII properly redacted from logs?

#### A10 — SSRF
- Check: URL validation on user-provided URLs
- Check: Internal network access restrictions

### Scan 2: Secret Detection
```
Patterns to search for:
- AWS keys: AKIA[0-9A-Z]{16}
- Private keys: -----BEGIN (RSA|DSA|EC|OPENSSH) PRIVATE KEY-----
- JWT secrets: eyJ[A-Za-z0-9-_]+\.eyJ[A-Za-z0-9-_]+
- Generic secrets: (password|secret|token|api_key)\s*[=:]\s*["'][^"']+["']
- Database URLs: (postgres|mysql|mongodb)://[^:]+:[^@]+@
```

### Scan 3: Dependency Vulnerabilities
1. Check `package-lock.json` / `yarn.lock` for known CVEs
2. Run `npm audit --json` and parse results
3. Flag any critical/high severity issues

## Report Format
```markdown
# 🔒 Security Scan Report — [Date]

## Risk Score: X/100 (Critical|High|Medium|Low)

## 🔴 Critical Findings
| # | Vulnerability | Location | OWASP | Fix |
|---|--------------|----------|-------|-----|

## 🟠 High Findings
...

## 🟡 Medium Findings
...

## 💚 Passed Checks
- [List of passed security checks]

## Recommended Actions (Priority Order)
1. [Action 1]
2. [Action 2]
```
