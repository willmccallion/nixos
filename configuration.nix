{ pkgs, username, hostname, ... }:

{
	imports = [
		./hardware-configuration.nix
		./core.nix
		./nvidia.nix
		./modules/desktop/stylix.nix
	];

	# ── Boot ──────────────────────────────────────────────────────────────
	boot.loader.systemd-boot.enable = true;
	boot.loader.systemd-boot.configurationLimit = 3;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.loader.efi.efiSysMountPoint = "/boot/efi";
	boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

	# ── Networking ────────────────────────────────────────────────────────
	networking.hostName = hostname;
	networking.networkmanager.enable = true;
	networking.firewall = {
		enable = true;
		allowedTCPPorts = [ ];
		interfaces."tailscale0".allowedTCPPorts = [ 22 ];
	};

	# ── Locale ────────────────────────────────────────────────────────────
	time.timeZone = "America/Edmonton";
	i18n.defaultLocale = "en_CA.UTF-8";
	services.xserver.xkb.layout = "us";

	# ── User ──────────────────────────────────────────────────────────────
	users.users.${username} = {
		isNormalUser = true;
		description = "Will McCallion";
		extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" ];
		shell = pkgs.fish;
	};

	# ── Programs ──────────────────────────────────────────────────────────
	programs.steam.enable = true;
	programs.fish.enable = true;
	programs.hyprland.enable = true;
	programs.gamemode.enable = true;
	environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];

	# ── Hardware ──────────────────────────────────────────────────────────
	hardware.bluetooth.enable = true;
	services.blueman.enable = true;

	# ── Services ──────────────────────────────────────────────────────────
	services.greetd = {
		enable = true;
		settings.default_session = {
			command = "start-hyprland";
			user = username;
		};
	};

	services.openssh = {
		enable = true;
		openFirewall = false;  # SSH restricted to tailscale0 via firewall
		settings = {
			PasswordAuthentication = false;
			PermitRootLogin = "no";
		};
	};

	services.tailscale.enable = true;
	services.fwupd.enable = true;

	system.stateVersion = "25.11";
}
