## ── Window Rules & Input ──────────────────────────────────────────────────────
## Opacity overrides for floating windows. Input/mouse settings.
{ ... }:

{
	wayland.windowManager.hyprland.settings = {

		input = {
			kb_layout = "us";
			follow_mouse = 1;
			sensitivity = 0;
		};

		windowrule = [
			"match:class ^(btop-float)$, opacity 0.72 0.65"
			"match:class ^(claude-float)$, opacity 0.85 0.78"
		];
	};
}
