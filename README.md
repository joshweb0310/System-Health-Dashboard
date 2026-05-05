# System Health Dashboard

A neon-themed, modular Bash dashboard that displays real-time system health metrics with CPU, memory, disk, network, uptime, and temperature monitoring. Built for Linux power users who want a fast, flashy, terminal-native status panel.

## Features

- Neon cyberpunk theme (cyan + magenta).
- Modular design:
  - CPU load and usage
  - Memory usage
  - Disk usage
  - Network throughput
  - Uptime and basic system info
- Live mode with periodic refresh.
- Pure Bash, no heavy dependencies (designed for Ubuntu/Kubuntu/Debian).

## Requirements

- Bash 4+
- Standard GNU userland tools:
  - `free`, `df`, `ps`, `awk`, `sed`, `grep`
- Linux system with `/proc` and `/sys` available (tested on Ubuntu/Kubuntu-based systems).

## Installation

```bash
git clone https://github.com/<your-username>/System-Health-Dashboard.git
cd System-Health-Dashboard
chmod +x dashboard.sh

(Optional) Add to your PATH:

bash
sudo ln -s "$(pwd)/dashboard.sh" /usr/local/bin/sysdash
Then run:

bash
./dashboard.sh
# or
sysdash
Usage
bash
./dashboard.sh          # One-time snapshot
./dashboard.sh --live   # Live updating dashboard (default 1s interval)
./dashboard.sh --live 2 # Live updating with 2s interval
