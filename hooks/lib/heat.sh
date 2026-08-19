#!/usr/bin/env bash
# lamb-sauce — shared heat-level resolution.
# Sourced by the hooks and by scripts/heat.sh. Never exits non-zero.

LAMB_SAUCE_VALID_HEATS="simmer service hells-kitchen off"
LAMB_SAUCE_DEFAULT_HEAT="service"

lamb_sauce_state_dir() {
  printf '%s' "${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
}

lamb_sauce_state_file() {
  printf '%s/.lamb-sauce-heat' "$(lamb_sauce_state_dir)"
}

# Map user input to a canonical heat. Prints nothing and returns 1 if the
# input isn't recognized, so callers can tell "unknown" from "default".
lamb_sauce_normalize() {
  local in
  in=$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')
  case "$in" in
    simmer|mild|lite|low|calm)                       printf 'simmer' ;;
    service|on|default|normal|medium)                printf 'service' ;;
    hells-kitchen|hell|hells|hellskitchen|hells_kitchen|full|ultra|max)
                                                     printf 'hells-kitchen' ;;
    off|disabled|none|stop)                          printf 'off' ;;
    *)                                               return 1 ;;
  esac
}

# Precedence: LAMB_SAUCE_HEAT env var > state file > default.
lamb_sauce_heat() {
  local raw="" heat=""

  if [ -n "${LAMB_SAUCE_HEAT:-}" ]; then
    raw="$LAMB_SAUCE_HEAT"
  else
    local file
    file=$(lamb_sauce_state_file)
    [ -r "$file" ] && raw=$(cat "$file" 2>/dev/null)
  fi

  heat=$(lamb_sauce_normalize "$raw") || heat="$LAMB_SAUCE_DEFAULT_HEAT"
  printf '%s' "$heat"
}
