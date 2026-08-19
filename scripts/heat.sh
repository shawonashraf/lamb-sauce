#!/usr/bin/env bash
# lamb-sauce — read or set the heat level.
#   heat.sh            -> print current heat
#   heat.sh set <lvl>  -> persist heat (simmer|service|hells-kitchen|off)

set -u
ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
. "$ROOT/hooks/lib/heat.sh"

case "${1:-get}" in
  get|"")
    printf 'lamb-sauce heat: %s\n' "$(lamb_sauce_heat)"
    ;;
  set)
    if [ -z "${2:-}" ]; then
      resolved="$LAMB_SAUCE_DEFAULT_HEAT"
    elif ! resolved=$(lamb_sauce_normalize "$2"); then
      printf 'Unknown heat "%s". Pick one of: %s\n' "$2" "$LAMB_SAUCE_VALID_HEATS" >&2
      exit 1
    fi
    mkdir -p "$(lamb_sauce_state_dir)" 2>/dev/null
    printf '%s\n' "$resolved" > "$(lamb_sauce_state_file)"
    printf 'lamb-sauce heat set to: %s\n' "$resolved"
    if [ "$resolved" = "off" ]; then
      printf 'Persona stays off in new sessions until you set it back on.\n'
    fi
    ;;
  *)
    printf 'usage: heat.sh [get|set <%s>]\n' "$LAMB_SAUCE_VALID_HEATS" >&2
    exit 1
    ;;
esac
exit 0
