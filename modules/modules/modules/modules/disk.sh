#!/usr/bin/env bash

get_root_disk_usage() {
  # Returns: used_percent used total mount
  df -h / | awk 'NR==2 {print $5, $3, $2, $6}'
}

render_disk_section() {
  local percent used total mount
  read -r percent used total mount < <(get_root_disk_usage)
  printf " Disk  : %4s used  (%s / %s on %s)\n" "$percent" "$used" "$total" "$mount"
}

