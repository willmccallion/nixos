{ pkgs, ... }:

{
	programs.nix-index.enable = true;
	programs.nix-index.enableFishIntegration = true;
	programs.nix-index-database.comma.enable = true;
	programs.command-not-found.enable = false;

	home.packages = with pkgs; [
		fzf
		ripgrep
		fd
		bat
		eza
		zoxide
		tree
		unzip
		zip
		wget
		curl
		bc
		imv
		unrar
		p7zip
		rclone
		tldr
	];
}
