#!/usr/bin/env bash
# Restore the saved theme on Hyprland startup.
# If no accent has ever been saved, extract one from the current wallpaper.

set -u

STATE_DIR="$HOME/.local/state/desktop-theme"
ACCENT_FILE="$STATE_DIR/accent"
BG="$HOME/.config/hypr/background.jpg"

# Let waybar.service settle if it was started by graphical-session.target.
sleep 0.5

mkdir -p "$STATE_DIR"

if [ ! -s "$ACCENT_FILE" ] && [ -f "$BG" ]; then
	if rgb=$(@python@ @extractAccentPy@ "$BG" "@convert@"); then
		echo "$rgb" > "$ACCENT_FILE"
	fi
fi

apply-accent
