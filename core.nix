{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		git
		neovim
		wget
		curl
		unzip
		zip
	];

	nix.settings = {
		experimental-features = [ "nix-command" "flakes" ];
		auto-optimise-store = true;
	};

	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 7d";
	};
}
