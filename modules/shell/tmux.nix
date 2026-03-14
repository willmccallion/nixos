## ── Tmux ──────────────────────────────────────────────────────────────────────
## Terminal multiplexer with vi bindings, transparent status line, and
## kitty/wayland clipboard integration.
## Remove this import from shell/default.nix to disable.
{ pkgs, ... }:

{
	programs.tmux = {
		enable = true;
		terminal = "tmux-256color";
		mouse = true;
		keyMode = "vi";
		baseIndex = 1;
		escapeTime = 0;

		extraConfig = ''
			# ── Clipboard / Wayland ──────────────────────────────────────────
			set -s set-clipboard on
			set-option -ga update-environment " WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_SESSION_DESKTOP"
			set -as terminal-features ',*:clipboard'

			# ── Copy mode (vi) ───────────────────────────────────────────────
			bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection-and-cancel
			bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

			# ── Pane index ───────────────────────────────────────────────────
			setw -g pane-base-index 1
			set -g renumber-windows on

			# ── Status line (transparent, minimal) ───────────────────────────
			set -g status-style bg=default
			set -g status-fg colour245

			set -g status-left "#[fg=colour255,bold]#S  "
			set -g status-left-length 20

			set-window-option -g window-status-format "#[fg=colour245]#I:#W"
			set-window-option -g window-status-current-format "#[fg=colour255,bold]#I:#W"

			set -g status-right ""

			# ── Prefix ───────────────────────────────────────────────────────
			unbind C-b
			set -g prefix C-a
			bind C-a send-prefix

			# ── Window switching: Alt+N (macOS/SSH) ──────────────────────────
			bind -n M-1 select-window -t 1
			bind -n M-2 select-window -t 2
			bind -n M-3 select-window -t 3
			bind -n M-4 select-window -t 4
			bind -n M-5 select-window -t 5
			bind -n M-6 select-window -t 6
			bind -n M-7 select-window -t 7
			bind -n M-8 select-window -t 8
			bind -n M-9 select-window -t 9

			# ── Window switching: F-keys (Linux/Hyprland) ────────────────────
			bind -n F1 select-window -t 1
			bind -n F2 select-window -t 2
			bind -n F3 select-window -t 3
			bind -n F4 select-window -t 4
			bind -n F5 select-window -t 5
			bind -n F6 select-window -t 6
			bind -n F7 select-window -t 7
			bind -n F8 select-window -t 8
			bind -n F9 select-window -t 9
		'';
	};
}
