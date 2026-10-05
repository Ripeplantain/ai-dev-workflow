# Step 1: Discover Repository Context

Analyze the repository's actual structure, tooling, conventions, and patterns without assuming anything.

## Discovery Protocol

Never assume. Look for evidence:

```
Evidence → Inference → Question → Answer → Rule
```

Run these discovery commands in order:

### A. Detect Root Information

```bash
# Repository basics
git config user.name                    # Who commits here?
git log --oneline | head -5             # Recent activity pattern
git branch -a | head -10                # Branch naming convention
find . -name ".gitignore" -o -name ".editorconfig" | head -5

# Project identity
head -20 README.md
head -10 package.json
head -10 go.mod pyproject.toml Cargo.toml 2>/dev/null
```

**What to infer:**
- Is this a monorepo or single project?
- What language(s) dominate?
- How active is the project?
- What's the stated purpose?

### B. Detect Package Managers & Languages

```bash
# Node.js
[ -f package.json ] && echo "npm/yarn/pnpm" && head -20 package.json
[ -f pnpm-workspace.yaml ] && echo "pnpm monorepo"
[ -f lerna.json ] && echo "lerna"
[ -f nx.json ] && echo "Nx monorepo"

# Python
[ -f pyproject.toml ] && echo "Python" && head -20 pyproject.toml
[ -f requirements.txt ] && echo "pip"
[ -f Pipfile ] && echo "pipenv"

# Go
[ -f go.mod ] && echo "Go" && head -20 go.mod

# Rust
[ -f Cargo.toml ] && echo "Rust" && head -20 Cargo.toml

# Java/Kotlin
[ -f pom.xml ] && echo "Maven"
[ -f build.gradle ] && echo "Gradle"

# Ruby
[ -f Gemfile ] && echo "Ruby/Rails"

# Detect package manager version
npm -v 2>/dev/null || pnpm -v 2>/dev/null || yarn -v 2>/dev/null || python --version
```

**What to infer:**
- Primary language and version
- Package manager (npm, yarn, pnpm, pip, cargo, go get)
- Monorepo tooling (Turborepo, Nx, lerna, pnpm workspaces)

### C. Detect Build Tools

```bash
# Frontend
[ -f webpack.config.js ] && echo "webpack"
[ -f vite.config.ts ] && echo "vite"
[ -f tsconfig.json ] && echo "TypeScript"
[ -f next.config.js ] && echo "Next.js"
[ -f nuxt.config.ts ] && echo "Nuxt"
[ -f astro.config.mjs ] && echo "Astro"

# Other
grep -l "esbuild\|turbopack\|swc" package.json 2>/dev/null
```

**What to infer:**
- Build strategy (bundled vs unbundled, edge compute?)
- Framework (React, Vue, Next.js, etc.)
- Compilation needs (TypeScript, Babel, SWC)

### D. Detect Testing Setup

```bash
# Find test files and frameworks
find . -name "*.test.ts" -o -name "*.test.js" -o -name "*.spec.ts" | head -5
find . -name "*.py.test" -o -name "test_*.py" | head -5
find . -name "*_test.go" | head -5

# Check config files
ls -la | grep -E "jest|vitest|pytest|karma|mocha|rspec"
[ -f jest.config.js ] && echo "jest" && head -10 jest.config.js
[ -f vitest.config.ts ] && echo "vitest" && head -10 vitest.config.ts
[ -f pytest.ini ] && echo "pytest"

# Check test scripts in package.json
grep -A 5 '"test"' package.json 2>/dev/null
```

**What to infer:**
- Testing frameworks (jest, vitest, pytest, rspec)
- Test organization (colocated, separate test directory)
- Test scope (unit, integration, E2E, coverage target)
- Testing rigor

### E. Detect Linting & Formatting

```bash
# Linting
[ -f .eslintrc.json ] && echo "eslint"
[ -f .eslintrc.js ] && echo "eslint"
[ -f .pylintrc ] && echo "pylint"
[ -f .flake8 ] && echo "flake8"
[ -f clippy.toml ] && echo "clippy"

# Formatting
[ -f .prettierrc ] && echo "prettier"
[ -f .prettierrc.json ] && head -10 .prettierrc.json
[ -f pyproject.toml ] && grep -A 5 '\[tool.black\]' pyproject.toml
[ -f .rustfmt.toml ] && echo "rustfmt"

# Check package.json
grep -E "eslint|prettier|black|clippy" package.json 2>/dev/null
```

**What to infer:**
- Code style enforcement
- Formatting requirements
- Naming conventions (camelCase, snake_case, PascalCase)

### F. Detect CI/CD & Deployment

```bash
# GitHub Actions
ls -la .github/workflows/ 2>/dev/null | head -10
ls .github/workflows/*.yml | xargs -I {} sh -c 'echo "=== {} ===" && head -20 {}'

# Other CI
[ -f .gitlab-ci.yml ] && echo "GitLab CI"
[ -f cloudbuild.yaml ] && echo "Google Cloud Build"
[ -f .circleci/config.yml ] && echo "CircleCI"
[ -f bitbucket-pipelines.yml ] && echo "Bitbucket Pipelines"

# Deployment
[ -f vercel.json ] && echo "Vercel" && head -20 vercel.json
[ -f netlify.toml ] && echo "Netlify"
[ -f docker-compose.yml ] && echo "Docker Compose"
[ -f Dockerfile ] && echo "Docker"
[ -f fly.toml ] && echo "Fly.io"

# Check environment files
find . -name ".env.example" -o -name ".env.local" 2>/dev/null
```

**What to infer:**
- Deployment target (Vercel, Netlify, Lambda, K8s, traditional server)
- CI/CD platform
- Required environment variables
- Secrets management approach

### G. Detect Architecture & Project Structure

```bash
# Directory tree (first 2 levels)
tree -L 2 -I 'node_modules|.next|dist|build' . 2>/dev/null || find . -maxdepth 2 -type d | head -30

# Check for monorepo indicators
ls -la | grep -E "apps/|packages/|services/"
[ -f pnpm-workspace.yaml ] && echo "=== Workspaces ===" && cat pnpm-workspace.yaml
[ -f nx.json ] && echo "=== Nx Config ===" && head -30 nx.json

# Check src structure
[ -d src ] && ls -la src/ | head -20
[ -d src/components ] && echo "Component-based" || echo "Not component-based"
[ -d src/features ] && echo "Feature-based"
[ -d src/pages ] && echo "Page-based (Next.js/Nuxt style)"
[ -d src/lib ] && echo "Library pattern"
```

**What to infer:**
- Monorepo boundaries and workspace structure
- Code organization (layer-based vs feature-based)
- Shared vs isolated code
- Project ownership (which team owns what)

### H. Detect Git Workflow

```bash
# Recent commits and messages
git log --pretty=format:"%h %s" | head -20

# Check branch names
git branch -a | head -20

# Check for protection rules or merge strategy
git config core.editor
git config pull.rebase

# Check for commit hooks
ls -la .husky/ 2>/dev/null || ls -la .git/hooks/ | grep -v sample

# Check for conventional commits
git log --pretty=format:"%s" | head -50 | grep -E "^(feat|fix|docs|refactor|test|chore)"
```

**What to infer:**
- Commit message convention (conventional commits? free-form?)
- Branch naming (main/develop? main only? trunk-based?)
- Code review requirement (does every commit need review?)
- Release process (tags? releases? semantic versioning?)

### I. Detect Security & Sensitive Concerns

```bash
# Check for auth patterns
grep -r "passport\|nextauth\|clerk\|auth0\|supabase" package.json 2>/dev/null | head -5
grep -r "django.contrib.auth\|flask-login" . 2>/dev/null | head -5

# Check for payment
grep -r "stripe\|square\|paypal" package.json 2>/dev/null

# Check for PII handling
find . -name "*.env.example" | xargs grep -E "API_KEY|SECRET|TOKEN|PASSWORD" 2>/dev/null

# Check for security configs
[ -f SECURITY.md ] && head -30 SECURITY.md
[ -f .snyk ] && echo "Snyk configured"
ls -la | grep -E ".dependabot|renovate"

# Check for secrets scanning
git config -l | grep -i secret
```

**What to infer:**
- Authentication approach
- Payment processing (if applicable)
- PII or sensitive data handling
- Security scanning tools
- Compliance requirements (SOC 2, HIPAA, PCI-DSS)

### J. Detect Design System & UI Patterns (if UI project)

```bash
# Design tokens
find . -name "tokens.json" -o -name "tokens.ts" -o -name "theme.ts" | head -5
grep -l "tailwindcss\|styled-components\|emotion" package.json 2>/dev/null

# Check CSS approach
[ -f tailwind.config.ts ] && echo "Tailwind CSS" && head -20 tailwind.config.ts
[ -f postcss.config.js ] && cat postcss.config.js
find . -name "*.css" | head -5 | xargs head -5 2>/dev/null | grep -E "@import|:root|--"

# Component library
[ -d src/components ] && ls src/components | head -20
grep -l "@storybook\|@radix-ui\|shadcn\|headlessui\|mantine" package.json 2>/dev/null

# Icon system
grep -l "lucide\|heroicons\|material-icons\|icomoon" package.json 2>/dev/null

# Theming
find . -name "*.stories.ts" -o -name "*.stories.tsx" | head -5
grep -r "dark mode\|theme.*provider" . --include="*.ts" --include="*.tsx" 2>/dev/null | head -3
```

**What to infer:**
- Design tokens strategy (CSS vars, Tailwind, Sass, theme object)
- Component library approach (custom, shadcn, Radix, etc.)
- Theming strategy (light/dark, multiple themes)
- Accessibility level (ARIA, a11y tests)

### K. Detect Existing Documentation & Context

```bash
# Core docs
ls -la ARCHITECTURE.md CONTRIBUTING.md DEVELOPMENT.md 2>/dev/null

# AI/agent guidance
ls -la .ai/ 2>/dev/null
ls -la .github/ 2>/dev/null | grep -E "INSTRUCTION|AGENT|AI"

# Team playbooks
find . -name "PLAYBOOK*.md" -o -name "*WORKFLOW*.md" 2>/dev/null

# ADRs (Architecture Decision Records)
find . -path "./decisions/*" -name "*.md" 2>/dev/null | head -10

# Comments in code suggesting conventions
grep -r "^//" . --include="*.ts" --include="*.tsx" 2>/dev/null | grep -i "convention\|always\|never\|pattern" | head -5
```

**What to infer:**
- Existing documentation quality and detail
- Team's documentation style
- Documented architectural decisions
- Any existing AI/agent guidance

## Output Format

Organize discoveries into this structure:

```markdown
## Discovery Summary

### Project Identity
- Name: [from README/package.json]
- Purpose: [stated goal]
- Type: [web app | API | library | CLI | monorepo | infrastructure]
- Maturity: [early | established | legacy | migrating]

### Tech Stack
- Languages: [primary, secondary]
- Package Manager: [npm/yarn/pnpm/pip/cargo/go.mod]
- Build Tool: [webpack/vite/esbuild/etc]
- Framework: [React/Vue/Django/FastAPI/etc]
- Database: [if detectable]
- Deployment: [Vercel/Netlify/Docker/K8s/AWS/etc]

### Testing
- Primary: [jest/vitest/pytest/etc]
- Secondary: [if multiple]
- Organization: [colocated | separate]
- Scope: [unit | integration | E2E]
- Coverage: [target if specified]

### Code Style
- Linter: [eslint/pylint/clippy/etc]
- Formatter: [prettier/black/rustfmt/etc]
- Convention: [camelCase | snake_case | PascalCase]
- Comments: [sparse | moderate | detailed]

### Architecture
- Monorepo: [pnpm | Nx | Turborepo | single]
- Structure: [feature-based | layer-based | domain-driven]
- Ownership: [monolithic | modular | microservices]
- Patterns: [list any obvious patterns]

### Git Workflow
- Branch Convention: [main/develop | main only | feature branches]
- Commit Style: [conventional commits | free-form]
- Code Review: [required | optional | PR culture]
- Merge Strategy: [squash | rebase | merge commits]

### Security & Compliance
- Auth: [none | passport | nextauth | clerk | other]
- Payments: [none | stripe | other]
- PII Handling: [none detected | yes]
- Security Tools: [snyk | dependabot | renovate]
- Compliance: [HIPAA | SOC 2 | GDPR | none detected]

### Design System (if UI)
- Tokens: [CSS vars | Tailwind | Sass | theme object]
- Components: [custom | shadcn | Radix | Material]
- Icons: [lucide | heroicons | material | other]
- Theming: [light/dark | multiple | none]
- Accessibility: [tested | comments | unknown]

### Existing Documentation
- README: [quality level]
- ARCHITECTURE.md: [exists | missing]
- CONTRIBUTING.md: [exists | missing]
- AI/Agent Guidance: [exists | missing]
- Decisions: [ADRs present | none]

### Ambiguities Detected
- [List each decision point that's unclear]
```

## When to Ask Questions

After discovery, if the agent found ambiguity, move to `question.md`.

Ambiguities include:
- **Multiple competing tools** (both Jest and Vitest configured)
- **Unclear conventions** (inconsistent naming patterns)
- **Missing guidance** (no CONTRIBUTING.md)
- **Conflicting evidence** (old and new patterns coexist)
- **Team preferences unstated** (code review not documented)

Do not ask questions about:
- Obviously canonical choices (only one test framework configured)
- Language-specific conventions (TypeScript uses PascalCase for types)
- Universal best practices (Git hygiene, commit message clarity)
