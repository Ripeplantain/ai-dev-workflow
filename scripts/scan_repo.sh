#!/usr/bin/env bash
# Read-only evidence scan for agent-workflow. Prints `key: value` lines.
# Portable to macOS bash 3.2 (no associative arrays, no mapfile).
# Usage: scan_repo.sh [repo-root]

ROOT="${1:-.}"
cd "$ROOT" 2>/dev/null || { echo "error: cannot cd to $ROOT"; exit 1; }

PRUNE='-name node_modules -o -name .git -o -name .venv -o -name venv -o -name dist -o -name build -o -name .next -o -name .nuxt -o -name .output -o -name __pycache__ -o -name .turbo -o -name coverage'

ffind() { # ffind <maxdepth> <find-args...>
  local d="$1"; shift
  eval "find . -maxdepth $d \( $PRUNE \) -prune -o \( $* \) -print" 2>/dev/null | sed 's|^\./||' | sort
}
join_lines() { tr '\n' ' ' | sed 's/ *$//'; }
has() { [ -e "$1" ]; }
grep_manifests() { # grep_manifests <regex> → prints matching manifest files
  ffind 4 "-name package.json -o -name pyproject.toml -o -name 'requirements*.txt' -o -name Pipfile" \
    | while read -r f; do grep -Eqi "$1" "$f" 2>/dev/null && echo "$f"; done
}

echo "repo: $(basename "$(pwd)")"
echo "root: $(pwd)"
echo "file_count: $(ffind 8 '-type f' | wc -l | tr -d ' ')"

# --- git ---
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "git: yes"
  echo "git_branch: $(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)$(git rev-parse -q --verify HEAD >/dev/null 2>&1 || echo ' (no commits yet)')"
  echo "git_commits: $(git rev-list --count HEAD 2>/dev/null || echo 0)"
  echo "git_last_commit: $(git log -1 --format='%h %ar %s' 2>/dev/null)"
  echo "git_dirty_count: $(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')"
  echo "git_untracked_count: $(git status --porcelain 2>/dev/null | grep -c '^??')"
  echo "git_stashes: $(git stash list 2>/dev/null | wc -l | tr -d ' ')"
  up=$(git rev-parse --abbrev-ref '@{u}' 2>/dev/null)
  if [ -n "$up" ]; then
    echo "git_upstream: $up ($(git rev-list --left-right --count "$up"...HEAD 2>/dev/null | awk '{print "behind "$1", ahead "$2}'))"
  else
    echo "git_upstream: none"
  fi
  echo "git_branch_patterns: $(git branch -a --format='%(refname:short)' 2>/dev/null | sed 's|^origin/||' | grep -Eo '^[a-zA-Z_-]+/' | sort | uniq -c | sort -rn | awk '{print $2"("$1")"}' | head -6 | join_lines)"
else
  echo "git: no"
fi

# --- package managers & lockfiles ---
locks=$(ffind 2 "-name pnpm-lock.yaml -o -name package-lock.json -o -name yarn.lock -o -name bun.lockb -o -name bun.lock -o -name deno.lock -o -name poetry.lock -o -name uv.lock -o -name Pipfile.lock")
echo "lockfiles: $(echo "$locks" | join_lines)"
root_js_locks=$(echo "$locks" | grep -Ev '/' | grep -Ev 'poetry|uv\.lock|Pipfile' | grep -c .)
echo "lockfile_drift: $([ "$root_js_locks" -gt 1 ] && echo "yes ($root_js_locks JS lockfiles at root)" || echo no)"
if has package.json; then
  pm=$(grep -Eo '"packageManager"[[:space:]]*:[[:space:]]*"[^"]+"' package.json | sed 's/.*"\([^"]*\)"$/\1/')
  echo "package_manager_pinned: ${pm:-none}"
  echo "workspaces: $( (has pnpm-workspace.yaml && echo pnpm-workspace.yaml) ; grep -q '"workspaces"' package.json && echo package.json:workspaces ) " | sed 's/ *$//'
  # scripts block, names only
  if command -v node >/dev/null 2>&1; then
    scripts=$(node -e 'try{const s=require("./package.json").scripts||{};console.log(Object.entries(s).map(([k,v])=>k+"="+JSON.stringify(v)).join(" | "))}catch(e){}')
  elif command -v python3 >/dev/null 2>&1; then
    scripts=$(python3 -c 'import json;s=json.load(open("package.json")).get("scripts",{});print(" | ".join(k+"="+json.dumps(v) for k,v in s.items()))' 2>/dev/null)
  else
    scripts=$(tr ',{}' '\n\n\n' < package.json | grep -Eo '"[a-z:_-]+"[[:space:]]*:[[:space:]]*"[^"]*"' | join_lines)
  fi
  echo "npm_scripts: $scripts"
fi
has Makefile && echo "make_targets: $(grep -Eo '^[a-zA-Z0-9_.-]+:' Makefile | tr -d ':' | sort -u | join_lines)"

# --- stack signals ---
stack=""
add() { stack="$stack $1"; }
[ -n "$(grep_manifests '"nuxt"')" ] && add nuxt
[ -n "$(grep_manifests '"next"')" ] && add next
[ -n "$(grep_manifests '"vite"')" ] && add vite
[ -n "$(grep_manifests '"react"')" ] && add react
[ -n "$(grep_manifests '"vue"')" ] && add vue
[ -n "$(grep_manifests '"express"|"hono"|"fastify"')" ] && add node-server
[ -n "$(grep_manifests '"drizzle-orm"')" ] && add drizzle
[ -n "$(grep_manifests '"prisma"|"@prisma/client"')" ] && add prisma
[ -n "$(grep_manifests '"zod"')" ] && add zod
[ -n "$(grep_manifests '"@supabase/')" ] && add supabase
[ -n "$(grep_manifests '"vitest"')" ] && add vitest
[ -n "$(grep_manifests '"jest"')" ] && add jest
[ -n "$(grep_manifests '"@playwright/test"|"playwright"')" ] && add playwright
[ -n "$(grep_manifests '"@biomejs/biome"')" ] && add biome
[ -n "$(grep_manifests '"eslint"')" ] && add eslint
[ -n "$(grep_manifests '"tailwindcss"')" ] && add tailwind
[ -n "$(ffind 3 "-name tsconfig.json")" ] && add typescript
[ -n "$(ffind 3 "-name pyproject.toml -o -name 'requirements*.txt' -o -name setup.py -o -name Pipfile")" ] && add python
[ -n "$(grep_manifests 'pytest')" ] && add pytest
[ -n "$(ffind 3 "-name go.mod")" ] && add go
[ -n "$(ffind 3 "-name Cargo.toml")" ] && add rust
[ -n "$(ffind 2 "-name 'docker-compose*.yml' -o -name 'docker-compose*.yaml' -o -name 'compose*.yml' -o -name Dockerfile")" ] && add docker
echo "stack:$stack"

# --- CI & quality gates ---
ci=""
[ -d .github/workflows ] && ci="$ci github-actions($(ls .github/workflows | join_lines))"
[ -n "$(ffind 2 "-name 'azure-pipelines*.yml' -o -name 'azure-pipelines*.yaml'")" ] && ci="$ci azure-pipelines"
has .gitlab-ci.yml && ci="$ci gitlab-ci"
has netlify.toml && ci="$ci netlify"
has vercel.json && ci="$ci vercel"
echo "ci:${ci:- none}"
[ -n "$(ffind 2 "-name sonar-project.properties")" ] && echo "quality_gate: sonar"

# --- data / AI signals ---
ai=$(grep_manifests '"ai"[[:space:]]*:|"@ai-sdk/|"openai"|"@anthropic-ai/|"@openrouter/|openrouter|"langchain|"@langchain/|"llamaindex|^openai|^anthropic|litellm' | join_lines)
aidirs=$(ffind 4 "-type d \( -name prompts -o -name evals -o -name ai -o -name llm \)" | join_lines)
promptfiles=$(ffind 5 "-name 'prompt*.ts' -o -name 'prompt*.py' -o -name 'PROMPT*.md' -o -name '*.prompt.md'" | head -8 | join_lines)
[ -n "$ai$aidirs$promptfiles" ] && echo "ai_signals: manifests[$ai] dirs[$aidirs] prompt_files[$promptfiles]" || echo "ai_signals: none"
data=$(grep_manifests 'pandas|polars|pyarrow|apache-airflow|dagster|prefect|dbt-|duckdb|openpyxl' | join_lines)
datafiles=$(ffind 5 "-name 'ingest*.py' -o -name 'transform*.py' -o -name 'validate*.py' -o -name 'contract*.py' -o -name '*_dag.py' -o -name 'dags' -o -name '*.ipynb'" | head -10 | join_lines)
datadirs=$(ffind 2 "-type d \( -name data -o -name raw -o -name dags -o -name pipelines \)" | join_lines)
[ -n "$data$datafiles$datadirs" ] && echo "data_signals: manifests[$data] files[$datafiles] dirs[$datadirs]" || echo "data_signals: none"

# --- existing agent files ---
agentfiles=$(ffind 4 "-iname agents.md -o -iname claude.md -o -iname gemini.md -o -name .cursorrules -o -name copilot-instructions.md" | join_lines)
echo "agent_files: ${agentfiles:-none}"
[ -d .agent ] && echo "agent_dir: .agent ($(find .agent -type f | wc -l | tr -d ' ') files; version: $(grep -m1 -Eo 'agent-workflow [0-9][0-9.]*' .agent/PROJECT.md 2>/dev/null | awk '{print $2}' || true))" || echo "agent_dir: none"
for d in .claude/agents .codex/agents .cursor/rules; do [ -d "$d" ] && echo "adapter_dir: $d ($(ls "$d" | wc -l | tr -d ' '))"; done
[ -d .claude ] && echo "tool_seen: claude-code"
[ -d .codex ] && echo "tool_seen: codex"
has CLAUDE.md && echo "claude_md_is_pointer: $(grep -v '^[[:space:]]*$' CLAUDE.md | head -1 | grep -q '^@AGENTS.md' && echo yes || echo no)"

# --- specs & docs ---
echo "specs: $(ffind 3 "-path './docs' -o -path '*/adr' -o -path '*/adrs' -o -name 'PROMPT*.md' -o -name 'SPEC*.md' -o -path './prompts'" | join_lines)"

# --- invariant hints (grep, names only) ---
hints=""
for p in withTenantContext tenant_id requireAdmin requireAuth row_level_security 'ENABLE ROW LEVEL SECURITY' minorUnits ALLOWED_RANGES; do
  n=$(grep -rIl --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=dist --exclude-dir=.next --exclude-dir=.nuxt "$p" . 2>/dev/null | wc -l | tr -d ' ')
  [ "$n" -gt 0 ] && hints="$hints $p($n)"
done
echo "invariant_hints:${hints:- none}"

# --- hygiene ---
wrongcase=$(ffind 4 "\( -iname agents.md -a ! -name AGENTS.md \) -o \( -iname claude.md -a ! -name CLAUDE.md \)" | join_lines)
echo "wrong_case_files: ${wrongcase:-none}"
parallel=$(ffind 5 "-type f \( -name '*-v2.*' -o -name '*-new.*' -o -name '*-old.*' -o -name '*copy*.*' -o -name '*.bak' \)" | head -10 | join_lines)
echo "parallel_copies: ${parallel:-none}"
envs=$(ffind 3 "-name '.env*' ! -name '.env.example' ! -name '.env.sample'" | join_lines)
if [ -n "$envs" ] && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  tracked=""
  for e in $envs; do git ls-files --error-unmatch "$e" >/dev/null 2>&1 && tracked="$tracked $e"; done
  echo "env_files: $envs (contents not read)"
  [ -n "$tracked" ] && echo "env_files_tracked_in_git:$tracked"
fi
has .env.example && echo "env_example: yes"
exit 0
