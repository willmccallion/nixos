{ ... }:

{
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
}
