#!/usr/bin/env bash
# Validates an agent-workflow install. Read-only.
#
#   validate.sh [repo-root] [workflow-dir]   full validation (workflow-dir defaults to .agent)
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
# case-insensitive filesystems, which is how lowercase agents.md ships to Linux CI.
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

AG="${2:-.agent}"
AG="${AG%/}"
# $AG as a literal in a regular expression.
AG_RE=$(printf '%s' "$AG" | sed 's/[][\\.*^$/]/\\&/g')
# A workflow adopted under another name keeps its own layout, so structure is advisory.
structure() { if [ "$AG" = ".agent" ]; then err "$1"; else warn "$1"; fi; }

# Skills installed by a tool are not part of the workflow.
INSTALLED="./$AG/skills/*/*"

# --- entry files, exact case ---
if exists_exact ./AGENTS.md; then ok "AGENTS.md present"; else err "AGENTS.md missing (exact case)"; fi
for f in $(ls -a 2>/dev/null | grep -i -E '^(agents|claude)\.md$' | grep -v -x -E 'AGENTS\.md|CLAUDE\.md'); do
  err "wrong-case file: $f (works on macOS, breaks on Linux CI)"
done
if exists_exact ./CLAUDE.md; then
  first=$(grep -v '^[[:space:]]*$' CLAUDE.md | head -1)
  if [ "$first" = "@AGENTS.md" ]; then ok "CLAUDE.md points at AGENTS.md"
  else err "CLAUDE.md first line must be @AGENTS.md (got: ${first:-empty})"; fi
else
  warn "no CLAUDE.md (fine if Claude Code is not used)"
fi
if grep -q "$AG_RE/" AGENTS.md 2>/dev/null; then ok "AGENTS.md routes into $AG/"
else err "AGENTS.md does not reference $AG/"; fi

# Something outside the workflow dir must point agents at it.
pointer=0
for entry in AGENTS.md CLAUDE.md GEMINI.md .cursorrules .windsurfrules \
             .github/copilot-instructions.md .cursor/rules; do
  if [ -e "$entry" ] && grep -rq "$AG_RE/" "$entry" 2>/dev/null; then pointer=1; break; fi
done
[ "$pointer" -eq 1 ] || warn "no agent entry file points to $AG/"

# --- workflow dir ---
[ -d "$AG" ] || { err "$AG/ missing"; finish; exit $?; }
for d in .agent .agents .ai .agent-workflow docs/ai; do
  [ "$d" = "$AG" ] && continue
  [ -d "$d" ] || continue
  if [ -n "$(find "$d" -type f -name '*.md' -not -path '*/skills/*' -print 2>/dev/null | head -1)" ]; then
    err "second workflow dir: $d exists alongside $AG/ (one workflow dir only)"
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
[ -f "$AG/rules/repo-sanity.md" ] || warn "$AG/rules/repo-sanity.md missing (written on every v2 install)"
[ -f "$AG/WORKFLOW.md" ] || [ -d "$AG/workflows" ] \
  || structure "$AG/ has no task workflow (workflows/ for v2, WORKFLOW.md for a v1 small project)"

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
  grep -Eq '^tier: (strong|default|cheap)' "$AG/agents/$r.md" \
    || err "role $r has no tier in frontmatter"
done

# --- adapters mirror roles ---
for dir in .claude/agents .codex/agents; do
  [ -d "$dir" ] || continue
  ext=md; [ "$dir" = .codex/agents ] && ext=toml
  for r in $roles; do
    f="$dir/$r.$ext"
    [ -f "$f" ] || { err "missing adapter $f"; continue; }
    grep -q "$AG_RE/agents/$r.md" "$f" || err "$f does not point at $AG/agents/$r.md"
    if [ "$ext" = toml ]; then
      for k in name description developer_instructions; do
        grep -Eq "^$k[[:space:]]*=" "$f" || err "$f missing required key $k"
      done
    else
      head -1 "$f" | grep -q '^---$' || err "$f missing YAML frontmatter"
      grep -Eq '^name:' "$f" && grep -Eq '^description:' "$f" \
        || err "$f frontmatter needs name and description"
    fi
  done
  for f in "$dir"/*.$ext; do
    [ -e "$f" ] || continue
    b=$(basename "$f" ".$ext")
    echo "$roles" | grep -qx "$b" || warn "adapter $f has no matching role doc"
  done
done

# --- per-file checks across everything generated ---
files=""
for f in AGENTS.md CLAUDE.md; do [ -f "$f" ] && files="$files $f"; done
gen=$(find "$AG" .claude/agents .codex/agents -type f 2>/dev/null | grep -v '/skills/.*/' )
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

[ "$total" -le 25 ] && ok "$total workflow files" || warn "$total workflow files (budget ~25)"

finish
