# Engineering Standards

Conventions and standards for [PROJECT_NAME] code.

## Language: [PRIMARY_LANGUAGE]

[LANGUAGE:typescript]

### TypeScript Configuration

```json
{
  "compilerOptions": {
    "strict": true,
    "target": "ES2020",
    "module": "ESNext"
  }
}
```

**Strict mode enabled**: All types are explicit.
- No implicit `any`
- All parameters and returns typed
- Union types narrowed before use

### Naming Conventions

- **Variables & functions**: camelCase (`isActive`, `getUserById`)
- **Classes & types**: PascalCase (`User`, `ApiResponse`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_RETRIES`, `API_TIMEOUT`)
- **Files**: kebab-case or camelCase matching exports (e.g., `user-service.ts` exports `userService`)

### Import Style

```typescript
// Prefer absolute paths
import { Button } from '@/components/Button'
import { useUser } from '@/hooks/useUser'
import { API_BASE_URL } from '@/config'

// Avoid relative paths (especially ../)
// ❌ import { Button } from '../../../components/Button'
```

Configured in `tsconfig.json` with `baseUrl` and `paths`.

### Type Annotations

```typescript
// ✅ Good: explicit types
function getUserById(id: string): Promise<User> {
  return db.users.findById(id)
}

// ❌ Bad: implicit any
function getUserById(id) {
  return db.users.findById(id)
}
```

All function parameters and return types must be annotated.

### Exports

Use named exports (not default):

```typescript
// ✅ Good
export const Button = () => { ... }
export const Input = () => { ... }

// Index file exports public API
export * from './Button'
export * from './Input'

// ❌ Avoid
export default Button
```

[LANGUAGE:go]

### Code Style

Format with `gofmt`:

```bash
gofmt -w .
```

Or use editor integration (VS Code: save with formatting).

### Naming Conventions

- **Exported (public)**: PascalCase (`GetUser`, `UserService`)
- **Unexported (private)**: camelCase (`getUser`, `userService`)
- **Constants**: CamelCase, prefixed with const keyword

```go
const MaxRetries = 3
const dbTimeout = 5 * time.Second

var (
    ErrUserNotFound = errors.New("user not found")
    ErrInvalidID    = errors.New("invalid user id")
)
```

### Import Organization

```go
import (
    "fmt"           // stdlib
    "net/http"      // stdlib
    
    "github.com/gin-gonic/gin"  // external
    "project/internal/db"       // internal
)
```

Organized in three groups:
1. Standard library
2. Third-party (external dependencies)
3. Internal packages (your code)

### Error Handling

```go
// ✅ Good: explicit error handling
user, err := db.GetUser(id)
if err != nil {
    return nil, fmt.Errorf("get user: %w", err)
}

// ✅ Good: typed errors
if errors.Is(err, ErrUserNotFound) {
    // handle not found
}

// ❌ Avoid: ignoring errors
user, _ := db.GetUser(id)
```

[LANGUAGE:python]

### Style

Follow PEP 8 with Black formatter:

```bash
black .
```

### Naming Conventions

- **Variables & functions**: snake_case (`is_active`, `get_user_by_id`)
- **Classes**: PascalCase (`User`, `ApiResponse`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_RETRIES`, `API_TIMEOUT`)

### Type Hints

```python
# ✅ Good: explicit types
from typing import Optional

def get_user_by_id(user_id: str) -> Optional[User]:
    return db.users.find_by_id(user_id)

# ❌ Bad: no type hints
def get_user_by_id(user_id):
    return db.users.find_by_id(user_id)
```

Enable with: `python -m mypy .`

[LANGUAGE:rust]

### Style

Format with `rustfmt`:

```bash
cargo fmt
```

### Naming Conventions

- **Functions & variables**: snake_case (`is_active`, `get_user_by_id`)
- **Types & traits**: PascalCase (`User`, `ApiResponse`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_RETRIES`, `API_TIMEOUT`)

### Error Handling

Use `Result<T, E>` type:

```rust
// ✅ Good
fn get_user_by_id(id: &str) -> Result<User, DbError> {
    db.find_user(id).ok_or(DbError::NotFound)
}

// Handle with match or ?
match get_user_by_id(id) {
    Ok(user) => println!("{:?}", user),
    Err(e) => eprintln!("Error: {}", e),
}
```

---

## Code Quality Tools

### Linting

```bash
[LANGUAGE:typescript]
npm run lint          # ESLint v[VERSION]

[LANGUAGE:go]
golangci-lint run ./...

[LANGUAGE:python]
flake8 .
pylint .

[LANGUAGE:rust]
cargo clippy
```

Run on save (recommended with editor integration).

### Formatting

```bash
[LANGUAGE:typescript]
npm run format --write    # Prettier v[VERSION]

[LANGUAGE:go]
gofmt -w .

[LANGUAGE:python]
black .

[LANGUAGE:rust]
cargo fmt
```

### Type Checking

[LANGUAGE:typescript]
```bash
npm run type-check    # or tsc --noEmit
```

[LANGUAGE:go]
Built into `go build` and `go vet`

[LANGUAGE:python]
```bash
mypy .
```

[LANGUAGE:rust]
Built into `cargo check` and `cargo build`

### Before Committing

```bash
npm run lint --fix && npm run format --write && npm test
```

Or use git hooks (see `rules/git.md`).

---

## Best Practices

### DRY (Don't Repeat Yourself)

- Look for existing utilities before creating new ones
- Check `src/lib/` and shared packages first
- Extract common patterns into utilities

### SOLID Principles

- **Single Responsibility**: Each function/class does one thing
- **Open/Closed**: Open for extension, closed for modification
- **Liskov Substitution**: Subtypes are substitutable for supertypes
- **Interface Segregation**: Small, focused interfaces
- **Dependency Inversion**: Depend on abstractions, not concretions

### Comments

Comment **why**, not **what**:

```typescript
// ✅ Good: explains the reasoning
// We retry with exponential backoff because initial requests
// might fail due to cold-start or rate limiting
async function fetchWithRetry(url: string) { ... }

// ❌ Bad: restates the code
// Get the user by ID
function getUser(id: string) { ... }
```

### Functions

Keep functions small and focused:
- One responsibility
- < 50 lines of code (guideline)
- Descriptive name that explains purpose
- Limited parameters (3-4 max)

### Complexity Management

- Extract nested logic into helper functions
- Use early returns to reduce indentation
- Prefer composition over inheritance

---

## Special Conventions

[CONDITIONAL:has-database]

### Database Code

- Queries in `src/db/` or similar
- Use parameterized queries (never string concatenation)
- One function per query (or logical group)
- Migration files versioned: `migrations/001_create_users.sql`

[CONDITIONAL:has-authentication]

### Auth Code

- Never log tokens or passwords
- Use `.slice(0, 4)` for debugging (show only first 4 chars)
- Store tokens in secure cookies (not localStorage)
- Validate tokens server-side on every request

[CONDITIONAL:is-ui]

### UI Components

- One component per file (or closely related components)
- Props clearly typed or documented
- Prefer composition: `<Button />` over `<div className="btn">`
- Use design tokens: `<Button className="px-4 py-2" />` (not hardcoded sizes)

[CONDITIONAL:has-external-apis]

### External API Calls

- Centralize in `src/services/` or `src/api/`
- Handle rate limiting with retries
- Log request/response for debugging (not sensitive data)
- Mock in tests

---

## Running Checks

Quick check before committing:

```bash
[LANGUAGE:typescript]
npm run lint && npm run type-check && npm test

[LANGUAGE:go]
go vet ./... && go test ./... && golangci-lint run

[LANGUAGE:python]
flake8 . && mypy . && pytest

[LANGUAGE:rust]
cargo clippy && cargo test
```

---

## When in Doubt

1. Check existing code in same directory
2. Follow the same style as surrounding code
3. Read comments in related files
4. Ask the team (see AGENTS.md)
