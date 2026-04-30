## ── Home Manager ──────────────────────────────────────────────────────────────
## Entry point for user-level configuration.
## Each module category can be commented out independently.
{ config, pkgs, lib, username, ... }:

{
	imports = [
		./modules/desktop  # Hyprland, Waybar, Kitty, Wofi, theming, scripts
		./modules/apps     # Firefox, Discord, Office
		./modules/games    # Minecraft
		./modules/cli      # Btop, CLI tools
		./modules/dev      # Git, Rust, C, Zig, Python
		./modules/shell    # Fish, Tmux
	];

	home.username = username;
	home.homeDirectory = "/home/${username}";
	home.stateVersion = "25.11";

	home.sessionVariables = {
		EDITOR = "nvim";
		VISUAL = "nvim";
	};

	# ── Neovim (standalone config, cross-platform) ────────────────────────
	# The nvim config lives as a git submodule at modules/dev/nvim.
	# Nix flakes can't see submodule contents, so we symlink at activation.
	xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink
		"${config.home.homeDirectory}/.nixos/modules/dev/nvim";

	programs.home-manager.enable = true;
}
