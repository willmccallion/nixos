## ── Hyprland ──────────────────────────────────────────────────────────────────
## Wayland compositor configuration.
## Split into: appearance, keybinds, rules.
## Dynamic theming via toggle-theme (Alt+B) and wallpaper picker (Alt+W).
{ config, pkgs, lib, ... }:

{
	imports = [
		./appearance.nix
		./keybinds.nix
		./rules.nix
	];

	home.pointerCursor = {
		name = "Bibata-Modern-Classic";
		package = pkgs.bibata-cursors;
		size = 24;
		gtk.enable = true;
	};

	home.packages = with pkgs; [
		grim
		slurp
		wl-clipboard
		hyprpaper
		playerctl
		brightnessctl
		bibata-cursors
	];

	# ── Wallpapers ─────────────────────────────────────────────────────────
	home.activation.deployWallpapers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
		BG_SRC="${./backgrounds}"
		BG_DEST="$HOME/.config/hypr/backgrounds"
		BG_DEFAULT="$HOME/.config/hypr/background.jpg"

		if [ ! -d "$BG_DEST" ]; then
			mkdir -p "$BG_DEST"
			cp "$BG_SRC"/* "$BG_DEST/"
			chmod u+w "$BG_DEST"/*
		fi

		if [ ! -f "$BG_DEFAULT" ]; then
			cp "$BG_SRC/default.jpg" "$BG_DEFAULT"
			chmod u+w "$BG_DEFAULT"
		fi
	'';

	xdg.configFile."hypr/hyprpaper.conf".text = let
		bg = "${config.home.homeDirectory}/.config/hypr/background.jpg";
	in ''
preload = ${bg}

wallpaper {
    monitor =
    path = ${bg}
}

splash = false
	'';

	# ── Compositor ─────────────────────────────────────────────────────────
	wayland.windowManager.hyprland = {
		enable = true;

		settings = {
			"$terminal" = "kitty";
			"$menu" = "wofi --show drun";
			"$mainMod" = "Alt_L";

			monitor = [
				"HDMI-A-1, preferred, 0x0, 1"
				"HDMI-A-2, preferred, 1920x0, 1"
			];

			exec-once = [
				"hyprpaper"
				"restore-theme"
			];

			env = [
				"XCURSOR_SIZE, 24"
				"XCURSOR_THEME, Bibata-Modern-Classic"
				"HYPRCURSOR_SIZE, 24"
				"HYPRCURSOR_THEME, Bibata-Modern-Classic"
				"GDK_BACKEND, wayland,x11"
				"__GLX_VENDOR_LIBRARY_NAME, nvidia"
			];
		};

		extraConfig = ''
			ecosystem:no_update_news = true

			cursor {
				no_hardware_cursors = true
			}
		'';
	};
}
