{ hostname, ... }:

{
	networking.hostName = hostname;
	networking.networkmanager.enable = true;
	networking.firewall = {
		enable = true;
		allowedTCPPorts = [ ];
		interfaces."tailscale0".allowedTCPPorts = [ 22 ];
	};
	services.tailscale.enable = true;
}
