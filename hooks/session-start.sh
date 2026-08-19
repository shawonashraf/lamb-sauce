#!/usr/bin/env bash
# lamb-sauce — SessionStart hook.
# Emits the persona ruleset on stdout; Claude Code adds SessionStart stdout to
# the session context. Always exits 0 so a bad install never blocks a session.

set -u
ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
# shellcheck source=lib/heat.sh
. "$ROOT/hooks/lib/heat.sh" 2>/dev/null || exit 0

heat=$(lamb_sauce_heat)
[ "$heat" = "off" ] && exit 0

cat "$ROOT/persona/base.md" 2>/dev/null
cat "$ROOT/persona/$heat.md" 2>/dev/null

cat << MARKER

<!-- lamb-sauce active: heat=$heat -->
MARKER

exit 0
