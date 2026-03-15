#!/usr/bin/env bash
# Toggle between rounded (pill) and square (flat) desktop theme

CFGDIR="$HOME/.config/waybar"
STATE="/tmp/waybar-rounded"
ACCENT_FILE="/tmp/waybar-accent"

# Remove nix store symlinks if present
for f in "$CFGDIR/style.css" "$CFGDIR/style-rounded.css" "$CFGDIR/style-square.css"; do
	[ -L "$f" ] && rm -f "$f"
done

if [ -f "$STATE" ]; then
	# Rounded → Square: hide bar, no gaps, no rounding
	rm "$STATE"
	cp "$CFGDIR/style-square.css" "$CFGDIR/style.css" 2>/dev/null
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
	cp "$CFGDIR/style-rounded.css" "$CFGDIR/style.css" 2>/dev/null
	pkill -SIGUSR1 waybar
	sleep 0.1
	pkill -SIGUSR2 waybar

	hyprctl keyword general:gaps_in "4 4 4 4"
	hyprctl keyword general:gaps_out "8 8 8 8"
	hyprctl keyword decoration:rounding 10
	hyprctl keyword general:border_size 2

	# Apply saved accent color, or fallback to cool silver
	if [ -f "$ACCENT_FILE" ]; then
		read -r R G B < "$ACCENT_FILE"
	else
		R=185; G=185; B=195
	fi
	apply-accent "$R" "$G" "$B"
fi
