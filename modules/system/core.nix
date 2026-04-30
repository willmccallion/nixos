{ pkgs, ... }:

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

	systemd.timers.nixos-auto-update = {
		wantedBy = [ "timers.target" ];
		timerConfig = {
			OnCalendar = "Sat *-*-* 00:00:00";
			Persistent = true;
		};
	};

	systemd.services.nixos-auto-update = {
		after = [ "network-online.target" ];
		wants = [ "network-online.target" ];
		serviceConfig.Type = "oneshot";
		path = with pkgs; [ nh git nix nvd nix-output-monitor ];
		script = "nh os switch --update /home/will/.nixos";
	};
}
