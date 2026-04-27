#!/usr/bin/env bash
# Flip between rounded (waybar visible, gaps, rounding, accent border) and
# square (waybar stopped, no gaps, no rounding) modes. apply-accent reads
# the new mode from the state file and reconfigures everything.

set -u

STATE_DIR="$HOME/.local/state/desktop-theme"
MODE_FILE="$STATE_DIR/mode"

mkdir -p "$STATE_DIR"
current=$(cat "$MODE_FILE" 2>/dev/null || echo "rounded")

if [ "$current" = "rounded" ]; then
	echo "square" > "$MODE_FILE"
else
	echo "rounded" > "$MODE_FILE"
fi

apply-accent
