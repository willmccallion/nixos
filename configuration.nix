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
	boot.initrd.systemd.enable = true;
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
		extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" "docker" ];
		shell = pkgs.fish;
		initialPassword = "changeme";
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
	hardware.bluetooth = {
		enable = true;
		powerOnBoot = true;
		settings.General.Experimental = true;
	};
	services.blueman.enable = true;

	# ── Audio ─────────────────────────────────────────────────────────────
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

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
		openFirewall = false;
		settings = {
			PasswordAuthentication = false;
			PermitRootLogin = "no";
		};
	};

	virtualisation.docker.enable = true;

	services.tailscale.enable = true;
	services.fwupd.enable = true;
	services.earlyoom.enable = true;
	services.fstrim.enable = true;
	services.smartd.enable = true;
	services.journald.extraConfig = "SystemMaxUse=500M";

	services.syncthing = {
		enable = true;
		user = username;
		group = "users";
		dataDir = "/home/${username}";
		openDefaultPorts = true;

		overrideDevices = true;
		overrideFolders = true;

		settings = {
			devices.macbook = {
				id = "RGGTC2E-DKEYTPV-GGQZB4Q-JHPMDIQ-6WO77SY-IQ4E3BX-7DEHBFK-NR74TAH";
			};
			folders."6pkzo-6jk7s" = {
				label = "school-notes";
				path = "/home/${username}/school/notes";
				devices = [ "macbook" ];
				type = "sendreceive";
			};
		};
	};

	system.stateVersion = "25.11";
}
