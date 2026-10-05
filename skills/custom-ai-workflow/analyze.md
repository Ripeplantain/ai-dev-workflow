# Step 2: Analyze & Classify

Transform raw discoveries into structured project context and classification.

## Analysis Framework

Take the discovery output and categorize it into these dimensions:

### A. Project Type Classification

Map discovery findings to project category:

| Finding | → | Type | Properties |
| --- | --- | --- | --- |
| `package.json` + `src/` + `src/pages/` | → | **Web App** | Browser-first, UI, routing, state management |
| `package.json` + `src/api/` + REST endpoints | → | **API/Backend** | Server-first, database, authentication |
| `package.json` + exports in `package.json` | → | **Library/Package** | No entry point, consumed by others |
| `package.json` + `bin/` or `#!/usr/bin/env node` | → | **CLI Tool** | Command-line interface |
| `pnpm-workspace.yaml` OR `nx.json` OR `lerna.json` | → | **Monorepo** | Multiple packages/apps, shared tooling |
| `main.go` + `cmd/` + REST/gRPC | → | **Go API/Service** | Compiled, concurrent, cloud-native |
| `Cargo.toml` + `src/bin/` | → | **Rust CLI** | High-performance, memory-safe |
| `Cargo.toml` + `src/lib.rs` | → | **Rust Library** | Low-level, systems code |
| `Dockerfile` + `kubernetes/` | → | **Infrastructure** | Deployment, orchestration, operations |
| `main.py` + `requirements.txt` | → | **Python App** | Data science, scripts, services |
| `Gemfile` + `config/routes.rb` | → | **Ruby on Rails** | Web framework, convention-heavy |
| `pom.xml` OR `build.gradle` | → | **Java/Kotlin** | Enterprise, compiled, Maven/Gradle |

**Selection logic:**
1. Start with package manager (tells you language family)
2. Look at entry points (`main.go`, `src/pages/`, `bin/`, etc.)
3. Check framework presence (Next.js? Gin? Rails? FastAPI?)
4. Check deployment artifacts (Docker? Kubernetes? Vercel config?)
5. Infer type from combination

### B. Tech Stack Profile

Normalize discoveries into a standard profile:

```javascript
{
  "language": "TypeScript",               // primary language
  "languages": ["TypeScript", "CSS"],     // all languages
  "packageManager": "pnpm",               // npm, yarn, pnpm, pip, cargo, go, maven
  "framework": "Next.js",                 // React, Vue, Django, FastAPI, Gin, Rocket, etc.
  "buildTool": "Turbopack",               // Webpack, Vite, esbuild, Turbo, Cargo, Maven
  "testing": {
    "primary": "Jest",                    // main framework
    "secondary": ["Vitest"],              // other frameworks present
    "approach": "unit-and-integration"    // unit, integration, e2e, all
  },
  "styling": "Tailwind CSS",              // CSS framework or approach
  "database": "PostgreSQL",               // if detected
  "deployment": "Vercel",                 // cloud provider
  "ci": "GitHub Actions",                 // CI/CD platform
  "monorepo": "pnpm-workspaces"           // Turborepo, Nx, lerna, pnpm, or null
}
```

### C. Repo Maturity Assessment

Rank maturity on this scale:

| Level | Characteristics | Ceremony |
| --- | --- | --- |
| **Early** | <1 year old, <5 team members, loose conventions, experimental tech, no CONTRIBUTING.md | L0-L1 only, ask lots of questions |
| **Established** | 1-3 years old, 5-20 team members, documented patterns, stable stack, CONTRIBUTING.md exists | L0-L2 without planning, L2+ with planning |
| **Mature** | 3+ years old, 20+ team members, strict conventions, stable, comprehensive docs, ADRs | All levels, formal process |
| **Legacy** | 5+ years old, technical debt, migration happening, old frameworks | Extra caution, verify all assumptions |

**Signals:**
- `README.md` quality and length
- Presence of `CONTRIBUTING.md`, `ARCHITECTURE.md`, decision records
- Git history (how long? activity frequency?)
- Code comments and documentation
- Test coverage
- Linter/formatter rigor

### D. Team Context Inference

Estimate team size and roles:

| Signal | → | Inference |
| --- | --- | --- |
| Single person committing, no code review | → | **Solo developer** → Minimal ceremony |
| 2-5 people, some PRs, loose review | → | **Small team** → Light ceremony |
| 5-20 people, required reviews, branching strategy | → | **Medium team** → Formal process |
| 20+ commits/day, strong conventions, strict reviews | → | **Large org** → Heavy ceremony |
| Multiple `CODEOWNERS` files or permission groups | → | **Distributed ownership** → Per-path rules |

### E. Special Concerns Extraction

Flag domains that require extra attention:

```javascript
{
  "concerns": {
    "authentication": true,        // Found auth0/nextauth/passport
    "payments": true,              // Found stripe/square
    "pii": true,                   // Database has user data
    "realtime": true,              // WebSocket/Socket.io presence
    "accessibility": false,        // No a11y tests found
    "performance": true,           // Edge compute or performance monitoring
    "security": true,              // Security tools or encryption
    "compliance": ["GDPR", "SOC2"] // Detected from docs
  }
}
```

Each concern triggers loading additional rules:
- **Authentication** → load `rules/security.md`, ask about token strategy
- **Payments** → load `rules/security.md`, ask about PCI compliance
- **PII** → load `rules/security.md`, ask about data retention
- **Real-time** → ask about concurrency handling
- **Accessibility** → load `rules/design-system.md`
- **Performance** → ask about optimization strategy
- **Compliance** → ask about audit requirements

### F. Design System Assessment (if UI project)

Analyze visual conventions:

```javascript
{
  "hasDesignSystem": true,
  "tokens": {
    "format": "tailwind.config.ts",  // CSS vars, Tailwind, Sass, theme object
    "coverage": "comprehensive"       // complete, partial, missing
  },
  "components": {
    "pattern": "custom",              // custom, shadcn, Radix, Material, Storybook
    "organization": "src/components/", // where they live
    "quality": "high"                 // high, medium, low
  },
  "theming": {
    "strategy": "light-dark",         // light-dark, multiple, context-based
    "provider": "ThemeProvider"       // where it's configured
  },
  "accessibility": {
    "tested": false,
    "ariaAnnotations": true,
    "keyboardNavigation": true
  }
}
```

### G. Architecture Pattern Recognition

Identify structural patterns:

```javascript
{
  "pattern": "feature-based",         // layer-based, feature-based, domain-driven
  "structure": {
    "src/": {
      "components/": "shared components",
      "features/": "feature bundles",
      "lib/": "utilities",
      "services/": "external integrations"
    }
  },
  "monorepo": {
    "type": "pnpm-workspaces",
    "workspaces": [
      { "name": "web", "path": "apps/web", "type": "app" },
      { "name": "api", "path": "apps/api", "type": "app" },
      { "name": "ui", "path": "packages/ui", "type": "library" }
    ],
    "dependencyDirection": "web → ui, api → ui, ui → none"
  }
}
```

## Output Structure

Generate an **Analysis Report**:

```markdown
# Project Analysis

## Classification

**Type**: [Web App | API | Library | CLI | Monorepo | Infrastructure]  
**Maturity**: [Early | Established | Mature | Legacy]  
**Team Size**: [Solo | Small (2-5) | Medium (5-20) | Large (20+)]  
**Age**: [X months/years based on git history]

## Tech Stack

**Primary Language**: [detected from files]  
**Framework**: [Next.js | Django | Gin | Rocket | etc.]  
**Package Manager**: [npm | pnpm | pip | cargo | go | maven]  
**Build Tool**: [Vite | webpack | Turbopack | esbuild | etc.]  
**Testing**: [Jest, Vitest | pytest | Go testing | Cargo test]  
**Deployment**: [Vercel | AWS | Docker | K8s | etc.]  
**Database**: [PostgreSQL | MongoDB | None detected]

## Special Concerns

- **Authentication**: [none | built-in | NextAuth | Clerk | Auth0 | Passport | etc.]
- **Payments**: [none | Stripe | Square | etc.]
- **PII Handling**: [yes | no]
- **Real-time**: [yes | no]
- **Compliance**: [GDPR | SOC 2 | HIPAA | PCI-DSS]
- **Performance**: [critical | important | standard]

## Architecture

**Pattern**: [feature-based | layer-based | domain-driven | custom]  
**Monorepo**: [pnpm workspaces | Turborepo | Nx | single project]  
**Ownership**: [monolithic | modular | microservices]

## Design System (if UI)

**Tokens**: [CSS custom properties | Tailwind | Sass variables | theme object]  
**Components**: [custom | shadcn | Radix UI | Material UI | other]  
**Theming**: [light/dark | multiple | context-based]  
**Accessibility**: [tested | documented | unknown]

## Code Quality Signals

**Documentation**: [comprehensive | adequate | sparse]  
**Linting**: [strict | moderate | lenient]  
**Testing**: [high coverage | moderate | low]  
**Git Hygiene**: [strong | adequate | weak]  
**Type Safety**: [strict | moderate | loose]

## Ambiguities Detected

[List items that need clarification via questions.md]

## Confidence Assessment

- **High confidence** (>90%): [List findings we're certain about]
- **Medium confidence** (70-90%): [List findings that seem right but could be wrong]
- **Low confidence** (<70%): [List items needing clarification]
```

## Decision Logic

Use this flow to move from discoveries → questions:

```
IF (ambiguities found) THEN
  → Load question.md
  → Ask about each ambiguity
  → User provides clarity
  → Update analysis
ELSE
  → Move to generate.md
  → Use discoveries + analysis to customize templates
```

**Examples of ambiguities requiring questions:**

1. **Multiple test frameworks**: "Both Jest and Vitest detected. Which is primary?"
2. **Conflicting docs**: "README says one pattern, code uses another. Which should agents follow?"
3. **Missing conventions**: "No CONTRIBUTING.md. Should agents follow [inferred pattern] or ask you?"
4. **Team uncertainty**: "Found loose commit messages. Is conventional commits planned?"
5. **Architecture changes**: "Old and new patterns coexist. Which should new code follow?"
6. **Performance constraints**: "Deployed to edge. Need to know optimization requirements."

## When Analysis is Complete

Once classified and ambiguities are noted, the skill is ready to:
1. Ask clarifying questions (question.md)
2. Generate customized files (generate.md)
3. Create commit message with assumptions
