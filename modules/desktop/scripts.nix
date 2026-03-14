## ── Desktop Scripts ───────────────────────────────────────────────────────────
## Dynamic theming system: wallpaper picker extracts accent colors and applies
## them to waybar CSS, hyprland borders, btop theme, and fish shell colors.
## Also includes waybar helper scripts (GPU, CPU temp, network speed).
## Remove this import from desktop/default.nix to disable all dynamic theming.
{ pkgs, ... }:

let
	# ── Waybar helper scripts ──────────────────────────────────────────────

	gpu-script = pkgs.writeShellScriptBin "waybar-gpu" ''
		data=$(nvidia-smi \
			--query-gpu=name,temperature.gpu,utilization.gpu,memory.used,memory.total,power.draw \
			--format=csv,noheader,nounits 2>/dev/null)

		if [ -z "$data" ]; then
			echo '{"text": "GPU N/A", "tooltip": "No GPU found", "class": "normal"}'
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

		tooltip="''${name} | Util: ''${util}% | VRAM: ''${mem_used}/''${mem_total} MiB | Temp: ''${temp}°C | Power: ''${power}W"

		printf '{"text": "[GPU %s%%  %s°C]", "tooltip": "%s", "class": "%s"}\n' \
			"$util" "$temp" "$tooltip" "$class"
	'';

	cputemp-script = pkgs.writeShellScriptBin "waybar-cputemp" ''
		temp=$(${pkgs.lm_sensors}/bin/sensors coretemp-isa-0000 2>/dev/null \
			| ${pkgs.gawk}/bin/awk '/Package id 0:/ {gsub(/[^0-9.]/, "", $4); print int($4)}')

		if [ -z "$temp" ]; then
			echo '{"text": "CPU N/A", "class": "normal"}'
			exit 0
		fi

		class="normal"
		[ "$temp" -ge 70 ] && class="warning"
		[ "$temp" -ge 85 ] && class="critical"

		echo "{\"text\": \"''${temp}°C]\", \"class\": \"$class\"}"
	'';

	netspeed-script = pkgs.writeShellScriptBin "waybar-netspeed" ''
		# Detect first active non-loopback interface
		iface=$(${pkgs.iproute2}/bin/ip route | ${pkgs.gawk}/bin/awk '/default/ {print $5; exit}')
		[ -z "$iface" ] && iface="enp4s0"

		rx1=$(${pkgs.gawk}/bin/awk "/$iface:/ {print \$2}" /proc/net/dev)
		tx1=$(${pkgs.gawk}/bin/awk "/$iface:/ {print \$10}" /proc/net/dev)
		sleep 1
		rx2=$(${pkgs.gawk}/bin/awk "/$iface:/ {print \$2}" /proc/net/dev)
		tx2=$(${pkgs.gawk}/bin/awk "/$iface:/ {print \$10}" /proc/net/dev)

		rx_kb=$(( (rx2 - rx1) / 1024 ))
		tx_kb=$(( (tx2 - tx1) / 1024 ))

		fmt_speed() {
			local kb=$1
			if [ "$kb" -ge 1024 ]; then
				printf "%.1f MB/s" "$(echo "scale=1; $kb/1024" | ${pkgs.bc}/bin/bc)"
			else
				printf "%d KB/s" "$kb"
			fi
		}

		down=$(fmt_speed $rx_kb)
		up=$(fmt_speed $tx_kb)

		echo "{\"text\": \"[NET  ↓$down  ↑$up]\", \"tooltip\": \"Interface: $iface\"}"
	'';

	# ── Apply accent color ─────────────────────────────────────────────────
	# Core theming engine. Takes R G B args and regenerates:
	#   - waybar rounded CSS (with accent-derived stat colors)
	#   - hyprland border gradient
	#   - btop theme
	#   - fish shell colors
	apply-accent = pkgs.writeShellScriptBin "apply-accent" ''
		R=$1; G=$2; B=$3

		WAYBAR_DIR="$HOME/.config/waybar"
		HEX=$(printf "%02x%02x%02x" "$R" "$G" "$B")

		# Second gradient stop for hyprland border
		SAT=$(( ( (R > G ? R : G) > B ? (R > G ? R : G) : B ) - ( (R < G ? R : G) < B ? (R < G ? R : G) : B ) ))
		if [ "$SAT" -lt 30 ]; then
			DR=30; DG=30; DB=32
		else
			DR=$(( R * 45 / 100 )); DG=$(( G * 45 / 100 )); DB=$(( B * 45 / 100 ))
		fi
		DHEX=$(printf "%02x%02x%02x" "$DR" "$DG" "$DB")

		# ── Hyprland border (only in rounded mode) ───────────────────
		if [ -f /tmp/waybar-rounded ]; then
			hyprctl keyword general:col.active_border "rgba(''${HEX}ee) rgba(''${DHEX}99) 45deg"
			hyprctl keyword general:col.inactive_border "rgba(ffffff10)"
		fi

		# ── Derive stat colors from accent via hue shifts ────────────
		read -r \
			GPU_R GPU_G GPU_B \
			CPU_R CPU_G CPU_B \
			MEM_R MEM_G MEM_B \
			NET_R NET_G NET_B \
			VOL_R VOL_G VOL_B \
			DIM_R DIM_G DIM_B \
		< <(${pkgs.python3}/bin/python3 - "$R" "$G" "$B" << 'PYEOF'
		import colorsys, sys

		r, g, b = int(sys.argv[1])/255, int(sys.argv[2])/255, int(sys.argv[3])/255
		h, s, v = colorsys.rgb_to_hsv(r, g, b)
		grayscale = s < 0.12

		def mk(sat_mul, val):
			sat = (s * sat_mul) if not grayscale else (s * sat_mul * 0.4)
			rr, gg, bb = colorsys.hsv_to_rgb(h, min(sat, 1.0), min(val, 1.0))
			return int(rr*255), int(gg*255), int(bb*255)

		gpu = mk(1.00, 0.85)
		cpu = mk(0.70, 0.72)
		mem = mk(0.85, 0.62)
		net = mk(0.55, 0.78)
		vol = mk(0.40, 0.68)
		dim = mk(0.25, 0.50)

		for c in [gpu, cpu, mem, net, vol, dim]:
			print(*c, end=' ')
		PYEOF
		)

		# ── Regenerate waybar rounded CSS ────────────────────────────
		cat > "$WAYBAR_DIR/style-rounded.css" << CSSEOF
		/* ── Rounded / Hyprland pill mode (auto-generated) ─────────── */
		* {
			font-family: "CaskaydiaCove Nerd Font", monospace;
			font-size: 13px;
			min-height: 0;
			border: none;
			border-radius: 0;
			padding: 0;
			margin: 0;
		}

		window#waybar {
			background: transparent;
			color: rgba(215, 215, 228, 0.92);
		}

		.modules-left {
			background: rgba(12, 12, 18, 0.78);
			border-radius: 0 12px 12px 0;
			border: 1px solid rgba(255, 255, 255, 0.07);
			border-left: none;
			padding: 0 14px 0 8px;
			margin: 4px 0;
		}

		.modules-center {
			background: rgba(12, 12, 18, 0.80);
			border-radius: 12px;
			border: 1px solid rgba(''${R}, ''${G}, ''${B}, 0.28);
			padding: 0 20px;
			margin: 4px 0;
		}

		.modules-right {
			background: rgba(12, 12, 18, 0.78);
			border-radius: 12px 0 0 12px;
			border: 1px solid rgba(255, 255, 255, 0.07);
			border-right: none;
			padding: 0 8px 0 14px;
			margin: 4px 0;
		}

		#workspaces button {
			padding: 2px 9px;
			color: rgba(''${DIM_R}, ''${DIM_G}, ''${DIM_B}, 0.65);
			background: transparent;
			border-radius: 8px;
			transition: all 0.15s ease;
			font-weight: 400;
			margin: 0 1px;
		}

		#workspaces button.active {
			color: rgba(''${R}, ''${G}, ''${B}, 0.97);
			background: rgba(''${R}, ''${G}, ''${B}, 0.18);
			font-weight: 600;
		}

		#workspaces button.occupied {
			color: rgba(''${DIM_R}, ''${DIM_G}, ''${DIM_B}, 0.85);
		}

		#workspaces button:hover {
			color: rgba(255, 255, 255, 0.88);
			background: rgba(255, 255, 255, 0.08);
		}

		#window {
			color: rgba(''${DIM_R}, ''${DIM_G}, ''${DIM_B}, 0.50);
			font-size: 12px;
			padding: 0 4px;
			font-style: italic;
		}

		#clock {
			font-size: 15px;
			font-weight: 600;
			letter-spacing: 0.05em;
			color: rgba(''${R}, ''${G}, ''${B}, 0.97);
			padding: 0 4px;
		}

		#custom-gpu,
		#custom-cputemp,
		#cpu,
		#memory,
		#custom-netspeed,
		#pulseaudio,
		#tray {
			padding: 0 8px;
		}

		#custom-gpu          { color: rgba(''${GPU_R}, ''${GPU_G}, ''${GPU_B}, 0.90); }
		#custom-gpu.warning  { color: rgba(225, 185, 65, 0.92); }
		#custom-gpu.critical { color: rgba(225, 75, 75, 0.97); }

		#custom-cputemp          { color: rgba(''${CPU_R}, ''${CPU_G}, ''${CPU_B}, 0.88); }
		#custom-cputemp.warning  { color: rgba(225, 185, 65, 0.92); }
		#custom-cputemp.critical { color: rgba(225, 75, 75, 0.97); }

		#cpu             { color: rgba(''${CPU_R}, ''${CPU_G}, ''${CPU_B}, 0.80); }
		#memory          { color: rgba(''${MEM_R}, ''${MEM_G}, ''${MEM_B}, 0.82); }
		#custom-netspeed { color: rgba(''${NET_R}, ''${NET_G}, ''${NET_B}, 0.82); font-size: 12px; }
		#pulseaudio      { color: rgba(''${VOL_R}, ''${VOL_G}, ''${VOL_B}, 0.82); }
		#pulseaudio.muted { color: rgba(165, 70, 70, 0.88); }

		#tray { padding: 0 6px; }
		#tray > .passive { -gtk-icon-effect: dim; }
		CSSEOF

		# Reload waybar CSS if running
		pkill -SIGUSR2 waybar 2>/dev/null || true

		# ── Regenerate btop theme ────────────────────────────────────
		BTOP_THEME="$HOME/.config/btop/themes/wallpaper.theme"
		mkdir -p "$(dirname "$BTOP_THEME")"

		DIM2_R=$(( GPU_R * 35 / 100 )); DIM2_G=$(( GPU_G * 35 / 100 )); DIM2_B=$(( GPU_B * 35 / 100 ))
		CPU_DIM_R=$(( CPU_R * 35 / 100 )); CPU_DIM_G=$(( CPU_G * 35 / 100 )); CPU_DIM_B=$(( CPU_B * 35 / 100 ))
		MEM_DIM_R=$(( MEM_R * 35 / 100 )); MEM_DIM_G=$(( MEM_G * 35 / 100 )); MEM_DIM_B=$(( MEM_B * 35 / 100 ))
		NET_DIM_R=$(( NET_R * 35 / 100 )); NET_DIM_G=$(( NET_G * 35 / 100 )); NET_DIM_B=$(( NET_B * 35 / 100 ))
		ACC_DIM_R=$(( R * 25 / 100 ));    ACC_DIM_G=$(( G * 25 / 100 ));    ACC_DIM_B=$(( B * 25 / 100 ))

		cat > "$BTOP_THEME" << THEMEEOF
		# Wallpaper-derived btop theme — auto-generated by apply-accent
		# Accent: rgb($R, $G, $B)

		theme[main_bg]="#0c0c12"
		theme[main_fg]="#d7d7e4"
		theme[title]="$(printf "%02x%02x%02x" "$R" "$G" "$B")"
		theme[hi_fg]="$(printf "%02x%02x%02x" "$GPU_R" "$GPU_G" "$GPU_B")"
		theme[selected_bg]="$(printf "%02x%02x%02x" "$ACC_DIM_R" "$ACC_DIM_G" "$ACC_DIM_B")"
		theme[selected_fg]="#d7d7e4"
		theme[inactive_fg]="$(printf "%02x%02x%02x" "$DIM_R" "$DIM_G" "$DIM_B")"
		theme[graph_text]="$(printf "%02x%02x%02x" "$DIM_R" "$DIM_G" "$DIM_B")"
		theme[meter_bg]="#1a1a22"
		theme[proc_misc]="$(printf "%02x%02x%02x" "$DIM_R" "$DIM_G" "$DIM_B")"
		theme[cpu_box]="$(printf "%02x%02x%02x" "$R" "$G" "$B")"
		theme[mem_box]="$(printf "%02x%02x%02x" "$R" "$G" "$B")"
		theme[net_box]="$(printf "%02x%02x%02x" "$R" "$G" "$B")"
		theme[proc_box]="$(printf "%02x%02x%02x" "$R" "$G" "$B")"
		theme[div_line]="$(printf "%02x%02x%02x" "$ACC_DIM_R" "$ACC_DIM_G" "$ACC_DIM_B")"
		theme[temp_start]="$(printf "%02x%02x%02x" "$DIM_R" "$DIM_G" "$DIM_B")"
		theme[temp_mid]="#e1b941"
		theme[temp_end]="#e14b4b"
		theme[cpu_start]="$(printf "%02x%02x%02x" "$CPU_DIM_R" "$CPU_DIM_G" "$CPU_DIM_B")"
		theme[cpu_mid]=""
		theme[cpu_end]="$(printf "%02x%02x%02x" "$CPU_R" "$CPU_G" "$CPU_B")"
		theme[free_start]="$(printf "%02x%02x%02x" "$MEM_DIM_R" "$MEM_DIM_G" "$MEM_DIM_B")"
		theme[free_mid]=""
		theme[free_end]="$(printf "%02x%02x%02x" "$MEM_R" "$MEM_G" "$MEM_B")"
		theme[cached_start]="$(printf "%02x%02x%02x" "$MEM_DIM_R" "$MEM_DIM_G" "$MEM_DIM_B")"
		theme[cached_mid]=""
		theme[cached_end]="$(printf "%02x%02x%02x" "$MEM_R" "$MEM_G" "$MEM_B")"
		theme[available_start]="$(printf "%02x%02x%02x" "$MEM_DIM_R" "$MEM_DIM_G" "$MEM_DIM_B")"
		theme[available_mid]=""
		theme[available_end]="$(printf "%02x%02x%02x" "$MEM_R" "$MEM_G" "$MEM_B")"
		theme[used_start]="$(printf "%02x%02x%02x" "$MEM_DIM_R" "$MEM_DIM_G" "$MEM_DIM_B")"
		theme[used_mid]=""
		theme[used_end]="$(printf "%02x%02x%02x" "$MEM_R" "$MEM_G" "$MEM_B")"
		theme[download_start]="$(printf "%02x%02x%02x" "$NET_DIM_R" "$NET_DIM_G" "$NET_DIM_B")"
		theme[download_mid]=""
		theme[download_end]="$(printf "%02x%02x%02x" "$NET_R" "$NET_G" "$NET_B")"
		theme[upload_start]="$(printf "%02x%02x%02x" "$NET_DIM_R" "$NET_DIM_G" "$NET_DIM_B")"
		theme[upload_mid]=""
		theme[upload_end]="$(printf "%02x%02x%02x" "$NET_R" "$NET_G" "$NET_B")"
		theme[process_start]="$(printf "%02x%02x%02x" "$CPU_DIM_R" "$CPU_DIM_G" "$CPU_DIM_B")"
		theme[process_mid]=""
		theme[process_end]="$(printf "%02x%02x%02x" "$CPU_R" "$CPU_G" "$CPU_B")"
		THEMEEOF

		# ── Apply fish shell colors ──────────────────────────────────
		FISH_HEX=$(printf "%02x%02x%02x" "$R" "$G" "$B")
		GPU_HEX=$(printf "%02x%02x%02x" "$GPU_R" "$GPU_G" "$GPU_B")
		CPU_HEX=$(printf "%02x%02x%02x" "$CPU_R" "$CPU_G" "$CPU_B")
		MEM_HEX=$(printf "%02x%02x%02x" "$MEM_R" "$MEM_G" "$MEM_B")
		NET_HEX=$(printf "%02x%02x%02x" "$NET_R" "$NET_G" "$NET_B")
		VOL_HEX=$(printf "%02x%02x%02x" "$VOL_R" "$VOL_G" "$VOL_B")
		DIM_HEX=$(printf "%02x%02x%02x" "$DIM_R" "$DIM_G" "$DIM_B")
		SEL_HEX=$(printf "%02x%02x%02x" "$ACC_DIM_R" "$ACC_DIM_G" "$ACC_DIM_B")

		${pkgs.fish}/bin/fish -c '
		set -U fish_color_user         '"$FISH_HEX"'
		set -U fish_color_host         '"$CPU_HEX"'
		set -U fish_color_host_remote  '"$NET_HEX"'
		set -U fish_color_cwd          '"$MEM_HEX"'
		set -U fish_color_cwd_root     e14b4b
		set -U fish_color_normal       d7d7e4
		set -U fish_color_command      '"$GPU_HEX"'
		set -U fish_color_keyword      '"$MEM_HEX"'
		set -U fish_color_quote        '"$NET_HEX"'
		set -U fish_color_redirection  '"$VOL_HEX"'
		set -U fish_color_end          '"$DIM_HEX"'
		set -U fish_color_error        e14b4b
		set -U fish_color_param        '"$CPU_HEX"'
		set -U fish_color_comment      '"$DIM_HEX"'
		set -U fish_color_operator     '"$FISH_HEX"'
		set -U fish_color_escape       '"$NET_HEX"'
		set -U fish_color_autosuggestion '"$DIM_HEX"'
		set -U fish_color_selection    --background='"$SEL_HEX"'
		set -U fish_color_search_match --background='"$SEL_HEX"'
		set -U fish_pager_color_prefix         '"$FISH_HEX"'
		set -U fish_pager_color_completion     d7d7e4
		set -U fish_pager_color_description   '"$DIM_HEX"'
		set -U fish_pager_color_selected_background --background='"$SEL_HEX"'
		' 2>/dev/null || true
	'';

	# ── Toggle theme (Alt+B) ───────────────────────────────────────────────
	# Switches between rounded (waybar visible, gaps, rounding, accent border)
	# and square (no bar, no gaps, no rounding) modes.
	toggle-theme = pkgs.writeShellScriptBin "toggle-theme" ''
		CFGDIR="$HOME/.config/waybar"
		STATE="/tmp/waybar-rounded"
		ACCENT_FILE="/tmp/waybar-accent"

		if [ -f "$STATE" ]; then
			# Rounded → Square: hide bar, no gaps, no rounding
			rm "$STATE"
			ln -sf "$CFGDIR/style-square.css" "$CFGDIR/style.css"
			pkill -SIGUSR2 waybar
			sleep 0.1
			pkill -SIGUSR1 waybar

			hyprctl keyword general:gaps_in 0
			hyprctl keyword general:gaps_out 0
			hyprctl keyword decoration:rounding 0
			hyprctl keyword general:border_size 0
		else
			# Square → Rounded: show bar, gaps, rounding, accent
			touch "$STATE"
			ln -sf "$CFGDIR/style-rounded.css" "$CFGDIR/style.css"
			pkill -SIGUSR1 waybar
			sleep 0.1
			pkill -SIGUSR2 waybar

			hyprctl keyword general:gaps_in "4 4 4 4"
			hyprctl keyword general:gaps_out "8 8 8 8"
			hyprctl keyword decoration:rounding 10
			hyprctl keyword general:border_size 1

			# Apply saved accent color, or fallback to cool silver
			if [ -f "$ACCENT_FILE" ]; then
				read -r R G B < "$ACCENT_FILE"
			else
				R=185; G=185; B=195
			fi
			apply-accent "$R" "$G" "$B"
		fi
	'';

	# ── Wallpaper picker (Alt+W) ──────────────────────────────────────────
	# Picks a wallpaper, applies it, then themes everything to match.
	wallpaper-picker = pkgs.writeShellScriptBin "wallpaper-picker" ''
		BG_DIR="$HOME/.config/hypr/backgrounds"
		CURRENT="$HOME/.config/hypr/background.jpg"

		chosen=$(ls "$BG_DIR" | ${pkgs.wofi}/bin/wofi --dmenu --prompt "  Wallpaper" --width 380 --height 300 --no-actions)
		[ -z "$chosen" ] && exit 0

		path="$BG_DIR/$chosen"

		# ── Apply wallpaper ──────────────────────────────────────────
		hyprctl hyprpaper preload "$path"
		hyprctl hyprpaper wallpaper "HDMI-A-1,$path"
		hyprctl hyprpaper wallpaper "HDMI-A-2,$path"
		cp "$path" "$CURRENT"

		# ── Persist as default in nix repo ───────────────────────────
		NIX_BG="$HOME/.config/nixos/modules/desktop/hyprland/backgrounds/default.jpg"
		cp "$path" "$NIX_BG" 2>/dev/null || true

		# ── Extract accent color ─────────────────────────────────────
		CONVERT_BIN="${pkgs.imagemagick}/bin/convert"
		read -r R G B < <(${pkgs.python3}/bin/python3 - "$path" "$CONVERT_BIN" << 'PYEOF'
		import subprocess, re, sys

		path = sys.argv[1]
		convert_bin = sys.argv[2]
		result = subprocess.run([
			convert_bin, path,
			'-resize', '200x200^', '-gravity', 'center', '-extent', '200x200',
			'+dither', '-colors', '12', '-unique-colors', 'txt:-'
		], capture_output=True, text=True)

		colors = []
		for line in result.stdout.splitlines():
			m = re.search(r'\((\d+),(\d+),(\d+)\)', line)
			if m:
				r, g, b = int(m.group(1)), int(m.group(2)), int(m.group(3))
				mx, mn = max(r,g,b), min(r,g,b)
				sat = (mx - mn) / mx if mx > 0 else 0
				brightness = mx / 255
				score = sat * (1 - abs(brightness - 0.55))
				colors.append((score, r, g, b))

		colors.sort(reverse=True)
		if colors and colors[0][0] > 0.25:
			_, r, g, b = colors[0]
		else:
			r, g, b = 185, 185, 195  # fallback: cool silver for desaturated images

		print(r, g, b)
		PYEOF
		)

		# ── Persist accent and apply ─────────────────────────────────
		echo "$R $G $B" > /tmp/waybar-accent
		apply-accent "$R" "$G" "$B"
	'';

in
{
	home.packages = [
		gpu-script
		cputemp-script
		netspeed-script
		apply-accent
		toggle-theme
		wallpaper-picker
		pkgs.python3
		pkgs.imagemagick
		pkgs.lm_sensors
		pkgs.bc
		pkgs.iproute2
		pkgs.gawk
	];
}
