#!/usr/bin/env bash

get_uptime_pretty() {
  uptime -p 2>/dev/null || uptime
}

get_hostname() {
  hostname
}

get_kernel() {
  uname -r
}

get_temp_c() {
  # Try a common thermal zone; may not exist on all systems
  local path="/sys/class/thermal/thermal_zone0/temp"
  if [[ -r "$path" ]]; then
    local raw
    raw=$(<"$path")
    # Most systems expose millidegrees
    echo "$((raw / 1000))"
  else
    echo "N/A"
  fi
}

render_system_section() {
  local host kernel uptime temp
  host="$(get_hostname)"
  kernel="$(get_kernel)"
  uptime="$(get_uptime_pretty)"
  temp="$(get_temp_c)"

  printf " Host  : %s\n" "$host"
  printf " Kernel: %s\n" "$kernel"
  printf " Uptime: %s\n" "$uptime"
  printf " Temp  : %s°C\n" "$temp"
}
