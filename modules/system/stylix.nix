## ── Stylix ────────────────────────────────────────────────────────────────────
## Declarative system-wide theming derived from the default wallpaper.
## autoEnable is off — selectively enable targets as needed.
## Cursor, fonts, and icons are handled by existing configs.
## Runtime dynamic theming (waybar, borders, btop, fish, kitty bg) is in scripts.nix.
{ ... }:

{
	stylix = {
		enable = true;
		autoEnable = false;
		polarity = "dark";
		image = ../desktop/hyprland/backgrounds/default.jpg;
	};
}
