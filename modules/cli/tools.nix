## ── CLI Tools ─────────────────────────────────────────────────────────────────
## Modern CLI replacements and general utilities.
## Remove this import from cli/default.nix to disable.
{ pkgs, ... }:

{
	# `,` — run any package without installing (backed by nix-index database).
	programs.nix-index.enable = true;
	programs.nix-index.enableFishIntegration = true;
	programs.command-not-found.enable = false;

	home.packages = with pkgs; [
		comma

		# Modern replacements
		fzf
		ripgrep
		fd
		bat
		eza
		zoxide

		# Utilities
		tree
		unzip
		zip
		wget
		curl
		bc
		imv
		unrar
		p7zip
	];
}
