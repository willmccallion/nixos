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
fi

# Validate; fall back to cool silver if extraction failed
if ! [[ "$R" =~ ^[0-9]+$ && "$G" =~ ^[0-9]+$ && "$B" =~ ^[0-9]+$ ]]; then
	R=185; G=185; B=195
fi
echo "$R $G $B" > /tmp/waybar-accent

apply-accent "$R" "$G" "$B"
