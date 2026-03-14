## ── Home Manager ──────────────────────────────────────────────────────────────
## Entry point for user-level configuration.
## Each module category can be commented out independently.
{ pkgs, lib, ... }:

{
	imports = [
		./modules/desktop  # Hyprland, Waybar, Kitty, Wofi, theming, scripts
		./modules/apps     # Firefox, Discord, Office, Steam
		./modules/cli      # Btop, CLI tools
		./modules/dev      # Git, Rust, C, Zig, Python
		./modules/shell    # Fish, Tmux
		./modules/school   # School-related
	];

	home.username = "will";
	home.homeDirectory = "/home/will";
	home.stateVersion = "25.11";

	# ── Neovim (standalone config, cross-platform) ────────────────────────
	# The nvim config lives as a git submodule at modules/dev/nvim.
	# Nix flakes can't see submodule contents, so we symlink at activation.
	home.activation.linkNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
		NVIM_SRC="$HOME/.config/nixos/modules/dev/nvim"
		NVIM_DEST="$HOME/.config/nvim"
		if [ -d "$NVIM_SRC" ] && [ ! -e "$NVIM_DEST" ]; then
			ln -sf "$NVIM_SRC" "$NVIM_DEST"
		fi
	'';

	programs.home-manager.enable = true;
}
