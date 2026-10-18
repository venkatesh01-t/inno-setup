---
name: architecture-reviewer
description: "Performs comprehensive architecture reviews analyzing scalability, security, maintainability, cost, and failure modes. Produces actionable audit reports with severity-ranked findings."
---

# Architecture Review Engine

## Trigger Conditions
- User asks to "review architecture", "audit the system", "is this scalable?"
- Before major refactors or migrations
- When evaluating tech stack choices
- System design reviews

## Review Protocol

### Phase 1 — Discovery
1. Read `package.json`, `go.mod`, `Cargo.toml`, or equivalent
2. Map the directory structure
3. Identify all entry points (APIs, pages, workers, crons)
4. Map data flow: User → Frontend → API → DB → External Services

### Phase 2 — Analysis Dimensions

#### 2A. Scalability Audit
- [ ] Can the system handle 10x current load?
- [ ] Are there single points of failure?
- [ ] Is the database properly indexed?
- [ ] Are expensive operations async (queues, workers)?
- [ ] Is caching implemented at the right layers?
- [ ] Is there connection pooling?

#### 2B. Security Audit
- [ ] Authentication: Is it industry-standard (OAuth2, JWT with rotation)?
- [ ] Authorization: RBAC/ABAC properly enforced at API layer?
- [ ] Input validation: All user inputs validated and sanitized?
- [ ] Secrets: No hardcoded secrets? Proper .env management?
- [ ] CORS: Properly configured, not wildcard?
- [ ] Rate limiting: Implemented on auth and public endpoints?
- [ ] SQL injection / XSS / CSRF protections?

#### 2C. Maintainability Audit
- [ ] Clear separation of concerns (not god files >500 lines)
- [ ] Consistent naming conventions
- [ ] Type safety (TypeScript strict mode, Go interfaces)
- [ ] Error handling: No swallowed errors, proper error boundaries
- [ ] Tests: Unit, integration, E2E coverage
- [ ] Documentation: API docs, README, architecture diagrams

#### 2D. Cost Audit
- [ ] Are we paying for services we don't use?
- [ ] Are there N+1 queries hitting the DB?
- [ ] Image/asset optimization (CDN, compression)?
- [ ] Serverless cold start impact?
- [ ] Log volume: Are we logging too much/too little?

#### 2E. Failure Mode Analysis
- [ ] What happens when the DB goes down?
- [ ] What happens when an external API is slow (>5s)?
- [ ] What happens when the user's session expires mid-operation?
- [ ] What happens when deployment fails mid-migration?
- [ ] Is there graceful degradation?

### Phase 3 — Report Format
```markdown
# Architecture Review Report

## Summary
[1-2 sentence overall assessment]

## Severity: 🔴 Critical (Fix Now)
- Finding 1: [description] → [file:line] → [fix]

## Severity: 🟠 Important (Fix This Sprint)
- Finding 2: [description] → [file:line] → [fix]

## Severity: 🟡 Minor (Backlog)
- Finding 3: [description] → [file:line] → [fix]

## Severity: 💚 Strengths
- What's done well

## Recommendations
1. [Prioritized action items]
```
