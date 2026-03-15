#!/usr/bin/env bash
# Interactive wallpaper picker: select wallpaper, extract accent, apply theme

BG_DIR="$HOME/.config/hypr/backgrounds"
CURRENT="$HOME/.config/hypr/background.jpg"

chosen=$(ls "$BG_DIR" | @wofi@ --dmenu --prompt "  Wallpaper" --width 380 --height 300 --no-actions)
[ -z "$chosen" ] && exit 0

path="$BG_DIR/$chosen"

# ── Apply wallpaper ──────────────────────────────────────────
rm -f "$CURRENT"
cp "$path" "$CURRENT"
chmod u+w "$CURRENT"
killall hyprpaper 2>/dev/null; sleep 0.3; hyprpaper &

# ── Persist as default in nix repo ───────────────────────────
NIX_BG="$HOME/.config/nixos/modules/desktop/hyprland/backgrounds/default.jpg"
cp "$path" "$NIX_BG" 2>/dev/null || true

# ── Extract accent color ─────────────────────────────────────
read -r R G B <<< "$(@python@ @extractAccentPy@ "$path" "@convert@")"

# ── Persist accent and apply ─────────────────────────────────
echo "$R $G $B" > /tmp/waybar-accent
apply-accent "$R" "$G" "$B"
