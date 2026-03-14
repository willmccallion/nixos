## ── Hyprland ──────────────────────────────────────────────────────────────────
## Wayland compositor configuration.
## Dual monitor, dwindle layout, full animations, nvidia env vars.
## Dynamic theming via toggle-theme (Alt+B) and wallpaper picker (Alt+W).
## Remove this import from desktop/default.nix to disable.
{ pkgs, lib, ... }:

{
	home.packages = with pkgs; [
		grim
		slurp
		wl-clipboard
		hyprpaper
		playerctl
		brightnessctl
	];

	# ── Wallpapers ─────────────────────────────────────────────────────────
	# Copy backgrounds to ~/.config/hypr/ (writable, so wallpaper picker can
	# update background.jpg at runtime). Only copies if backgrounds dir is missing.
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

	xdg.configFile."hypr/hyprpaper.conf".text = ''
preload = /home/will/.config/hypr/background.jpg

wallpaper {
    monitor =
    path = /home/will/.config/hypr/background.jpg
}

splash = false
	'';

	# ── Compositor ─────────────────────────────────────────────────────────
	wayland.windowManager.hyprland = {
		enable = true;

		settings = {
			# ── Variables ──────────────────────────────────────────────
			"$terminal" = "kitty";
			"$menu" = "wofi --show drun";
			"$mainMod" = "Alt_L";

			# ── Monitors (auto-detect) ────────────────────────────────
			monitor = ", preferred, auto, 1";

			# ── Autostart ─────────────────────────────────────────────
			exec-once = [
				"hyprpaper"
				"touch /tmp/waybar-rounded"
				"waybar"
			];

			# ── Environment ───────────────────────────────────────────
			env = [
				"XCURSOR_SIZE, 24"
				"HYPRCURSOR_SIZE, 24"
				"GDK_BACKEND, wayland,x11"
				"__GLX_VENDOR_LIBRARY_NAME, nvidia"
			];

			# ── General ───────────────────────────────────────────────
			general = {
				gaps_in = "4 4 4 4";
				gaps_out = "8 8 8 8";
				border_size = 1;
				"col.active_border" = "rgba(1a1a1aee)";
				resize_on_border = false;
				allow_tearing = false;
				layout = "dwindle";
			};

			# ── Decoration ────────────────────────────────────────────
			decoration = {
				rounding = 10;
				rounding_power = 2;
				active_opacity = 1.0;
				inactive_opacity = 1.0;

				shadow = {
					enabled = true;
					range = 4;
					render_power = 3;
					color = "rgba(1a1a1aee)";
				};

				blur = {
					enabled = true;
					size = 3;
					passes = 1;
					vibrancy = 0.1696;
				};
			};

			# ── Animations ────────────────────────────────────────────
			animations = {
				enabled = true;

				bezier = [
					"easeOutQuint, 0.23, 1, 0.32, 1"
					"easeInOutCubic, 0.65, 0.05, 0.36, 1"
					"linear, 0, 0, 1, 1"
					"almostLinear, 0.5, 0.5, 0.75, 1.0"
					"quick, 0.15, 0, 0.1, 1"
				];

				animation = [
					"global, 1, 10, default"
					"border, 1, 5.39, easeOutQuint"
					"windows, 1, 4.79, easeOutQuint"
					"windowsIn, 1, 4.1, easeOutQuint, popin 87%"
					"windowsOut, 1, 1.49, linear, popin 87%"
					"fadeIn, 1, 1.73, almostLinear"
					"fadeOut, 1, 1.46, almostLinear"
					"fade, 1, 3.03, quick"
					"layers, 1, 3.81, easeOutQuint"
					"workspaces, 1, 6, easeOutQuint, slide"
				];
			};

			# ── Layout ────────────────────────────────────────────────
			dwindle = {
				pseudotile = true;
				preserve_split = true;
			};

			master.new_status = "master";

			# ── Misc ──────────────────────────────────────────────────
			misc = {
				force_default_wallpaper = 0;
				disable_hyprland_logo = true;
			};

			# ── Input ─────────────────────────────────────────────────
			input = {
				kb_layout = "us";
				follow_mouse = 1;
				sensitivity = 0;
			};

			# ── Window rules ──────────────────────────────────────────
			windowrule = [
				"match:class ^(btop-float)$, opacity 0.72 0.65"
				"match:class ^(claude-float)$, opacity 0.85 0.78"
			];

			# ── Key bindings ──────────────────────────────────────────
			bind = [
				# Applications
				"$mainMod, T, exec, $terminal"
				"$mainMod, C, killactive"
				"$mainMod, P, togglefloating"
				"$mainMod, D, exec, $menu"
				"$mainMod, F, fullscreen"
				"$mainMod, Z, exec, zen-browser"
				"$mainMod, X, exec, kitty --class btop-float btop"
				"$mainMod, Q, exec, kitty --class claude-float --directory ~/projects fish -c claude"

				# Dynamic theming
				"$mainMod, B, exec, toggle-theme"
				"$mainMod, W, exec, wallpaper-picker"

				# Screenshots
				"$mainMod SHIFT, W, exec, grim -g \"$(slurp)\" - | wl-copy"
				", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
				"$mainMod, Print, exec, grim - | wl-copy"

				# Focus
				"$mainMod, J, movefocus, l"
				"$mainMod, K, movefocus, r"
				"$mainMod, U, movefocus, u"
				"$mainMod, I, movefocus, d"

				# Workspaces
				"$mainMod, 1, workspace, 1"
				"$mainMod, 2, workspace, 2"
				"$mainMod, 3, workspace, 3"
				"$mainMod, 4, workspace, 4"
				"$mainMod, 5, workspace, 5"
				"$mainMod, 6, workspace, 6"
				"$mainMod, 7, workspace, 7"
				"$mainMod, 8, workspace, 8"
				"$mainMod, 9, workspace, 9"
				"$mainMod, 0, workspace, 10"

				# Move window to workspace
				"$mainMod SHIFT, 1, movetoworkspace, 1"
				"$mainMod SHIFT, 2, movetoworkspace, 2"
				"$mainMod SHIFT, 3, movetoworkspace, 3"
				"$mainMod SHIFT, 4, movetoworkspace, 4"
				"$mainMod SHIFT, 5, movetoworkspace, 5"
				"$mainMod SHIFT, 6, movetoworkspace, 6"
				"$mainMod SHIFT, 7, movetoworkspace, 7"
				"$mainMod SHIFT, 8, movetoworkspace, 8"
				"$mainMod SHIFT, 9, movetoworkspace, 9"
				"$mainMod SHIFT, 0, movetoworkspace, 10"

				# Silent move (no follow)
				"$mainMod CTRL, 1, movetoworkspacesilent, 1"
				"$mainMod CTRL, 2, movetoworkspacesilent, 2"
				"$mainMod CTRL, 3, movetoworkspacesilent, 3"
				"$mainMod CTRL, 4, movetoworkspacesilent, 4"
				"$mainMod CTRL, 5, movetoworkspacesilent, 5"
				"$mainMod CTRL, 6, movetoworkspacesilent, 6"
				"$mainMod CTRL, 7, movetoworkspacesilent, 7"
				"$mainMod CTRL, 8, movetoworkspacesilent, 8"
				"$mainMod CTRL, 9, movetoworkspacesilent, 9"
				"$mainMod CTRL, 0, movetoworkspacesilent, 10"

				# Special workspace
				"$mainMod, S, togglespecialworkspace, magic"
				"$mainMod SHIFT, S, movetoworkspace, special:magic"

				# Mouse scroll workspaces
				"$mainMod, mouse_down, workspace, e+1"
				"$mainMod, mouse_up, workspace, e-1"
			];

			# ── Mouse bindings ────────────────────────────────────────
			bindm = [
				"$mainMod, mouse:272, movewindow"
				"$mainMod, mouse:273, resizewindow"
			];

			# ── Media / hardware keys ─────────────────────────────────
			bindel = [
				", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
				", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
				", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
				", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
				", XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
				", XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
			];

			bindl = [
				", XF86AudioNext, exec, playerctl next"
				", XF86AudioPause, exec, playerctl play-pause"
				", XF86AudioPlay, exec, playerctl play-pause"
				", XF86AudioPrev, exec, playerctl previous"
			];
		};

		extraConfig = ''
			ecosystem:no_update_news = true
		'';
	};
}
