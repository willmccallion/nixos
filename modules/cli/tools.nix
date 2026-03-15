## ── CLI Tools ─────────────────────────────────────────────────────────────────
## Modern CLI replacements and general utilities.
## Remove this import from cli/default.nix to disable.
{ pkgs, ... }:

{
	home.packages = with pkgs; [
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
