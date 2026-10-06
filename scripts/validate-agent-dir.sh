#!/usr/bin/env bash
#
# Validates a generated workflow directory in a target repository.
#
#   validate-agent-dir.sh [target-repo-root] [workflow-dir]
#                                              full validation of <root>/<workflow-dir>
#                                              (default .agent; pass the real name, such
#                                              as .agents, for a workflow adopted in place)
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
# $2, if given, is a path pattern to leave out.
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
  done < <(find "$1" -type f -name '*.md' -not -path '*/.git/*' -not -path "${2:-*/.git/*}")
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
name=${2:-.agent}
name=${name%/}
agent="$root/$name"
# $name as a literal in a regular expression.
name_re=$(printf '%s' "$name" | sed 's/[][\\.*^$/]/\\&/g')

# Skills installed by a tool (skills/<name>/...) are not part of the workflow.
installed="$agent/skills/*/*"

# A workflow adopted in place keeps its own layout, so structure is advisory there.
structure() {
  if [ "$name" = ".agent" ]; then err "$1"; else warn "$1"; fi
}

if [ ! -d "$agent" ]; then
  err "$agent does not exist"
  finish
fi

[ -f "$agent/PROJECT.md" ] || structure "$name/PROJECT.md is missing"
[ -f "$agent/WORKFLOW.md" ] || [ -d "$agent/workflows" ] ||
  structure "$name/ has no task workflow (WORKFLOW.md for a small project, workflows/ otherwise)"
for other in .agent .agents .ai; do
  [ "$other" != "$name" ] && [ -d "$root/$other" ] &&
    [ -n "$(find "$root/$other" -type f -name '*.md' -not -path '*/skills/*' -print -quit)" ] &&
    warn "$other/ exists alongside $name/; keep one workflow directory"
done

while IFS= read -r file; do
  rel=${file#"$root"/}

  [ -s "$file" ] || { err "$rel is empty"; continue; }

  while IFS= read -r hit; do
    err "$rel:$hit  (unresolved placeholder or installer note)"
  done < <(grep -n -e '{{' -e 'INSTALLER:' "$file" | cut -c1-120)

  if [ "$name" != ".ai" ]; then
    while IFS= read -r hit; do
      warn "$rel:$hit  (mentions .ai/; the workflow directory is $name/)"
    done < <(grep -n -E '(^|[^A-Za-z0-9_/])\.ai/' "$file" | cut -c1-120)
  fi

  # Backticked workflow-directory paths must exist in the target repository.
  while IFS= read -r path; do
    case "$path" in
      *'*'* | *'<'* | *'{'*) continue ;;
    esac
    [ -e "$root/$path" ] || err "$rel: references missing file $path"
  done < <(grep -o "\`$name_re/[^\` ]*\`" "$file" | tr -d '`' | sed 's/[.,:;]*$//' | sort -u)

  lines=$(wc -l < "$file" | tr -d ' ')
  [ "$lines" -gt 200 ] && warn "$rel is $lines lines; generated files should stay small"
done < <(find "$agent" -type f -name '*.md' -not -path "$installed")

check_links "$agent" "$installed"

# Something outside the workflow directory must point agents at it.
pointer=0
for entry in AGENTS.md CLAUDE.md GEMINI.md .cursorrules .windsurfrules \
  .github/copilot-instructions.md .cursor/rules; do
  if [ -e "$root/$entry" ] && grep -rq "$name_re/" "$root/$entry" 2>/dev/null; then
    pointer=1
    break
  fi
done
[ "$pointer" -eq 1 ] || warn "no agent entry file (AGENTS.md, CLAUDE.md, ...) points to $name/"

finish
