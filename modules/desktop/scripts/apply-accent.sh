#!/usr/bin/env bash
# Apply an RGB accent color across the desktop: waybar CSS, hyprland borders,
# btop theme, and fish shell colors.
# Usage: apply-accent R G B

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
	hyprctl keyword general:col.active_border "rgba(${HEX}ee) rgba(${DHEX}99) 45deg"
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
	<<< "$(@python@ @hueShiftPy@ "$R" "$G" "$B")"

# ── Regenerate waybar rounded CSS ────────────────────────────
# Remove nix store symlinks if present (home-manager creates these)
[ -L "$WAYBAR_DIR/style-rounded.css" ] && rm -f "$WAYBAR_DIR/style-rounded.css"
[ -L "$WAYBAR_DIR/style.css" ] && rm -f "$WAYBAR_DIR/style.css"
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
    border: 1px solid rgba(${R}, ${G}, ${B}, 0.28);
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
    color: rgba(${DIM_R}, ${DIM_G}, ${DIM_B}, 0.65);
    background: transparent;
    border-radius: 8px;
    transition: all 0.2s ease;
    font-weight: 400;
    margin: 0 1px;
}

#workspaces button.active {
    color: rgba(${R}, ${G}, ${B}, 0.97);
    background: rgba(${R}, ${G}, ${B}, 0.18);
    font-weight: 600;
}

#workspaces button.occupied {
    color: rgba(${DIM_R}, ${DIM_G}, ${DIM_B}, 0.85);
}

#workspaces button:hover {
    color: rgba(255, 255, 255, 0.88);
    background: rgba(255, 255, 255, 0.08);
}

#window {
    color: rgba(${DIM_R}, ${DIM_G}, ${DIM_B}, 0.50);
    font-size: 12px;
    padding: 0 4px;
    font-style: italic;
    transition: color 0.3s ease;
}

#window:hover {
    color: rgba(${R}, ${G}, ${B}, 0.80);
}

#clock {
    font-size: 15px;
    font-weight: 600;
    letter-spacing: 0.05em;
    color: rgba(${R}, ${G}, ${B}, 0.97);
    padding: 0 4px;
    transition: color 0.3s ease;
}

#clock:hover {
    color: rgba(255, 255, 255, 1.0);
}

#custom-gpu,
#custom-cputemp,
#cpu,
#memory,
#custom-netspeed,
#pulseaudio {
    padding: 0 10px;
    border-radius: 6px;
    margin: 3px 1px;
    transition: all 0.25s ease;
    background: transparent;
    background-color: transparent;
    background-image: none;
}

#custom-gpu:hover,
#custom-cputemp:hover,
#cpu:hover,
#memory:hover,
#custom-netspeed:hover,
#pulseaudio:hover {
    background: rgba(${R}, ${G}, ${B}, 0.08);
}

#custom-gpu          { color: rgba(${GPU_R}, ${GPU_G}, ${GPU_B}, 0.82); }
#custom-gpu:hover    { color: rgba(${GPU_R}, ${GPU_G}, ${GPU_B}, 1.0); }
#custom-gpu.warning  { color: rgba(225, 185, 65, 0.92); background: transparent; }
#custom-gpu.critical { color: rgba(225, 75, 75, 0.97); background: transparent; }

#custom-cputemp          { color: rgba(${CPU_R}, ${CPU_G}, ${CPU_B}, 0.78); }
#custom-cputemp:hover    { color: rgba(${CPU_R}, ${CPU_G}, ${CPU_B}, 1.0); }
#custom-cputemp.warning  { color: rgba(225, 185, 65, 0.92); background: transparent; }
#custom-cputemp.critical { color: rgba(225, 75, 75, 0.97); background: transparent; }

#cpu             { color: rgba(${CPU_R}, ${CPU_G}, ${CPU_B}, 0.72); }
#cpu:hover       { color: rgba(${CPU_R}, ${CPU_G}, ${CPU_B}, 1.0); }

#memory          { color: rgba(${MEM_R}, ${MEM_G}, ${MEM_B}, 0.72); }
#memory:hover    { color: rgba(${MEM_R}, ${MEM_G}, ${MEM_B}, 1.0); }

#custom-netspeed       { color: rgba(${NET_R}, ${NET_G}, ${NET_B}, 0.72); font-size: 12px; }
#custom-netspeed:hover { color: rgba(${NET_R}, ${NET_G}, ${NET_B}, 1.0); }

#pulseaudio        { color: rgba(${VOL_R}, ${VOL_G}, ${VOL_B}, 0.72); }
#pulseaudio:hover  { color: rgba(${VOL_R}, ${VOL_G}, ${VOL_B}, 1.0); }
#pulseaudio.muted  { color: rgba(165, 70, 70, 0.88); }

#tray { padding: 0 6px; }
#tray > .passive { -gtk-icon-effect: dim; }
CSSEOF

	# Copy to style.css so waybar reads the updated version
	cp "$WAYBAR_DIR/style-rounded.css" "$WAYBAR_DIR/style.css"

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

	@fish@ -c "
set -U fish_color_user $FISH_HEX
set -U fish_color_host $CPU_HEX
set -U fish_color_host_remote $NET_HEX
set -U fish_color_cwd $MEM_HEX
set -U fish_color_cwd_root e14b4b
set -U fish_color_normal d7d7e4
set -U fish_color_command $GPU_HEX
set -U fish_color_keyword $MEM_HEX
set -U fish_color_quote $NET_HEX
set -U fish_color_redirection $VOL_HEX
set -U fish_color_end $DIM_HEX
set -U fish_color_error e14b4b
set -U fish_color_param $CPU_HEX
set -U fish_color_comment $DIM_HEX
set -U fish_color_operator $FISH_HEX
set -U fish_color_escape $NET_HEX
set -U fish_color_autosuggestion $DIM_HEX
set -U fish_color_selection --background=$SEL_HEX
set -U fish_color_search_match --background=$SEL_HEX
set -U fish_pager_color_prefix $FISH_HEX
set -U fish_pager_color_completion d7d7e4
set -U fish_pager_color_description $DIM_HEX
set -U fish_pager_color_selected_background --background=$SEL_HEX
" 2>/dev/null || true
