#!/usr/bin/env bash
#
# Validates a generated .agent/ directory in a target repository.
#
#   validate-agent-dir.sh [target-repo-root]   full validation of <root>/.agent
#   validate-agent-dir.sh --links <dir>        only check relative Markdown links under <dir>
#
# Exits 1 if any error is found. Warnings do not affect the exit code.

set -u

errors=0
warnings=0

err() {
  printf 'ERROR  %s\n' "$1"
  errors=$((errors + 1))
}

warn() {
  printf 'WARN   %s\n' "$1"
  warnings=$((warnings + 1))
}

# Reports relative Markdown links under $1 whose target does not exist.
check_links() {
  local file dir target
  while IFS= read -r file; do
    dir=$(dirname "$file")
    while IFS= read -r target; do
      target=${target%% *}
      target=${target%%#*}
      case "$target" in
        '' | http://* | https://* | mailto:* | *'{{'*) continue ;;
      esac
      [ -e "$dir/$target" ] || err "$file: broken link -> $target"
    done < <(grep -o '\]([^)]*)' "$file" | sed -e 's/^](//' -e 's/)$//')
  done < <(find "$1" -type f -name '*.md' -not -path '*/.git/*')
}

finish() {
  printf '\n%d error(s), %d warning(s)\n' "$errors" "$warnings"
  [ "$errors" -eq 0 ]
  exit $?
}

if [ "${1:-}" = "--links" ]; then
  [ -d "${2:-}" ] || { echo "usage: $0 --links <dir>" >&2; exit 2; }
  check_links "$2"
  finish
fi

root=${1:-.}
agent="$root/.agent"

if [ ! -d "$agent" ]; then
  err "$agent does not exist"
  finish
fi

[ -f "$agent/PROJECT.md" ] || err ".agent/PROJECT.md is missing"
[ -f "$agent/WORKFLOW.md" ] || [ -d "$agent/workflows" ] ||
  err ".agent/ has no task workflow (WORKFLOW.md for a small project, workflows/ otherwise)"
[ -d "$root/.ai" ] && warn ".ai/ exists alongside .agent/; migrate or remove the legacy directory"

while IFS= read -r file; do
  rel=${file#"$root"/}

  [ -s "$file" ] || { err "$rel is empty"; continue; }

  while IFS= read -r hit; do
    err "$rel:$hit  (unresolved placeholder or installer note)"
  done < <(grep -n -e '{{' -e 'INSTALLER:' "$file" | cut -c1-120)

  while IFS= read -r hit; do
    warn "$rel:$hit  (mentions .ai/; the workflow directory is .agent/)"
  done < <(grep -n -E '(^|[^A-Za-z0-9_/])\.ai/' "$file" | cut -c1-120)

  # Backticked .agent/ paths must exist in the target repository.
  while IFS= read -r path; do
    case "$path" in
      *'*'* | *'<'* | *'{'*) continue ;;
    esac
    [ -e "$root/$path" ] || err "$rel: references missing file $path"
  done < <(grep -o '`\.agent/[^` ]*`' "$file" | tr -d '`' | sed 's/[.,:;]*$//' | sort -u)

  lines=$(wc -l < "$file" | tr -d ' ')
  [ "$lines" -gt 200 ] && warn "$rel is $lines lines; generated files should stay small"
done < <(find "$agent" -type f -name '*.md')

check_links "$agent"

# Something outside .agent/ must point agents at it.
pointer=0
for entry in AGENTS.md CLAUDE.md GEMINI.md .cursorrules .windsurfrules \
  .github/copilot-instructions.md .cursor/rules; do
  if [ -e "$root/$entry" ] && grep -rq '\.agent/' "$root/$entry" 2>/dev/null; then
    pointer=1
    break
  fi
done
[ "$pointer" -eq 1 ] || warn "no agent entry file (AGENTS.md, CLAUDE.md, ...) points to .agent/"

finish
