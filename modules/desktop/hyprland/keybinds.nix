## ── Key Bindings ──────────────────────────────────────────────────────────────
## Alt as main mod. Vim-like focus. Workspaces 1-10.
## Dynamic theming: Alt+B toggle theme, Alt+W wallpaper picker.
{ ... }:

{
	wayland.windowManager.hyprland.settings = {

		bind = [
			# ── Applications ──────────────────────────────────────
			"$mainMod, T, exec, $terminal"
			"$mainMod, C, killactive"
			"$mainMod, P, togglefloating"
			"$mainMod, D, exec, $menu"
			"$mainMod, F, fullscreen"
			"$mainMod, Z, exec, zen-browser"
			"$mainMod, X, exec, kitty --class btop-float btop"
			"$mainMod, Q, exec, kitty --class claude-float --directory ~/projects fish -c claude"

			# ── Theming ───────────────────────────────────────────
			"$mainMod, B, exec, toggle-theme"
			"$mainMod, W, exec, wallpaper-picker"

			# ── Screenshots ───────────────────────────────────────
			"$mainMod SHIFT, W, exec, grim -g \"$(slurp)\" - | wl-copy"
			", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
			"$mainMod, Print, exec, grim - | wl-copy"

			# ── Focus (vim) ───────────────────────────────────────
			"$mainMod, J, movefocus, l"
			"$mainMod, K, movefocus, r"
			"$mainMod, U, movefocus, u"
			"$mainMod, I, movefocus, d"

			# ── Workspaces ────────────────────────────────────────
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

			# ── Move to workspace ─────────────────────────────────
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

			# ── Silent move (no follow) ───────────────────────────
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

			# ── Special workspace ─────────────────────────────────
			"$mainMod, S, togglespecialworkspace, magic"
			"$mainMod SHIFT, S, movetoworkspace, special:magic"

			# ── Mouse scroll workspaces ───────────────────────────
			"$mainMod, mouse_down, workspace, e+1"
			"$mainMod, mouse_up, workspace, e-1"
		];

		# ── Mouse bindings ────────────────────────────────────────────
		bindm = [
			"$mainMod, mouse:272, movewindow"
			"$mainMod, mouse:273, resizewindow"
		];

		# ── Media / hardware keys ─────────────────────────────────────
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
}
