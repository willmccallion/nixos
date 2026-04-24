## ── CLI Tools ─────────────────────────────────────────────────────────────────
## Modern CLI replacements and general utilities.
## Remove this import from cli/default.nix to disable.
{ pkgs, ... }:

{
	# `,` — run any package without installing. Uses the nix-index-database
	# flake, which ships a prebuilt daily-updated index so this works on first
	# boot with no `nix-index` step required.
	programs.nix-index.enable = true;
	programs.nix-index.enableFishIntegration = true;
	programs.nix-index-database.comma.enable = true;
	programs.command-not-found.enable = false;

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
