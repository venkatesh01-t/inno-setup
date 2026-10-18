---
name: sprint-planner
description: "Automated sprint planning, standup report generation, roadmap creation, and progress tracking. Transforms vague feature requests into structured, estimatable tasks."
---

# Sprint Planner & Project Manager

## Trigger Conditions
- User asks to "plan", "create tasks", "what should I work on next?"
- User mentions "sprint", "backlog", "roadmap", "standup"
- At the start of a new project or feature set
- When prioritizing work

## Protocol 1: Feature → Task Decomposition

### Step 1: Clarify the Feature
Ask (if not already clear):
1. **Who** is this for? (user persona)
2. **What** should it do? (acceptance criteria)
3. **Why** does it matter? (business value)
4. **When** is it needed? (deadline/priority)

### Step 2: Break into Atomic Tasks
Each task MUST be:
- **Independent**: Can be worked on without blocking others
- **Estimable**: Takes 1-4 hours (if >4h, decompose further)
- **Testable**: Has clear pass/fail criteria
- **Deliverable**: Produces a visible, reviewable output

### Task Template:
```markdown
### [TASK-XXX] Title
- **Type**: feat | fix | chore | refactor | docs | test
- **Estimate**: Xh
- **Priority**: P0 (critical) | P1 (important) | P2 (nice-to-have)
- **Depends on**: [TASK-YYY] or none
- **Acceptance Criteria**:
  - [ ] Criterion 1
  - [ ] Criterion 2
- **Files likely affected**: path/to/file.ts
```

## Protocol 2: Sprint Plan Generator

### Output Format:
```markdown
# Sprint Plan — [Sprint Name] ([Date Range])

## Sprint Goal
[1 sentence describing what we'll achieve]

## Capacity
- Available hours: XX
- Buffer (20%): XX
- Effective hours: XX

## Tasks (Priority Order)
| # | Task | Type | Est. | Priority | Status |
|---|------|------|------|----------|--------|
| 1 | ...  | feat | 2h   | P0       | ⬜ TODO |
| 2 | ...  | fix  | 1h   | P0       | ⬜ TODO |

## Risks & Blockers
- [Risk 1]: Mitigation plan
- [Risk 2]: Mitigation plan

## Definition of Done
- [ ] All P0 tasks complete
- [ ] Tests passing
- [ ] No critical bugs
- [ ] Documentation updated
```

## Protocol 3: Standup Report Generator

Analyze recent git commits and file changes to generate:
```markdown
# Daily Standup — [Date]

## ✅ Completed Yesterday
- [Commit message / change summary]

## 🔄 In Progress Today
- [Current task based on sprint plan]

## 🚧 Blockers
- [Any issues found in logs/tests]

## 📊 Sprint Progress: X/Y tasks (XX%)
```

## Protocol 4: Roadmap Generator
```markdown
# Product Roadmap

## Phase 1: Foundation (Week 1-2)
- [ ] Core feature A
- [ ] Core feature B

## Phase 2: Growth (Week 3-4)
- [ ] Feature C
- [ ] Feature D

## Phase 3: Polish (Week 5-6)
- [ ] Performance optimization
- [ ] Security hardening
- [ ] Documentation
```
