#!/usr/bin/env bash
# lamb-sauce — optional statusline badge. Wire it up in settings.json:
#   "statusLine": { "type": "command", "command": "bash /path/to/lamb-sauce/scripts/statusline.sh" }
set -u
ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
. "$ROOT/hooks/lib/heat.sh" 2>/dev/null || exit 0
heat=$(lamb_sauce_heat)
case "$heat" in
  off)           printf '[lamb-sauce: off]' ;;
  simmer)        printf '🌡️  LAMB SAUCE:SIMMER' ;;
  service)       printf '🔥 LAMB SAUCE:SERVICE' ;;
  hells-kitchen) printf '🌋 LAMB SAUCE:HELL'"'"'S KITCHEN' ;;
esac
exit 0
