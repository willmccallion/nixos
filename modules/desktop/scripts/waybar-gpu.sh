#!/usr/bin/env bash
# Waybar custom module: NVIDIA GPU stats (temp, utilization, VRAM, power)

data=$(nvidia-smi \
	--query-gpu=name,temperature.gpu,utilization.gpu,memory.used,memory.total,power.draw \
	--format=csv,noheader,nounits 2>/dev/null)

if [ -z "$data" ]; then
	echo '{"text": "󰢮 --", "tooltip": "No GPU found", "class": "normal"}'
	exit 0
fi

IFS=',' read -r name temp util mem_used mem_total power <<< "$data"
name=$(echo "$name" | xargs)
temp=$(echo "$temp" | xargs)
util=$(echo "$util" | xargs)
mem_used=$(echo "$mem_used" | xargs)
mem_total=$(echo "$mem_total" | xargs)
power=$(echo "$power" | xargs | cut -d'.' -f1)

class="normal"
[ "$temp" -ge 70 ] && class="warning"
[ "$temp" -ge 85 ] && class="critical"

tooltip="${name}\nUtil: ${util}%\nVRAM: ${mem_used}/${mem_total} MiB\nTemp: ${temp}°C\nPower: ${power}W"

printf '{"text": "󰢮 %s%%  %s°C", "tooltip": "%s", "class": "%s"}\n' \
	"$util" "$temp" "$tooltip" "$class"
