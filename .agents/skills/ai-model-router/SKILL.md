---
name: ai-model-router
description: "Intelligent multi-model routing, self-improvement loops, agent memory persistence, and task delegation strategies. Makes the agent smarter over time."
---

# AI Agent Orchestration & Self-Improvement

## Trigger Conditions
- Complex tasks that benefit from multiple analysis passes
- When the agent makes errors and needs to learn
- Task delegation and parallel agent coordination
- When optimizing for speed vs quality tradeoffs

## Protocol 1: Multi-Pass Analysis

### Pass 1 — Fast Draft (Flash-level thinking)
- Quickly identify the approach
- Write a rough solution
- Flag areas of uncertainty

### Pass 2 — Deep Review (Pro-level thinking)
- Review Pass 1 output critically
- Challenge assumptions
- Check edge cases
- Verify correctness

### Pass 3 — Polish (Expert-level refinement)
- Optimize performance
- Improve naming and readability
- Add error handling
- Write tests
- Add documentation

## Protocol 2: Self-Improvement Loop

### When the Agent Makes an Error:
1. **Acknowledge** the error immediately — don't hide it
2. **Root cause**: Why did the error happen?
   - Misunderstanding requirements?
   - Wrong assumptions about the codebase?
   - Missing context?
   - Hallucinated API/syntax?
3. **Fix**: Apply the correct solution
4. **Learn**: Document the lesson in a structured format:

```markdown
## Lesson Learned — [Date]
**Error**: [What went wrong]
**Root Cause**: [Why it went wrong]
**Fix**: [What was the correct approach]
**Prevention**: [How to avoid this in the future]
**Pattern**: [General rule to follow]
```

5. **Suggest Rule**: Recommend a rule to add to `.agents/rules/` to prevent recurrence

## Protocol 3: Intelligent Task Delegation

### When to use Subagents:
| Task Type | Delegate? | Reason |
|-----------|-----------|--------|
| Independent file edits | ✅ Parallel subagents | No shared state |
| Sequential dependent tasks | ❌ Do sequentially | Order matters |
| Research + implementation | ✅ Research subagent first | Feed results to implementation |
| Code review | ✅ Review subagent | Fresh eyes perspective |
| Test writing + code writing | ✅ TDD: test subagent first | Tests inform implementation |

### Subagent Communication Protocol:
1. Give each subagent a **clear, specific task** with acceptance criteria
2. Provide **all necessary context** (file paths, constraints, patterns)
3. Define **exit conditions** (what "done" looks like)
4. Request **structured output** (not just code, but rationale)

## Protocol 4: Context Window Management

### Priority Stack (what to keep in context):
1. 🔴 **Current task** — always
2. 🟠 **Active files** — the files being edited
3. 🟡 **Project structure** — high-level understanding
4. 🟢 **Patterns & rules** — coding standards
5. 🔵 **History** — recent conversation (prune aggressively)

### When context is getting large:
1. Summarize completed work into a checkpoint
2. Offload reference material to artifacts
3. Use subagents for independent work streams
4. Focus on the immediate task, not the entire project
