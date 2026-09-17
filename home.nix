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

		# Keep transient tool state out of $HOME. These paths only take effect
		# if the tool is ever invoked (e.g. via nix-shell); no packages here
		# install go/docker/wget by default.
		GOPATH = "${config.xdg.dataHome}/go";
		DOCKER_CONFIG = "${config.xdg.configHome}/docker";
		__GL_SHADER_DISK_CACHE_PATH = "${config.xdg.cacheHome}/nv";
	};

	# Redirect wget's HSTS state file. wget doesn't respect XDG on its own.
	home.file.".wgetrc".text = ''
		hsts-file = ${config.xdg.stateHome}/wget-hsts
	'';

	# ── Neovim (standalone config, cross-platform) ────────────────────────
	# The nvim config lives as a git submodule at modules/dev/nvim.
	# Nix flakes can't see submodule contents, so we symlink at activation.
	xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink
		"${config.home.homeDirectory}/.nixos/modules/dev/nvim";

	programs.home-manager.enable = true;
}
