---
name: deep-thinking-reasoner
description: "Forces multi-step deep reasoning, Socratic decomposition, rubber-duck debugging, and architectural review before any code generation. Combines 1000+ AI+human thinking patterns for superior problem-solving."
---

# Deep Thinking & Reasoning Engine

## Trigger Conditions
- User asks to solve a complex problem or debug a hard issue
- User says "think deeply", "analyze", "reason about", "why", "root cause"
- Before any major architectural decision
- When a bug resists quick fixes (>2 failed attempts)

## Protocol: The 7-Layer Thinking Stack

### Layer 1 — Problem Decomposition (Socratic)
Before writing ANY code, ask yourself:
1. **What exactly is being asked?** Restate the problem in your own words.
2. **What are the constraints?** (time, performance, compatibility, security)
3. **What are the unknowns?** List what you DON'T know.
4. **What assumptions am I making?** Challenge each one.

### Layer 2 — Multi-Perspective Analysis
Think from these 5 perspectives simultaneously:
- 🧑‍💻 **Developer**: Is this maintainable? Will a junior dev understand it?
- 👤 **User**: Does this solve the actual user pain? Is it intuitive?
- 🔒 **Attacker**: How would I exploit this? What's the attack surface?
- 📊 **Data**: What does the data flow look like? Where are bottlenecks?
- 🏗️ **Architect**: Does this fit the system? Will it scale? Is it reversible?

### Layer 3 — Rubber Duck Debugging Protocol
When debugging:
1. **State the expected behavior** (what SHOULD happen)
2. **State the actual behavior** (what IS happening)
3. **Walk through the code line-by-line** explaining each step aloud
4. **Identify the exact line** where expected ≠ actual
5. **Form a hypothesis** and design a minimal test to verify it

### Layer 4 — Decision Matrix
For any decision with >1 option:
```
| Criteria        | Option A | Option B | Option C |
|-----------------|----------|----------|----------|
| Performance     | ?/10     | ?/10     | ?/10     |
| Maintainability | ?/10     | ?/10     | ?/10     |
| Security        | ?/10     | ?/10     | ?/10     |
| Time to build   | ?/10     | ?/10     | ?/10     |
| Reversibility   | ?/10     | ?/10     | ?/10     |
| TOTAL           |          |          |          |
```

### Layer 5 — Pre-Mortem
Before implementing, imagine it's 6 months later and the solution FAILED:
- What went wrong?
- What did we miss?
- What edge case killed us?
- Address each failure mode NOW.

### Layer 6 — Incremental Verification
Never write >50 lines without verifying:
1. Write the smallest testable unit
2. Run it
3. Verify it works
4. THEN expand

### Layer 7 — Knowledge Synthesis
After solving, document:
- **What was the root cause?**
- **What was the fix?**
- **What pattern should we remember?**
- **What should we add to our rules to prevent recurrence?**

## Anti-Patterns to AVOID
- ❌ Jumping to code without understanding the problem
- ❌ Cargo-culting solutions from StackOverflow without understanding WHY they work
- ❌ Fixing symptoms instead of root causes
- ❌ "It works on my machine" without understanding deployment context
- ❌ Premature optimization before profiling
