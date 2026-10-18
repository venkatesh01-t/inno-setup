---
name: api-tester
description: "Automated API testing — generates comprehensive test suites, validates endpoints, checks response schemas, performance benchmarks, and creates Postman-compatible collections."
---

# API Testing Engine

## Trigger Conditions
- User builds or modifies API endpoints
- User asks to "test the API", "validate endpoints"
- Before deploying API changes
- When documenting APIs

## Protocol 1: Endpoint Discovery
1. Scan route files for all endpoints
2. For each endpoint, identify: method, path, params, body schema, auth requirement
3. Generate a test matrix

## Protocol 2: Test Generation

### For Each Endpoint, Generate:

#### Happy Path Tests
- Valid request with all required fields → expect 200/201
- Valid request with optional fields → expect 200/201

#### Validation Tests
- Missing required field → expect 400
- Invalid data type → expect 400
- Empty body on POST/PUT → expect 400
- Invalid enum value → expect 400

#### Auth Tests
- No auth token → expect 401
- Expired token → expect 401
- Valid token, wrong role → expect 403
- Valid token, correct role → expect 200

#### Edge Cases
- Very long strings (10000 chars) → expect 400 or handled
- Special characters in input → not causing injection
- Concurrent duplicate requests → idempotent
- Rate limiting → expect 429 after threshold

#### Performance Tests
- Response time <200ms under normal load
- Response time <1s under 10x load

## Protocol 3: Test Template (Vitest/Jest)

```typescript
describe('POST /api/users', () => {
  it('should create user with valid data', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ name: 'Test', email: 'test@example.com' })
      .set('Authorization', `Bearer ${token}`)

    expect(response.status).toBe(201)
    expect(response.body).toMatchObject({
      id: expect.any(String),
      name: 'Test',
      email: 'test@example.com',
    })
  })

  it('should reject missing email', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ name: 'Test' })
      .set('Authorization', `Bearer ${token}`)

    expect(response.status).toBe(400)
    expect(response.body.error).toContain('email')
  })

  it('should reject unauthenticated requests', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ name: 'Test', email: 'test@example.com' })

    expect(response.status).toBe(401)
  })
})
```

## Protocol 4: API Documentation
Generate OpenAPI/Swagger-compatible docs for discovered endpoints.
