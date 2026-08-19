#!/usr/bin/env bash
# lamb-sauce — read or set the heat level.
#   heat.sh                 -> print current heat
#   heat.sh on              -> turn the persona on (at the default heat)
#   heat.sh off             -> turn it off
#   heat.sh toggle          -> flip between off and the default heat
#   heat.sh set <level>     -> simmer | service | hells-kitchen | off

set -u
ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
. "$ROOT/hooks/lib/heat.sh"

lamb_sauce_persist() {
  mkdir -p "$(lamb_sauce_state_dir)" 2>/dev/null
  printf '%s\n' "$1" > "$(lamb_sauce_state_file)"
  printf 'lamb-sauce heat set to: %s\n' "$1"
  if [ "$1" = "off" ]; then
    printf 'Kitchen closed. Turn it back on with /lamb-sauce on.\n'
  fi
}

case "${1:-get}" in
  get|status|"")
    printf 'lamb-sauce heat: %s\n' "$(lamb_sauce_heat)"
    ;;
  on)
    lamb_sauce_persist "$LAMB_SAUCE_DEFAULT_ON_HEAT"
    ;;
  off)
    lamb_sauce_persist "off"
    ;;
  toggle)
    if [ "$(lamb_sauce_heat)" = "off" ]; then
      lamb_sauce_persist "$LAMB_SAUCE_DEFAULT_ON_HEAT"
    else
      lamb_sauce_persist "off"
    fi
    ;;
  set)
    # A bare `set` means "turn it on", not "reset to nothing".
    if [ -z "${2:-}" ]; then
      resolved="$LAMB_SAUCE_DEFAULT_ON_HEAT"
    elif ! resolved=$(lamb_sauce_normalize "$2"); then
      printf 'Unknown heat "%s". Pick one of: %s\n' "$2" "$LAMB_SAUCE_VALID_HEATS" >&2
      exit 1
    fi
    lamb_sauce_persist "$resolved"
    ;;
  *)
    # Allow the level as a bare argument: `heat.sh simmer`.
    if resolved=$(lamb_sauce_normalize "$1"); then
      lamb_sauce_persist "$resolved"
    else
      printf 'usage: heat.sh [get|on|off|toggle|set <%s>]\n' "$LAMB_SAUCE_VALID_HEATS" >&2
      exit 1
    fi
    ;;
esac
exit 0
