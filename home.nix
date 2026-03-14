## ── Home Manager ──────────────────────────────────────────────────────────────
## Entry point for user-level configuration.
## Each module category can be commented out independently.
{ pkgs, ... }:

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
	# Symlink the nvim submodule to ~/.config/nvim
	xdg.configFile."nvim".source = ./modules/dev/nvim;

	programs.home-manager.enable = true;
}
