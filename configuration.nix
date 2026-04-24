{ pkgs, username, hostname, ... }:

{
	imports = [
		./hardware-configuration.nix
		./core.nix
		./nvidia.nix
		./modules/desktop/stylix.nix
		./modules/dev/compat.nix
		./backup.nix
	];

	# ── Boot ──────────────────────────────────────────────────────────────
	boot.loader.systemd-boot.enable = true;
	boot.loader.systemd-boot.configurationLimit = 3;
	boot.loader.efi.canTouchEfiVariables = true;
	# systemd-based initrd: caches the LUKS passphrase across devices, so a
	# single prompt unlocks both cryptroot and cryptdata when they share one.
	boot.initrd.systemd.enable = true;
	# /tmp in RAM: faster Nix builds and less SSD write wear. Safe with ≥16 GB.
	boot.tmp.useTmpfs = true;
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
		# First-boot password — change immediately with `passwd` after login.
		# Only used if no password has been set yet; subsequent rebuilds ignore.
		initialPassword = "changeme";
		# SSH keys authorized to log in as `will` (over tailscale0 only; see
		# firewall config below). Add new client pubkeys here to grant access.
		openssh.authorizedKeys.keys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL8l13MYCP0NBgj4OdV/Yxc1YCCQI9j81rknKYGUjsvn will.mccallion@icloud.com"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAdh4ujrVDPyEW393tSW0AbM29Yn5H96SjLG+2FSuj76 will.mccallion@icloud.com"
		];
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
			command = "Hyprland";
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

	services.syncthing = {
		enable = true;
		user = username;
		group = "users";
		dataDir = "/home/${username}";
		openDefaultPorts = true;
	};

	system.stateVersion = "25.11";
}
