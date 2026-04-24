{ ... }:

{
	nix.settings = {
		experimental-features = [ "nix-command" "flakes" ];
		auto-optimise-store = true;
	};

	# `nh` — nicer nixos-rebuild wrapper with diff output, and handles GC.
	# `nh os switch` replaces `nixos-rebuild switch`. `clean` replaces the old
	# weekly nix.gc timer below — keeps the most recent 3 generations and
	# anything from the last 4 days, drops the rest.
	programs.nh = {
		enable = true;
		flake = "/home/will/projects/nixos";
		clean = {
			enable = true;
			extraArgs = "--keep-since 4d --keep 3";
		};
	};
}
