#!/usr/bin/env bash

# Simple aggregate network throughput across all non-loopback interfaces

get_net_bytes() {
  local rx tx
  rx=0
  tx=0
  for iface in /sys/class/net/*; do
    iface=${iface##*/}
    [[ "$iface" == "lo" ]] && continue
    if [[ -r "/sys/class/net/$iface/statistics/rx_bytes" ]]; then
      rx=$((rx + $(<"/sys/class/net/$iface/statistics/rx_bytes")))
    fi
    if [[ -r "/sys/class/net/$iface/statistics/tx_bytes" ]]; then
      tx=$((tx + $(<"/sys/class/net/$iface/statistics/tx_bytes")))
    fi
  done
  echo "$rx $tx"
}

get_net_throughput() {
  local rx1 tx1 rx2 tx2
  read -r rx1 tx1 < <(get_net_bytes)
  sleep 0.5
  read -r rx2 tx2 < <(get_net_bytes)

  local drx dtx
  drx=$((rx2 - rx1))
  dtx=$((tx2 - tx1))

  # bytes/sec -> KiB/s
  local rx_kib tx_kib
  rx_kib=$((drx / 1024))
  tx_kib=$((dtx / 1024))

  echo "$rx_kib $tx_kib"
}

render_network_section() {
  local rx_kib tx_kib
  read -r rx_kib tx_kib < <(get_net_throughput)
  printf " Net   : ↑ %4s KiB/s   ↓ %4s KiB/s\n" "$tx_kib" "$rx_kib"
}
