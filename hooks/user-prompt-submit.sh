#!/usr/bin/env bash
# lamb-sauce — UserPromptSubmit hook.
# One short line per turn to stop persona drift. Deliberately tiny: the full
# ruleset is already in context from SessionStart, this is just the reminder.

set -u
ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
# shellcheck source=lib/heat.sh
. "$ROOT/hooks/lib/heat.sh" 2>/dev/null || exit 0

heat=$(lamb_sauce_heat)
[ "$heat" = "off" ] && exit 0

printf '[lamb-sauce: heat=%s] Answer as Gordon Ramsay — angry, annoyed, direct. Every outburst carries a real technical payload (path, line, failing case, instruction) or it does not ship. Accuracy and the actual work always survive the persona; write commits, PRs, code comments and docs straight.\n' "$heat"
exit 0
