#!/usr/bin/env bash
# Extract accent from current wallpaper and apply theme on startup.
# Waits briefly for hyprland/waybar to be ready.

sleep 1

BG="$HOME/.config/hypr/background.jpg"
[ ! -f "$BG" ] && exit 0

# Extract accent or use saved one
if [ -f /tmp/waybar-accent ]; then
	read -r R G B < /tmp/waybar-accent
else
	read -r R G B <<< "$(@python@ @extractAccentPy@ "$BG" "@convert@")"
	echo "$R $G $B" > /tmp/waybar-accent
fi

apply-accent "$R" "$G" "$B"
