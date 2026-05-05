#!/usr/bin/env bash
#
# System Health Dashboard (Neon)
#

set -o errexit
set -o pipefail
set -o nounset

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_DIR="${SCRIPT_DIR}/modules"

# shellcheck source=modules/colors.sh
source "${MODULE_DIR}/colors.sh"
# shellcheck source=modules/cpu.sh
source "${MODULE_DIR}/cpu.sh"
# shellcheck source=modules/memory.sh
source "${MODULE_DIR}/memory.sh"
# shellcheck source=modules/disk.sh
source "${MODULE_DIR}/disk.sh"
# shellcheck source=modules/network.sh
source "${MODULE_DIR}/network.sh"
# shellcheck source=modules/system.sh
source "${MODULE_DIR}/system.sh"

print_border_top() {
  echo -e "${COLOR_CYAN}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${COLOR_RESET}"
}

print_border_mid() {
  echo -e "${COLOR_CYAN}┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫${COLOR_RESET}"
}

print_border_bottom() {
  echo -e "${COLOR_CYAN}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${COLOR_RESET}"
}

print_title() {
  local title="✦ SYSTEM HEALTH DASHBOARD ✦"
  printf "${COLOR_CYAN}┃${COLOR_RESET} "
  echo -ne "${COLOR_MAGENTA}${title}${COLOR_RESET}"
  # pad to width
  local width=50
  local len=${#title}
  local pad=$((width - len))
  if (( pad > 0 )); then
    printf "%${pad}s" " "
  fi
  echo -e "${COLOR_CYAN}┃${COLOR_RESET}"
}

print_line() {
  printf "${COLOR_CYAN}┃${COLOR_RESET} %s" "$1"
  local width=50
  local len=${#1}
  local pad=$((width - len))
  if (( pad > 0 )); then
    printf "%${pad}s" " "
  fi
  echo -e "${COLOR_CYAN}┃${COLOR_RESET}"
}

render_dashboard_once() {
  clear
  print_border_top
  print_title
  print_border_mid

  # Collect sections into lines
  local cpu_line mem_line disk_line net_line
  local sys_host sys_kernel sys_uptime sys_temp

  cpu_line="$(render_cpu_section)"
  mem_line="$(render_memory_section)"
  disk_line="$(render_disk_section)"
  net_line="$(render_network_section)"

  # System info lines
  sys_host="$(get_hostname)"
  sys_kernel="$(get_kernel)"
  sys_uptime="$(get_uptime_pretty)"
  sys_temp="$(get_temp_c)"

  print_line "$cpu_line"
  print_line "$mem_line"
  print_line "$disk_line"
  print_line "$net_line"
  print_border_mid
  print_line " Host  : ${sys_host}"
  print_line " Kernel: ${sys_kernel}"
  print_line " Uptime: ${sys_uptime}"
  print_line " Temp  : ${sys_temp}°C"
  print_border_bottom
}

usage() {
  cat <<EOF
System Health Dashboard

Usage:
  $(basename "$0")           Show a single snapshot
  $(basename "$0") --live    Live mode (1s interval)
  $(basename "$0") --live N  Live mode with N-second interval

EOF
}

main() {
  local mode="once"
  local interval=1

  if (( $# > 0 )); then
    case "${1:-}" in
      --live)
        mode="live"
        if (( $# > 1 )); then
          interval="$2"
        fi
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        usage
        exit 1
        ;;
    esac
  fi

  if [[ "$mode" == "once" ]]; then
    render_dashboard_once
  else
    while true; do
      render_dashboard_once
      sleep "$interval"
    done
  fi
}

main "$@"
