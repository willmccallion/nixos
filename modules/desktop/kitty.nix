## ── Kitty ─────────────────────────────────────────────────────────────────────
## GPU-accelerated terminal emulator.
## One Dark color palette, splits layout, powerline tabs.
## Remove this import from desktop/default.nix to disable.
{ ... }:

{
	programs.kitty = {
		enable = true;

		settings = {
			# ── Font ──────────────────────────────────────────────────
			font_family = "CaskaydiaCove Nerd Font";
			font_size = 14;
			bold_font = "auto";
			italic_font = "auto";
			bold_italic_font = "auto";

			# ── Appearance ────────────────────────────────────────────
			background_opacity = "0.90";
			background = "#000000";
			dynamic_background_opacity = true;
			window_padding_width = 15;
			window_margin_width = 0;
			hide_window_decorations = true;
			draw_minimal_borders = true;
			window_border_width = "0.5pt";

			# ── Cursor ────────────────────────────────────────────────
			cursor_shape = "beam";
			cursor_blink_interval = 0;

			# ── Remote control (for dynamic theming) ──────────────────
			allow_remote_control = "socket-only";
			listen_on = "unix:/tmp/kitty-socket";

			# ── Behavior ──────────────────────────────────────────────
			scrollback_lines = 2000;
			confirm_os_window_close = 0;
			enable_audio_bell = false;
			enabled_layouts = "splits";
			inactive_text_alpha = "0.7";

			# ── Window ────────────────────────────────────────────────
			initial_window_width = 640;
			initial_window_height = 400;
			window_resize_step_cells = 2;
			window_resize_step_lines = 2;

			# ── Tabs ──────────────────────────────────────────────────
			tab_bar_style = "powerline";

			# ── One Dark colors ───────────────────────────────────────
			foreground = "#abb2bf";
			color0 = "#3f4451";
			color1 = "#e06c75";
			color2 = "#98c379";
			color3 = "#d19a66";
			color4 = "#61afef";
			color5 = "#c678dd";
			color6 = "#56b6c2";
			color7 = "#e6e6e6";
			color8 = "#4f5666";
			color9 = "#ff7b86";
			color10 = "#b1e18b";
			color11 = "#efb074";
			color12 = "#67cdff";
			color13 = "#e48bff";
			color14 = "#63d4e0";
			color15 = "#ffffff";
			color16 = "#282c34";
			color17 = "#c25d66";
			color18 = "#82a566";
			color19 = "#b38257";
			color20 = "#5499d1";
			color21 = "#a966bd";
			color22 = "#44919a";
			color23 = "#c8c8c8";
		};

		# ── Key bindings ──────────────────────────────────────────────
		keybindings = {
			"alt+t" = "new_tab_with_cwd !neighbor";
			"alt+s" = "next_tab";
			"alt+a" = "previous_tab";
			"alt+w" = "close_tab";
			"ctrl+alt+s" = "set_tab_title";
			"alt+shift+left" = "move_tab_backward";
			"alt+shift+right" = "move_tab_forward";
			"alt+1" = "goto_tab 1";
			"alt+2" = "goto_tab 2";
			"alt+3" = "goto_tab 3";
			"alt+4" = "goto_tab 4";
			"alt+5" = "goto_tab 5";
			"alt+6" = "goto_tab 6";
			"alt+7" = "goto_tab 7";
			"alt+8" = "goto_tab 8";
			"alt+9" = "goto_tab 9";
		};
	};
}
