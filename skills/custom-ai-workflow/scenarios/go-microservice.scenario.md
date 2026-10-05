# Scenario: Go Microservice (REST API)

Shows how the custom-ai-workflow skill adapts for a Go backend service.

## Discovery Input

```
Repository Structure:
go.mod (go 1.22)
├── github.com/gin-gonic/gin
├── github.com/sqlc-dev/sqlc
├── github.com/golang-migrate/migrate
└── github.com/stretchr/testify

cmd/api/main.go                   ← Entry point

internal/
  handlers/                       ← HTTP handlers
    user_handler.go
    user_handler_test.go
  db/                             ← Database layer
    queries.sql.go                ← sqlc generated
  models/
    user.go
  middleware/
    auth.go

migrations/
  001_create_users.up.sql        ← SQL migrations
  001_create_users.down.sql

.github/workflows/
  test.yml                        ← go test ./...
  build.yml                       ← go build
  deploy.yml                      ← Docker → GCR

Dockerfile                        ← Container image
Makefile                          ← make dev, make test

Git:
  main branch (protected)
  Squash merge strategy
```

## Analysis Output

```javascript
{
  "projectType": "API / Microservice",
  "language": {
    "primary": "Go 1.22"
  },
  "framework": "Gin (REST API)",
  "packageManager": "go mod",
  "testing": {
    "primary": "Go testing",
    "approach": "table-driven tests",
    "organization": "colocated",
    "coverage": 80
  },
  "database": {
    "type": "PostgreSQL",
    "queryBuilder": "sqlc",
    "migrations": "golang-migrate"
  },
  "linting": ["golangci-lint"],
  "deployment": {
    "containerization": "Docker",
    "registry": "Google Container Registry",
    "orchestration": "Kubernetes (assumed from k8s manifests)"
  },
  "ci": "GitHub Actions",
  "maturity": "mature",
  "teamSize": "medium",
  "concerns": {
    "authentication": true,
    "database": true,
    "performance": true,
    "reliability": true
  }
}
```

## Questions Asked

```
🤔 Error Handling Pattern
How should errors be handled?

A) Explicit error handling (check err != nil pattern)
   → Return errors wrapped with context
B) Result type wrapper
   → Custom Result<T,E> pattern

User selects: A
```

```
🤔 Testing Ceremony
What's required for database migrations?

A) Unit tests with mocks
B) Integration tests with real database
C) Both

User selects: C
```

## Generated Files

### `.ai/SKILL.md` (excerpt)

```markdown
# Order API Microservice

v0.1 · customized 2026-10-05

## Stack

- **Language**: Go 1.22
- **Framework**: Gin (REST API)
- **Database**: PostgreSQL with sqlc
- **Migrations**: golang-migrate
- **Testing**: Go testing + table-driven tests
- **Deployment**: Docker → Kubernetes

## Quick Commands

```bash
make test           # go test ./...
make build          # go build
make dev            # Run locally with hot reload
make lint           # golangci-lint run

go test ./... -cover
go test -race ./... # Check for race conditions
```

## Workflows

- **Feature**: API endpoint → `rules/api.md`
- **Bug Fix**: Reproduce with tests → `rules/debugging.md`
- **Database**: Migration → `rules/database.md`
- **Deployment**: Docker build → verify on k8s
```

### `rules/engineering.md` (excerpt)

```markdown
# Go Engineering Standards

## Code Style

Format with gofmt (automatic on save):

```bash
gofmt -w .
goimports -w .  # Also organize imports
```

## Naming

- **Exported (public)**: PascalCase → `GetUser`, `UserHandler`
- **Unexported (private)**: camelCase → `getUser`, `userHandler`
- **Interfaces**: `-er` suffix → `Reader`, `Writer`, `Handler`

```go
type UserService interface {
    GetUser(ctx context.Context, id string) (*User, error)
    CreateUser(ctx context.Context, u *User) error
}

func (h *UserHandler) GetUser(w http.ResponseWriter, r *http.Request) {
    // Handler code
}
```

## Error Handling

```go
// ✅ Good: wrapped errors with context
user, err := db.GetUser(ctx, id)
if err != nil {
    return nil, fmt.Errorf("get user: %w", err)
}

// ✅ Good: type-safe error checking
var pgErr *pgconn.PgError
if errors.As(err, &pgErr) {
    if pgErr.Code == "23505" { // unique violation
        return ErrDuplicate
    }
}

// ❌ Bad: ignoring errors
user, _ := db.GetUser(ctx, id)
```

## Concurrency

Use goroutines and channels carefully:

```go
// ✅ Good: explicit synchronization
var wg sync.WaitGroup
for _, job := range jobs {
    wg.Add(1)
    go func(j Job) {
        defer wg.Done()
        // work
    }(job)
}
wg.Wait()

// Check for races
go test -race ./...
```

## Imports

Organize in groups:

```go
import (
    "context"       // stdlib
    "fmt"
    
    "github.com/gin-gonic/gin"  // external
    "github.com/lib/pq"
    
    "order-api/internal/db"     // internal
    "order-api/internal/models"
)
```
```

### `rules/testing.md` (excerpt)

```markdown
# Testing Standards

## Framework: Go Testing

Standard library testing (no external framework):

```bash
go test ./...                 # Run all tests
go test -v ./...              # Verbose output
go test -race ./...           # Check data races
go test -cover ./...          # Coverage
go test -coverprofile=c.out && go tool cover -html=c.out
```

## Test File Organization

```
internal/
  handlers/
    user_handler.go
    user_handler_test.go      ← Tests colocated
```

Test functions:
- Exported function `GetUser` → test `TestGetUser`
- Test helper `setupDB` → test `testSetupDB`

## Table-Driven Tests

```go
func TestGetUser(t *testing.T) {
    tests := []struct {
        name    string
        id      string
        want    *User
        wantErr bool
    }{
        {
            name: "valid user",
            id:   "123",
            want: &User{ID: "123", Name: "John"},
        },
        {
            name:    "not found",
            id:      "999",
            wantErr: true,
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            user, err := GetUser(context.Background(), tt.id)
            if (err != nil) != tt.wantErr {
                t.Errorf("error = %v, wantErr %v", err, tt.wantErr)
            }
            if !reflect.DeepEqual(user, tt.want) {
                t.Errorf("user = %v, want %v", user, tt.want)
            }
        })
    }
}
```

## Integration Tests (Database)

Tests that interact with real PostgreSQL:

```bash
go test -tags=integration ./...
```

```go
// +build integration

func TestCreateUserIntegration(t *testing.T) {
    db := testDB(t)  // Real database for test
    defer db.Close()

    user := &User{Name: "John"}
    err := db.CreateUser(context.Background(), user)
    if err != nil {
        t.Fatalf("CreateUser failed: %v", err)
    }

    // Verify in database
    got, _ := db.GetUser(context.Background(), user.ID)
    if got.Name != user.Name {
        t.Errorf("saved name = %s, want %s", got.Name, user.Name)
    }
}
```

## Ceremony by Level

- **L0**: No test
- **L1**: Run existing tests to verify no regressions
- **L2**: Add table-driven unit test
- **L3**: Add integration test with real database
- **L4**: Full coverage + race condition testing

```bash
go test -cover -race ./...
```
```

### `rules/database.md` (excerpt)

```markdown
# Database Standards

## Migrations

SQL-based with golang-migrate:

```
migrations/
  001_create_users.up.sql
  001_create_users.down.sql
  002_add_email_users.up.sql
  002_add_email_users.down.sql
```

Always create `.up.sql` and `.down.sql` pairs (reversible migrations).

## Queries

Type-safe with sqlc:

```sql
-- queries.sql
-- name: GetUser :one
SELECT id, name, email FROM users WHERE id = $1;

-- name: CreateUser :exec
INSERT INTO users (id, name, email) VALUES ($1, $2, $3);
```

Generate Go code:

```bash
sqlc generate
```

Produces: `queries.sql.go` with typed functions

```go
user, err := db.GetUser(ctx, id)  // Type-safe
```

## Running Migrations

```bash
migrate -path migrations -database postgres://... up
migrate -path migrations -database postgres://... down 1
```

## Testing with Database

Use testcontainers for integration tests:

```go
func testDB(t *testing.T) *sql.DB {
    // Creates temporary Postgres container
    // Runs migrations
    // Returns connection
}
```

## Data Constraints

- No NULL in required columns
- Foreign keys enforce referential integrity
- Indexes on frequently queried columns
- Check constraints for domain rules
```

## Generated Commit Message

```
adopt: initialize AI workflow for Order API

Discovered:
- Go 1.22 microservice
- Gin REST API framework
- PostgreSQL with sqlc type-safe queries
- golang-migrate for versioned migrations
- Table-driven testing approach
- Docker containerized, deployed to Kubernetes

Generated:
- .ai/SKILL.md — Go/Gin-specific guidance
- .ai/AGENTS.md — investigator + reviewer roles
- rules/engineering.md — Go conventions (gofmt, error handling)
- rules/testing.md — table-driven tests + integration approach
- rules/database.md — SQL migrations and sqlc patterns
- rules/api.md — Gin REST API patterns

Assumptions:
- Explicit error handling (check err != nil)
- Integration tests use real database
- Table-driven tests for coverage
- Migrations always reversible
- Race condition testing on critical paths

Co-Authored-By: custom-ai-workflow skill <noreply@anthropic.com>
```

---

## Example Agent Interaction

### Task: "Add user email verification endpoint"

1. **Discover**: Go project with sqlc, migrations, Gin

2. **Understand**: How do current endpoints work? Check `handlers/user_handler.go`

3. **Classify**: L3 (new API endpoint, database schema change, new migration)

4. **Plan**:
   ```
   Feature: Email verification endpoint
   Affected: handlers/user_handler.go, queries.sql, schema
   New: verifyEmail endpoint, migration
   Tests: Unit test for handler + integration test
   Database: Migration to add verified_at column
   Verify: go test -cover ./... && docker build && deploy to staging
   ```

5. **Implement**:
   - Create migration: `003_add_verified_at_users.up/down.sql`
   - Add query to sqlc: `-- name: VerifyUser :exec`
   - Create handler: `VerifyEmailHandler`
   - Table-driven test for happy path + edge cases
   - Integration test hitting real database

6. **Verify**:
   ```bash
   go test -race ./...
   go test -cover ./...
   make build
   docker build -t api:latest .
   ```

7. **Review**:
   - Check error handling (wrapped with context)
   - Verify migration is reversible
   - Check test coverage (table-driven test handles cases)
   - Verify no race conditions: `go test -race`
