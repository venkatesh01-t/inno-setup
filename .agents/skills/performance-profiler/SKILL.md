---
name: performance-profiler
description: "Automated performance profiling — Lighthouse audits, bundle size analysis, memory leak detection, database query optimization, and runtime profiling. Makes apps blazing fast."
---

# Performance Profiler & Optimizer

## Trigger Conditions
- User asks to "optimize performance", "make it faster", "reduce bundle size"
- App feels slow or unresponsive
- Before production deployment
- Database queries taking >100ms

## Protocol 1: Frontend Performance Audit

### Bundle Analysis
1. Check `package.json` for heavy dependencies:
   - moment.js → use date-fns or dayjs
   - lodash (full) → use lodash-es with tree-shaking
   - Large UI libraries imported in full
2. Look for: `import X from 'library'` → should be `import { X } from 'library'`
3. Check for dynamic imports on route-level components
4. Verify tree-shaking is working (no side-effect imports)

### Rendering Performance
- [ ] No unnecessary re-renders (React: memo, useMemo, useCallback)
- [ ] Lists use proper keys (not index)
- [ ] Heavy computations memoized
- [ ] Images lazy-loaded below fold
- [ ] Virtualization for lists >100 items
- [ ] No layout thrashing (batch DOM reads/writes)

### Core Web Vitals Targets
| Metric | Good | Needs Work | Poor |
|--------|------|------------|------|
| LCP (Largest Contentful Paint) | <2.5s | 2.5-4s | >4s |
| INP (Interaction to Next Paint) | <200ms | 200-500ms | >500ms |
| CLS (Cumulative Layout Shift) | <0.1 | 0.1-0.25 | >0.25 |

### Quick Wins Checklist
- [ ] Enable gzip/brotli compression
- [ ] Set proper cache headers (immutable for hashed assets)
- [ ] Preload critical fonts and above-fold images
- [ ] Defer non-critical JS (`defer` or dynamic import)
- [ ] Use `<link rel="preconnect">` for external domains
- [ ] Optimize images (WebP/AVIF, proper sizing)
- [ ] Use CSS containment for complex layouts
- [ ] Implement skeleton loading states

## Protocol 2: Backend Performance Audit

### Database Query Optimization
1. **Identify slow queries**: Look for queries without WHERE clauses or missing indexes
2. **N+1 detection**: Look for queries inside loops
   ```
   // BAD: N+1
   const users = await db.user.findMany()
   for (const user of users) {
     const posts = await db.post.findMany({ where: { userId: user.id } })
   }
   
   // GOOD: Eager loading
   const users = await db.user.findMany({ include: { posts: true } })
   ```
3. **Index recommendations**: Columns used in WHERE, ORDER BY, JOIN
4. **Connection pooling**: Verify pool size matches workload

### API Response Times
- [ ] Endpoints respond in <200ms (p95)
- [ ] Heavy operations offloaded to background jobs
- [ ] Response pagination (no unbounded queries)
- [ ] Proper caching (Redis, CDN, HTTP cache)
- [ ] Compression enabled on API responses

### Memory Leak Detection
Signs of memory leaks:
- Growing memory usage over time
- Event listeners not being cleaned up
- Closures holding references to large objects
- Uncleared timers/intervals
- Global variables accumulating data

Detection commands:
```bash
# Node.js heap snapshot
node --inspect app.js
# Then in Chrome DevTools: Memory tab → Take heap snapshot

# Process memory monitoring
node -e "setInterval(() => console.log(process.memoryUsage()), 5000)"
```

## Protocol 3: Performance Report

```markdown
# ⚡ Performance Report — [Date]

## Overall Score: X/100

## Frontend Metrics
| Metric | Current | Target | Status |
|--------|---------|--------|--------|
| LCP | Xs | <2.5s | ✅/❌ |
| INP | Xms | <200ms | ✅/❌ |
| CLS | X | <0.1 | ✅/❌ |
| Bundle Size | XKB | <200KB | ✅/❌ |

## Backend Metrics
| Endpoint | p50 | p95 | p99 | Status |
|----------|-----|-----|-----|--------|

## Top 5 Performance Issues
1. [Issue + fix]
2. ...

## Optimization Roadmap
1. [Quick win — 1h effort, big impact]
2. [Medium effort — 4h, significant impact]
3. [Major — 1-2d, transformative impact]
```
