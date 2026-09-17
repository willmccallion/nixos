{ pkgs, username, ... }:

{
	boot.kernelPackages = pkgs.linuxPackages_latest;

	nix.settings = {
		experimental-features = [ "nix-command" "flakes" ];
		auto-optimise-store = true;
	};

	programs.nh = {
		enable = true;
		flake = "/home/${username}/.nixos";
		clean = {
			enable = true;
			extraArgs = "--keep-since 4d --keep 3";
		};
	};
}
