## ── Fish Shell ────────────────────────────────────────────────────────────────
## Core fish configuration: environment, vi bindings, aliases, abbreviations.
## Fish functions are in a separate module (fish-functions.nix).
## Remove this import from shell/default.nix to disable.
{ pkgs, ... }:

{
	programs.fish = {
		enable = true;

		# ── Interactive session ────────────────────────────────────────────
		interactiveShellInit = ''
			# Disable greeting and show fastfetch instead
			set fish_greeting ""
			if status is-interactive; and not set -q INSIDE_TMUX_DEV
				fastfetch
			end

			# Vi key bindings
			fish_vi_key_bindings

			# Zoxide (smart cd)
			zoxide init fish | source

			# Kitty / Wayland clipboard integration
			if set -q SSH_TTY
				function wl-copy
					if count $argv > /dev/null
						printf "%s" "$argv" | kitten clipboard
					else
						kitten clipboard
					end
				end
				function copy; wl-copy $argv; end
				function wl-paste; kitten clipboard --get-clipboard; end
			else
				function copy; command wl-copy $argv; end
			end
		'';

		# ── Environment variables ──────────────────────────────────────────
		shellInit = ''
			fish_add_path ~/.cargo/bin
			fish_add_path ~/.local/bin
		'';

		# ── Aliases ────────────────────────────────────────────────────────
		shellAliases = {
			# Editor
			vim = "nvim";

			# Modern CLI replacements
			ls = "eza --icons --git --header";
			ll = "eza -al --icons --git --header";
			lt = "eza --tree --level=2 --icons";
			cat = "bat";

			# Kitty
			icat = "kitten icat";

			# Config shortcuts
			conff = "nvim ~/.nixos/modules/shell/fish.nix";
			reload = "source ~/.config/fish/config.fish";

			# NixOS management
			nix-switch = "sudo nh os switch";
			nix-update = "sudo nh os switch --update";
			nix-gc     = "sudo nh clean all";

			# Nix shell
			ns = "nix-shell -p";
			nixsearch = "nix search nixpkgs";
			nixrun = "nix run nixpkgs#";
			nixdev = "nix develop";
		};

		# ── Abbreviations (auto-expanding) ─────────────────────────────────
		shellAbbrs = {
			# Cargo
			c = "cargo";
			cr = "cargo run";
			cw = "cargo watch -x run";

			# Compiler
			g = "gcc -Wall -Wextra -g";
			val = "valgrind --leak-check=full --show-leak-kinds=all";

			# Git
			ga = "git add .";
			gc = "git commit -m";
			gp = "git push";
			gs = "git status";
			gd = "git diff";
		};
	};

}
