# Scenario: Python FastAPI REST API

Shows how the custom-ai-workflow skill adapts for a Python backend service.

## Discovery Input

```
Repository Structure:
pyproject.toml
├── python = "^3.11"
├── fastapi = "^0.104.0"
├── sqlalchemy = "^2.0.0"
├── alembic = "^1.13.0"  (migrations)
├── pytest = "^7.4.0"
├── black = "^23.11.0"
└── ruff = "^0.1.6"

app/
  main.py                       ← Entry point
  api/
    routes/
      users.py                  ← API endpoints
      orders.py
    dependencies.py
  core/
    config.py                   ← Configuration
    security.py                 ← Auth
  models/
    user.py                     ← SQLAlchemy models
    order.py
  schemas/
    user.py                     ← Pydantic schemas (validation)
  db/
    session.py                  ← Database session
    base.py

tests/
  test_users.py
  test_orders.py
  conftest.py                   ← pytest fixtures

migrations/                     ← Alembic migrations
  versions/
    001_create_users_table.py
    002_create_orders_table.py

.github/workflows/
  test.yml                      ← pytest
  deploy.yml                    ← Docker → AWS ECR

Dockerfile

pyproject.toml (with linting config)
  black (line-length = 100)
  ruff (strict mode)
  mypy (type checking)

.env.example

Git:
  main branch (protected)
  Conventional commits
```

## Analysis Output

```javascript
{
  "projectType": "API / Microservice",
  "language": {
    "primary": "Python 3.11"
  },
  "framework": "FastAPI",
  "packageManager": "pip (via poetry or uv)",
  "testing": {
    "primary": "pytest",
    "approach": "fixture-based",
    "organization": "tests/ directory"
  },
  "database": {
    "type": "PostgreSQL",
    "orm": "SQLAlchemy 2.0",
    "migrations": "Alembic"
  },
  "linting": ["ruff", "black", "mypy"],
  "deployment": {
    "containerization": "Docker",
    "registry": "AWS ECR",
    "orchestration": "ECS or Kubernetes"
  },
  "ci": "GitHub Actions",
  "maturity": "established",
  "teamSize": "small-to-medium",
  "concerns": {
    "authentication": true,
    "database": true,
    "pii": true,
    "performance": true
  }
}
```

## Questions Asked

```
🤔 Type Checking Strategy
I found mypy configuration. How strict?

A) Strict mode (strict: true)
   → All types explicit, no implicit Any
B) Pragmatic (strict: false with specific checks)
   → Some flexibility on types
C) Loose (no mypy checks)

User selects: A
```

```
🤔 Testing Scope
What tests are required for L2+ features?

A) Unit tests only (mocked database)
B) Integration tests (real database)
C) Both

User selects: C
```

## Generated Files

### `.ai/SKILL.md` (excerpt)

```markdown
# User API FastAPI Service

v0.1 · customized 2026-10-05

## Stack

- **Language**: Python 3.11
- **Framework**: FastAPI (async REST API)
- **Database**: PostgreSQL with SQLAlchemy 2.0
- **Migrations**: Alembic (SQL-based)
- **Testing**: pytest with fixtures
- **Type Checking**: mypy (strict mode)
- **Formatting**: Black + ruff
- **Deployment**: Docker → AWS ECR

## Quick Commands

```bash
pytest                          # Run all tests
pytest --cov                    # With coverage
black . && ruff check .         # Format + lint
mypy .                          # Type check
uvicorn app.main:app --reload  # Dev server
```

## Workflows

- **Feature**: New endpoint → tests → PR
- **Bug**: Reproduce in test → fix → verify
- **Database**: Alembic migration → tests
- **API**: Check schema validation (Pydantic)
```

### `rules/engineering.md` (excerpt)

```markdown
# Python Engineering Standards

## Style

Follow PEP 8 with Black formatter:

```bash
black .
ruff check . --fix  # Auto-fix simple issues
```

## Naming

- **Functions & variables**: snake_case (`get_user`, `is_active`)
- **Classes**: PascalCase (`User`, `UserService`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_RETRIES`, `API_TIMEOUT`)

```python
class UserService:
    def get_user(self, user_id: str) -> User:
        # Implementation
        pass

MAX_RETRIES = 3
```

## Type Hints

Strict mode enabled. All types explicit:

```python
# ✅ Good: explicit types
from typing import Optional
from sqlalchemy.orm import Session

def get_user(db: Session, user_id: str) -> Optional[User]:
    return db.query(User).filter(User.id == user_id).first()

# ❌ Bad: missing types
def get_user(db, user_id):
    return db.query(User).filter(User.id == user_id).first()
```

Run mypy:

```bash
mypy .
```

## Error Handling

```python
# ✅ Good: explicit exception handling
try:
    user = get_user(db, user_id)
    if not user:
        raise ValueError("User not found")
except ValueError as e:
    raise HTTPException(status_code=404, detail=str(e))

# ✅ Good: custom exceptions
class UserNotFound(Exception):
    pass

# Use in endpoints
@app.get("/users/{user_id}")
def get_user_endpoint(user_id: str, db: Session = Depends(get_db)):
    try:
        return UserService(db).get_user(user_id)
    except UserNotFound:
        raise HTTPException(status_code=404)
```

## Imports

Organized groups:

```python
# Standard library
import asyncio
from typing import Optional

# Third-party
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

# Local
from app.models import User
from app.schemas import UserSchema
from app.core.security import verify_token
```

## Async Code

FastAPI uses async/await. Use properly:

```python
# ✅ Good: async endpoint
@app.get("/users/{user_id}")
async def get_user(user_id: str, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    return user

# ✅ Good: async operation
async def fetch_external_data(url: str):
    async with httpx.AsyncClient() as client:
        response = await client.get(url)
        return response.json()

# ❌ Bad: blocking call in async endpoint
@app.get("/users/{user_id}")
async def get_user(user_id: str):
    user = requests.get(f"http://other-api/{user_id}").json()  # Blocks!
    return user
```
```

### `rules/testing.md` (excerpt)

```markdown
# Testing Standards

## Framework: pytest

```bash
pytest                    # Run all tests
pytest --watch            # Watch mode
pytest --cov              # Coverage report
pytest -v                 # Verbose
pytest tests/test_users.py::test_get_user  # Single test
```

## Test Organization

```
tests/
  test_users.py           ← Tests for user endpoints
  test_orders.py          ← Tests for order endpoints
  conftest.py             ← Shared fixtures
```

## Fixtures (Setup/Teardown)

```python
# conftest.py
import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

@pytest.fixture
def db_session():
    # Create test database
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)
    
    Session = sessionmaker(bind=engine)
    session = Session()
    
    yield session
    
    session.close()

@pytest.fixture
def client(db_session):
    # Inject test database into app
    def override_get_db():
        return db_session
    
    app.dependency_overrides[get_db] = override_get_db
    
    return TestClient(app)
```

## Testing Patterns

```python
# tests/test_users.py

def test_get_user_success(client, db_session):
    """Should return user if exists"""
    # Arrange: Set up test data
    user = User(id="123", name="John", email="john@example.com")
    db_session.add(user)
    db_session.commit()
    
    # Act: Call endpoint
    response = client.get("/users/123")
    
    # Assert: Verify response
    assert response.status_code == 200
    assert response.json()["name"] == "John"

def test_get_user_not_found(client):
    """Should return 404 if user doesn't exist"""
    response = client.get("/users/999")
    assert response.status_code == 404

@pytest.mark.parametrize("user_id,status_code", [
    ("123", 200),
    ("invalid", 400),
    ("999", 404),
])
def test_get_user_various(client, db_session, user_id, status_code):
    """Parametrized test for various inputs"""
    if user_id == "123":
        db_session.add(User(id="123", name="John"))
        db_session.commit()
    
    response = client.get(f"/users/{user_id}")
    assert response.status_code == status_code
```

## Ceremony by Level

- **L0**: No test (typo in comment)
- **L1**: Manual test (try endpoint in swagger UI)
- **L2**: Unit test with mocked database
- **L3**: Integration test with real test database
- **L4**: Full coverage + load testing

## Coverage Target

Run with coverage:

```bash
pytest --cov=app --cov-report=html
```

Targets:
- New code: 80%+ coverage
- Critical paths: 100%
- Overall: 70%+ across project
```

### `rules/database.md` (excerpt)

```markdown
# Database Standards

## SQLAlchemy 2.0

Modern, async-friendly ORM:

```python
from sqlalchemy import Column, String, DateTime
from sqlalchemy.orm import DeclarativeBase

class Base(DeclarativeBase):
    pass

class User(Base):
    __tablename__ = "users"
    
    id: Mapped[str] = mapped_column(primary_key=True)
    email: Mapped[str] = mapped_column(unique=True)
    created_at: Mapped[datetime] = mapped_column(default=datetime.utcnow)
```

## Migrations (Alembic)

SQL-based migrations (versioned, reversible):

```
migrations/versions/
  001_create_users.py
  002_add_email_constraint.py
```

```python
# migrations/versions/001_create_users.py
def upgrade():
    op.create_table('users',
        sa.Column('id', sa.String(), nullable=False),
        sa.Column('email', sa.String(), nullable=False),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('email')
    )

def downgrade():
    op.drop_table('users')
```

Generate new migration:

```bash
alembic revision --autogenerate -m "create users table"
alembic upgrade head      # Apply
alembic downgrade -1      # Rollback 1
```

## Database Session

Use dependency injection:

```python
from sqlalchemy.orm import Session
from fastapi import Depends

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/users/{user_id}")
def get_user(user_id: str, db: Session = Depends(get_db)):
    return db.query(User).filter(User.id == user_id).first()
```

## Validation (Pydantic)

Request/response validation:

```python
from pydantic import BaseModel, Field

class UserSchema(BaseModel):
    id: str
    email: str
    name: str = Field(..., min_length=1, max_length=100)
    
    class Config:
        from_attributes = True  # From SQLAlchemy models

@app.post("/users")
def create_user(user: UserSchema, db: Session = Depends(get_db)):
    db_user = User(**user.dict())
    db.add(db_user)
    db.commit()
    return db_user
```

## PII Handling

User data encrypted at rest:

```python
from cryptography.fernet import Fernet

KEY = os.getenv("ENCRYPTION_KEY")
cipher = Fernet(KEY)

class User(Base):
    email = Column(String, unique=True)  # Encrypted in DB
```

Never log PII:

```bash
# ❌ Bad
logger.info(f"User email: {user.email}")

# ✅ Good
logger.info(f"User created: {user.id}")
```
```

## Generated Commit Message

```
adopt: initialize AI workflow for User API

Discovered:
- Python 3.11 FastAPI REST API
- PostgreSQL with SQLAlchemy 2.0 ORM
- Alembic for versioned migrations
- pytest with fixture-based testing
- mypy (strict type checking)
- Docker containerized → AWS ECR

Generated:
- .ai/SKILL.md — FastAPI-specific guidance
- .ai/AGENTS.md — investigator + reviewer roles
- rules/engineering.md — Python conventions (PEP 8, type hints)
- rules/testing.md — pytest fixtures and integration tests
- rules/database.md — SQLAlchemy patterns and Alembic migrations
- rules/api.md — FastAPI endpoint conventions

Assumptions:
- mypy strict mode (all types explicit)
- Integration tests require real database
- Alembic migrations always reversible
- Pydantic for request/response validation
- PII encrypted and never logged
- async/await patterns for FastAPI

Co-Authored-By: custom-ai-workflow skill <noreply@anthropic.com>
```

---

## Example Agent Interaction

### Task: "Add email verification with token expiry"

1. **Discover**: Python project with FastAPI, SQLAlchemy, Alembic, pytest

2. **Understand**: Current auth approach? Check `core/security.py`

3. **Classify**: L3 (new endpoint, database migration, tests)

4. **Plan**:
   ```
   Feature: Email verification tokens
   Database: Migration to add verification_token and token_expires_at columns
   Endpoint: POST /users/verify-email with token validation
   Tests: Unit test for token validation + integration test for endpoint
   Verification: pytest --cov, mypy check
   ```

5. **Implement**:
   - Alembic migration: `003_add_verification_tokens.py`
   - SQLAlchemy model: Add `verification_token`, `token_expires_at` columns
   - Pydantic schema: `VerifyEmailRequest`
   - FastAPI endpoint: `verify_email` route
   - Tests: Unit test for token logic, integration test for endpoint

6. **Verify**:
   ```bash
   pytest --cov=app
   mypy .
   black . && ruff check .
   ```

7. **Review**:
   - Check type hints (mypy passes)
   - Verify integration test hits real database
   - Check PII not logged (email token especially)
   - Verify migration is reversible
