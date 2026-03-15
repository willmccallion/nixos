#!/usr/bin/env bash
# Waybar custom module: CPU package temperature

temp=$(@sensors@ coretemp-isa-0000 2>/dev/null \
	| @awk@ '/Package id 0:/ {gsub(/[^0-9.]/, "", $4); print int($4)}')

if [ -z "$temp" ]; then
	echo '{"text": "󰔏 --", "class": "normal"}'
	exit 0
fi

class="normal"
[ "$temp" -ge 70 ] && class="warning"
[ "$temp" -ge 85 ] && class="critical"

echo "{\"text\": \"󰔏 ${temp}°C\", \"class\": \"$class\"}"
