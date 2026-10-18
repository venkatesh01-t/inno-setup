---
name: error-explainer
description: "Expert error diagnosis — parses stack traces, explains errors in plain language, identifies root causes, suggests fixes, and links to relevant documentation. The AI equivalent of a senior developer looking over your shoulder."
---

# Error Explainer & Stack Trace Analyzer

## Trigger Conditions
- User pastes an error message or stack trace
- Build or test failure occurs
- Runtime exception in logs
- User asks "what does this error mean?"

## Protocol: Error Analysis Pipeline

### Step 1: Parse the Error
Extract:
- **Error type**: TypeError, ReferenceError, SyntaxError, custom errors
- **Error message**: The human-readable description
- **Stack trace**: File locations and call chain
- **Context**: What operation was being attempted

### Step 2: Explain in Plain Language
```markdown
## 🔴 Error: [Error Type]
**What happened**: [Plain language explanation]
**Why**: [Root cause in simple terms]
**Where**: [file:line — the actual source of the error]
```

### Step 3: Common Error Patterns

#### JavaScript/TypeScript
| Error | Usually Means | Fix |
|-------|--------------|-----|
| `Cannot read properties of undefined` | Accessing property on null/undefined | Add null check or optional chaining `?.` |
| `X is not a function` | Wrong import, typo, or wrong type | Check imports and variable types |
| `Module not found` | Missing dependency or wrong path | `npm install` or fix import path |
| `ECONNREFUSED` | Service not running | Start the database/server/service |
| `CORS error` | Missing CORS headers | Configure CORS on the backend |
| `Hydration mismatch` | Server/client HTML differs | Fix SSR conditional rendering |
| `Maximum call stack exceeded` | Infinite recursion | Add base case to recursive function |

#### React Specific
| Error | Usually Means | Fix |
|-------|--------------|-----|
| `Invalid hook call` | Hook outside component or conditional | Move hook to top level |
| `Too many re-renders` | setState in render body | Move to useEffect or event handler |
| `Each child should have unique key` | Missing key in .map() | Add unique key prop |
| `Cannot update unmounted component` | Async callback after unmount | Cleanup in useEffect |

#### Node.js / Backend
| Error | Usually Means | Fix |
|-------|--------------|-----|
| `EADDRINUSE` | Port already in use | Kill the other process or change port |
| `ENOMEM` | Out of memory | Increase memory limit or fix leak |
| `ETIMEOUT` | Connection/query timeout | Increase timeout or optimize query |
| `ER_DUP_ENTRY` | Unique constraint violation | Handle duplicate gracefully |

### Step 4: Suggest Fix
1. **Immediate fix**: The minimal change to resolve the error
2. **Proper fix**: The correct long-term solution
3. **Prevention**: How to prevent this class of error in the future

### Step 5: Link Documentation
Provide relevant links to official docs when applicable.
