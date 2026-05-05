#!/usr/bin/env bash

get_memory_usage() {
  # Returns: used_percent total_MB used_MB
  local total used
  read -r _ total used _ < <(free -m | awk '/^Mem:/ {print $1, $2, $3, $4}')
  if (( total == 0 )); then
    echo "0 0 0"
    return
  fi
  local percent=$(( (100 * used) / total ))
  echo "$percent $total $used"
}

render_memory_section() {
  local percent total used
  read -r percent total used < <(get_memory_usage)
  printf " Memory: %3s%% used  (%s MiB / %s MiB)\n" "$percent" "$used" "$total"
}

