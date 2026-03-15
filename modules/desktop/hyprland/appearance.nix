## ── Appearance ────────────────────────────────────────────────────────────────
## Gaps, borders, rounding, shadows, blur, animations, layout.
{ ... }:

{
	wayland.windowManager.hyprland.settings = {

		general = {
			gaps_in = "4 4 4 4";
			gaps_out = "8 8 8 8";
			border_size = 2;
			"col.active_border" = "rgba(1a1a1aee)";
			resize_on_border = false;
			allow_tearing = false;
			layout = "dwindle";
		};

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

		dwindle = {
			pseudotile = true;
			preserve_split = true;
		};

		master.new_status = "master";

		misc = {
			force_default_wallpaper = 0;
			disable_hyprland_logo = true;
		};
	};
}
