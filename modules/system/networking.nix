{ hostname, pkgs, ... }:

{
	networking.hostName = hostname;
	networking.networkmanager.enable = true;
	networking.firewall = {
		enable = true;
		allowedTCPPorts = [ ];
		trustedInterfaces = [ "tailscale0" ];
		interfaces."tailscale0".allowedTCPPorts = [ 22 ];
	};

	# Force the Realtek 2.5GbE (enp4s0) driver to load at boot. Without this
	# the kernel occasionally leaves the interface unbound and `ip link` shows
	# no ethernet device until `modprobe r8169` is run by hand.
	boot.kernelModules = [ "r8169" ];

	services.tailscale.enable = true;
	systemd.services.tailscaled.serviceConfig.Restart = "always";

	# `ethtool enp4s0` to see negotiated link speed.
	environment.systemPackages = [ pkgs.ethtool ];
}
