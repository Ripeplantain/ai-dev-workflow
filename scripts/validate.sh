#!/usr/bin/env bash
# Validates an agent-workflow install. Read-only.
#
#   validate.sh [repo-root] [workflow-dir]   full validation (workflow-dir defaults to .claude)
#   validate.sh --links <dir>                only check relative Markdown links under <dir>
#
# Exit 0 = no errors (warnings allowed), 1 = errors.
# Portable to macOS bash 3.2: no associative arrays, no mapfile, no ${var,,}.

set -u

E=0; W=0
err()  { echo "ERROR: $*"; E=$((E+1)); }
warn() { echo "WARN:  $*"; W=$((W+1)); }
ok()   { echo "ok:    $*"; }

# True only if the path exists with exactly this case. Plain -f lies on
# case-insensitive filesystems, which is how lowercase claude.md ships to Linux CI.
exists_exact() {
  ls -1 "$(dirname "$1")" 2>/dev/null | grep -qx "$(basename "$1")"
}

# Reports relative Markdown links under $1 whose target does not exist.
# $2, if given, is a -path pattern to skip.
check_links() {
  local file dir target skip
  skip="${2:-}"
  while IFS= read -r file; do
    dir=$(dirname "$file")
    while IFS= read -r target; do
      target=${target%% *}
      target=${target%%#*}
      case "$target" in
        '' | http://* | https://* | mailto:* | '#'* | *'{{'* | *'<'* ) continue ;;
      esac
      [ -e "$dir/$target" ] || err "$file: broken link -> $target"
    done < <(grep -o '\]([^)]*)' "$file" 2>/dev/null | sed -e 's/^](//' -e 's/)$//')
  done < <(
    if [ -n "$skip" ]; then
      find "$1" -type f -name '*.md' -not -path '*/.git/*' -not -path "$skip"
    else
      find "$1" -type f -name '*.md' -not -path '*/.git/*'
    fi
  )
}

finish() {
  echo "errors: $E warnings: $W"
  [ "$E" -eq 0 ]
}

if [ "${1:-}" = "--links" ]; then
  [ -d "${2:-}" ] || { echo "usage: $0 --links <dir>" >&2; exit 2; }
  check_links "$2"
  finish
  exit $?
fi

ROOT="${1:-.}"
cd "$ROOT" 2>/dev/null || { echo "error: cannot cd to $ROOT"; exit 1; }

AG="${2:-.claude}"
AG="${AG%/}"
# $AG as a literal in a regular expression.
AG_RE=$(printf '%s' "$AG" | sed 's/[][\\.*^$/]/\\&/g')
# A workflow adopted under another name keeps its own layout, so structure is advisory.
structure() { if [ "$AG" = ".claude" ]; then err "$1"; else warn "$1"; fi; }

# Claude Code's own files under .claude/ are not part of the workflow.
INSTALLED="./$AG/skills/*"

# --- entry file, exact case ---
if exists_exact ./CLAUDE.md; then ok "CLAUDE.md present"; else err "CLAUDE.md missing (exact case)"; fi
for f in $(ls -a 2>/dev/null | grep -i -E '^(agents|claude)\.md$' | grep -v -x -E 'AGENTS\.md|CLAUDE\.md'); do
  err "wrong-case file: $f (works on macOS, breaks on Linux CI)"
done
if grep -q "$AG_RE/" CLAUDE.md 2>/dev/null; then ok "CLAUDE.md routes into $AG/"
else err "CLAUDE.md does not reference $AG/"; fi

# A v2 CLAUDE.md was the single line @AGENTS.md. v3 makes CLAUDE.md canonical.
first=$(grep -v '^[[:space:]]*$' CLAUDE.md 2>/dev/null | head -1)
[ "$first" = "@AGENTS.md" ] && err "CLAUDE.md is still a v2 @AGENTS.md pointer (workflows/update.md section 4)"

# AGENTS.md is content to fold in, never a second canonical file.
if exists_exact ./AGENTS.md; then
  if grep -q "$AG_RE/" AGENTS.md 2>/dev/null; then
    warn "AGENTS.md also routes into $AG/ (two files claiming to be canonical; see workflows/update.md section 4)"
  else
    ok "AGENTS.md present, not claiming canonical"
  fi
fi

# Gitignoring .claude/ wholesale means the workflow never reaches the team.
if [ -f .gitignore ] && grep -Eq "^[[:space:]]*/?$AG_RE/?[[:space:]]*$" .gitignore; then
  warn "$AG/ is gitignored; the workflow will not reach anyone else"
fi

# --- workflow dir ---
[ -d "$AG" ] || { err "$AG/ missing"; finish; exit $?; }
for d in .agent .agents .ai .agent-workflow docs/ai; do  # pre-v3 and legacy layouts
  [ "$d" = "$AG" ] && continue
  [ -d "$d" ] || continue
  if [ -n "$(find "$d" -type f -name '*.md' -not -path '*/skills/*' -print 2>/dev/null | head -1)" ]; then
    err "second workflow dir: $d exists alongside $AG/ (one workflow dir only; migrate it per workflows/update.md section 4)"
  fi
done

if exists_exact "./$AG/PROJECT.md"; then
  ok "PROJECT.md present"
  grep -Eq '^version: agent-workflow [0-9]+\.[0-9]+\.[0-9]+' "$AG/PROJECT.md" \
    && ok "version stamp" \
    || err "PROJECT.md has no 'version: agent-workflow X.Y.Z' stamp"
  n=$(wc -l < "$AG/PROJECT.md" | tr -d ' ')
  [ "$n" -le 120 ] && ok "PROJECT.md $n lines" || warn "PROJECT.md is $n lines (budget 120)"
else
  structure "$AG/PROJECT.md missing"
fi

[ -f "$AG/rules/checkpoints.md" ] && ok "checkpoints.md present" || err "$AG/rules/checkpoints.md missing"
[ -f "$AG/rules/repo-sanity.md" ] || warn "$AG/rules/repo-sanity.md missing (written on every install)"
[ -f "$AG/WORKFLOW.md" ] || [ -d "$AG/workflows" ] \
  || structure "$AG/ has no task workflow (workflows/, or WORKFLOW.md on a legacy small project)"

# --- roles ---
roles=$(ls "$AG"/agents/*.md 2>/dev/null | xargs -n1 basename 2>/dev/null | sed 's/\.md$//')
nr=$(echo "$roles" | grep -c . )
if [ "$nr" -eq 0 ]; then
  structure "$AG/agents/ has no role docs"
elif [ "$nr" -lt 4 ] || [ "$nr" -gt 6 ]; then
  warn "$nr roles (budget 4-6): $(echo $roles)"
else
  ok "$nr roles: $(echo $roles)"
fi
for r in $roles; do
  case "$r" in
    planner|implementer|tester|reviewer|investigator|data-engineer|evaluator) ;;
    *) warn "non-standard role name: $r (roles describe work, not technology)";;
  esac
  f="$AG/agents/$r.md"
  # These files ARE the subagents Claude Code dispatches, so the frontmatter
  # has to be the frontmatter Claude Code reads.
  head -1 "$f" | grep -q '^---$' || { err "$f missing YAML frontmatter"; continue; }
  grep -Eq '^name:[[:space:]]*'"$r"'[[:space:]]*$' "$f" \
    || err "$f needs 'name: $r' (must match the filename stem)"
  grep -Eq '^description:[[:space:]]*\S' "$f" \
    || err "$f frontmatter needs a description (it is the dispatch trigger)"
  grep -Eq '^model:[[:space:]]*(opus|sonnet|haiku|fable|inherit|claude-)' "$f" \
    || warn "$f has no recognised model: (strong -> opus, default -> sonnet, cheap -> haiku)"
  grep -Eq '^tier:' "$f" \
    && err "$f still carries a v2 'tier:' field (workflows/update.md section 4)"
  # Read-only roles must enforce it with a field, not only with a rules file.
  if grep -Eq '^tools:' "$f" && ! grep -Eq '^disallowedTools:.*Write' "$f"; then
    warn "$f restricts tools but not disallowedTools; Bash is a write vector"
  fi
done

# --- subagents that do not read the workflow ---
# An installed role doc always points at PROJECT.md and the checkpoints. One that
# points at neither is either somebody else's subagent (leave it alone) or a role
# doc that will run without the project's rules.
for f in "$AG"/agents/*.md; do
  [ -e "$f" ] || continue
  grep -q "$AG_RE/" "$f" \
    || warn "$f never references $AG/ (not an installed role, or it runs without the project rules)"
done

# --- per-file checks across everything generated ---
files=""
[ -f CLAUDE.md ] && files="CLAUDE.md"
# Everything under the workflow dir except Claude Code's own territory.
gen=$(find "$AG" -type f 2>/dev/null \
  | grep -v "^$AG/skills/" | grep -v "^$AG/commands/" | grep -v "^$AG/hooks/" \
  | grep -v "^$AG/settings" )
files="$files $gen"

total=0
for f in $files; do
  [ -f "$f" ] || continue
  total=$((total+1))

  [ -s "$f" ] || { err "$f is empty"; continue; }

  while IFS= read -r hit; do
    [ -n "$hit" ] && err "$f:$hit  (unresolved placeholder or installer note)"
  done < <(grep -n -e '{{' -e 'INSTALLER:' "$f" 2>/dev/null | cut -c1-120)

  while IFS= read -r hit; do
    [ -n "$hit" ] && warn "$f:$hit  (TBD to fill on the next update run)"
  done < <(grep -n 'TBD:' "$f" 2>/dev/null | cut -c1-120)

  # Attribution trailers. The checkpoints and repo-sanity rules legitimately name
  # these in order to forbid them, so match trailer-shaped lines only and skip
  # the two files whose job is to quote them.
  case "$f" in
    */rules/checkpoints.md|*/rules/repo-sanity.md) ;;
    *)
      while IFS= read -r hit; do
        [ -n "$hit" ] && err "$f:$hit  (attribution trailer)"
      done < <(grep -n -i -E '^[[:space:]]*(co-authored-by|signed-off-by|assisted-by):|generated with \[?(claude|codex)' "$f" 2>/dev/null | cut -c1-120)
      ;;
  esac

  # Backticked workflow-dir paths must exist in the target repo.
  while IFS= read -r path; do
    case "$path" in *'*'* | *'<'* | *'{'* ) continue ;; esac
    [ -e "$path" ] || err "$f: references missing file $path"
  done < <(grep -o "\`$AG_RE/[^\` ]*\`" "$f" 2>/dev/null | tr -d '`' | sed 's/[.,:;]*$//' | sort -u)

  case "$f" in
    */PROJECT.md) ;;
    *)
      lines=$(wc -l < "$f" | tr -d ' ')
      [ "$lines" -gt 80 ] && warn "$f is $lines lines (budget 80 for generated files)"
      ;;
  esac
done

check_links "$AG" "$INSTALLED"

[ "$total" -le 20 ] && ok "$total workflow files" || warn "$total workflow files (budget ~20)"

finish
