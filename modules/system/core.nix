{ pkgs, ... }:

{
	boot.kernelPackages = pkgs.linuxPackages_latest;

	nix.settings = {
		experimental-features = [ "nix-command" "flakes" ];
		auto-optimise-store = true;
	};

	programs.nh = {
		enable = true;
		flake = "/home/will/.nixos";
		clean = {
			enable = true;
			extraArgs = "--keep-since 4d --keep 3";
		};
	};

	# Weekly rebuild against fresh nixpkgs. `flake` being a local path makes
	# the module run `nix flake update --commit-lock-file` before switching,
	# so `linuxPackages_latest` picks up new kernels automatically. New kernel
	# takes effect on next reboot; allowReboot is off so we don't kill a live
	# session.
	system.autoUpgrade = {
		enable = true;
		flake = "/home/will/.nixos";
		flags = [ "-L" ];
		dates = "Sat 00:00";
		randomizedDelaySec = "45min";
		allowReboot = false;
	};
}
