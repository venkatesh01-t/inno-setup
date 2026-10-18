---
name: code-quality-enforcer
description: "Enforces code quality standards — complexity analysis, dead code detection, code smell identification, technical debt tracking, and automated refactoring suggestions."
---

# Code Quality Enforcer

## Trigger Conditions
- Before PR reviews or merges
- User asks to "clean up", "refactor", "reduce technical debt"
- When code files exceed 300 lines
- When cyclomatic complexity is high

## Protocol 1: Code Smell Detection

### Smells to Flag (Severity Order)

#### 🔴 Critical Smells
1. **God Class/File**: Any file >500 lines → split by responsibility
2. **Shotgun Surgery**: One change requires editing 5+ files → consolidate
3. **Deep Nesting**: >3 levels of if/for/while → extract methods/early return
4. **Copy-Paste Code**: Duplicate blocks >10 lines → extract shared utility

#### 🟠 Important Smells
5. **Long Parameter List**: >4 params → use options object
6. **Feature Envy**: Method uses another class's data more than its own → move it
7. **Dead Code**: Unreachable code, unused imports, commented-out blocks → remove
8. **Magic Numbers**: Hardcoded values without explanation → use named constants
9. **Inconsistent Naming**: Mixed conventions (camelCase + snake_case) → standardize

#### 🟡 Minor Smells
10. **TODO/FIXME without issue**: Must reference an issue tracker ID
11. **Console.log in production**: Remove or replace with proper logging
12. **Overly Complex Types**: TypeScript types >5 lines → extract to type alias
13. **Missing Error Context**: `catch(e) { throw e }` → add context

## Protocol 2: Complexity Analysis

### Cyclomatic Complexity Thresholds
| Complexity | Risk | Action |
|------------|------|--------|
| 1-5 | Low | ✅ Good |
| 6-10 | Moderate | ⚠️ Consider refactoring |
| 11-20 | High | 🟠 Refactor |
| 21+ | Very High | 🔴 Must refactor |

### How to Calculate
Count: 1 + (number of `if` + `else if` + `for` + `while` + `case` + `&&` + `||` + `?.` + `catch`)

## Protocol 3: Technical Debt Tracker

```markdown
# Technical Debt Register

| ID | Description | Location | Severity | Effort | Impact | Priority |
|----|-------------|----------|----------|--------|--------|----------|
| TD-001 | No error boundaries in React components | apps/web/ | High | 4h | High | P0 |
| TD-002 | Missing input validation on API routes | apps/api/ | Critical | 8h | Critical | P0 |
| TD-003 | Inconsistent date formatting | utils/ | Low | 2h | Medium | P2 |
```

## Protocol 4: Naming Conventions

### JavaScript/TypeScript
| Thing | Convention | Example |
|-------|-----------|---------|
| Variables | camelCase | `userName`, `isActive` |
| Functions | camelCase verb | `getUserById`, `handleSubmit` |
| Classes/Types | PascalCase | `UserService`, `PaymentGateway` |
| Constants | UPPER_SNAKE | `MAX_RETRIES`, `API_BASE_URL` |
| Files (components) | PascalCase | `UserProfile.tsx` |
| Files (utilities) | camelCase/kebab | `formatDate.ts`, `api-client.ts` |
| Booleans | is/has/can/should prefix | `isLoading`, `hasPermission` |
| Event handlers | handle prefix | `handleClick`, `handleSubmit` |
| Hooks | use prefix | `useAuth`, `useDebounce` |

## Protocol 5: Refactoring Patterns

### Extract Method
When: A block of code does something identifiable
```javascript
// BEFORE
function processOrder(order) {
  // validate
  if (!order.items.length) throw new Error('Empty')
  if (!order.customer) throw new Error('No customer')
  // calculate
  let total = 0
  for (const item of order.items) total += item.price * item.qty
  // ...
}

// AFTER
function processOrder(order) {
  validateOrder(order)
  const total = calculateTotal(order.items)
  // ...
}
```

### Replace Conditional with Early Return
```javascript
// BEFORE
function getDiscount(user) {
  if (user) {
    if (user.isPremium) {
      if (user.orders > 10) {
        return 0.2
      } else { return 0.1 }
    } else { return 0.05 }
  } else { return 0 }
}

// AFTER
function getDiscount(user) {
  if (!user) return 0
  if (!user.isPremium) return 0.05
  if (user.orders <= 10) return 0.1
  return 0.2
}
```
