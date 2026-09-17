#!/usr/bin/env bash
# Waybar custom module: network upload/download speed

iface=$(@ip@ route | @awk@ '/default/ {print $5; exit}')
[ -z "$iface" ] && iface="enp4s0"

rx1=$(@awk@ "/$iface:/ {print \$2}" /proc/net/dev)
tx1=$(@awk@ "/$iface:/ {print \$10}" /proc/net/dev)
sleep 1
rx2=$(@awk@ "/$iface:/ {print \$2}" /proc/net/dev)
tx2=$(@awk@ "/$iface:/ {print \$10}" /proc/net/dev)

rx_kb=$(( (rx2 - rx1) / 1024 ))
tx_kb=$(( (tx2 - tx1) / 1024 ))

fmt_speed() {
	local kb=$1
	if [ "$kb" -ge 1024 ]; then
		printf "%.1f M" "$(echo "scale=1; $kb/1024" | @bc@)"
	else
		printf "%d K" "$kb"
	fi
}

down=$(fmt_speed $rx_kb)
up=$(fmt_speed $tx_kb)

link_speed=$(cat "/sys/class/net/$iface/speed" 2>/dev/null)
if [ -n "$link_speed" ] && [ "$link_speed" -gt 0 ] 2>/dev/null; then
	if [ "$link_speed" -ge 1000 ]; then
		link_fmt=$(printf "%.1f Gbps" "$(echo "scale=1; $link_speed/1000" | @bc@)")
	else
		link_fmt="${link_speed} Mbps"
	fi
	tooltip="Interface: $iface\nLink: $link_fmt"
else
	tooltip="Interface: $iface"
fi

echo "{\"text\": \"󰛳 ↓${down} ↑${up}\", \"tooltip\": \"$tooltip\"}"
