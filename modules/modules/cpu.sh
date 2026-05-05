#!/usr/bin/env bash

get_cpu_load() {
  # 1-minute load average
  awk '{print $1}' /proc/loadavg 2>/dev/null
}

get_cpu_usage_percent() {
  # Approximate CPU usage using /proc/stat (simple delta over short sleep)
  local cpu1 cpu2 idle1 idle2 total1 total2 diff_idle diff_total usage

  read -r _ user1 nice1 system1 idle1 iowait1 irq1 softirq1 steal1 _ < /proc/stat
  total1=$((user1 + nice1 + system1 + idle1 + iowait1 + irq1 + softirq1 + steal1))

  sleep 0.2

  read -r _ user2 nice2 system2 idle2 iowait2 irq2 softirq2 steal2 _ < /proc/stat
  total2=$((user2 + nice2 + system2 + idle2 + iowait2 + irq2 + softirq2 + steal2))

  diff_idle=$((idle2 - idle1))
  diff_total=$((total2 - total1))

  if (( diff_total == 0 )); then
    usage=0
  else
    usage=$(( (100 * (diff_total - diff_idle)) / diff_total ))
  fi

  echo "$usage"
}

render_cpu_section() {
  local load usage
  load="$(get_cpu_load)"
  usage="$(get_cpu_usage_percent)"

  printf " CPU   : %5s load  %3s%% used\n" "$load" "$usage"
}

