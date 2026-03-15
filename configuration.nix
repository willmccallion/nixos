{ config, pkgs, ... }:

{
	imports = [
		./hardware-configuration.nix
		./core.nix
		./modules/desktop/stylix.nix
	];

	# ── Boot ──────────────────────────────────────────────────────────────
	boot.loader.systemd-boot.enable = true;
	boot.loader.systemd-boot.configurationLimit = 3;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.loader.efi.efiSysMountPoint = "/boot/efi";
	boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

	# ── Networking ────────────────────────────────────────────────────────
	networking.hostName = "nix";
	networking.networkmanager.enable = true;

	# ── Locale ────────────────────────────────────────────────────────────
	time.timeZone = "America/Edmonton";
	i18n.defaultLocale = "en_CA.UTF-8";
	services.xserver.xkb.layout = "us";

	# ── User ──────────────────────────────────────────────────────────────
	users.users.will = {
		isNormalUser = true;
		description = "Will McCallion";
		extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" ];
		shell = pkgs.fish;
	};

	# ── Nvidia ────────────────────────────────────────────────────────────
	nixpkgs.config.allowUnfree = true;
	services.xserver.videoDrivers = [ "nvidia" ];
	hardware.graphics.enable = true;
	hardware.nvidia = {
		modesetting.enable = true;
		open = false;
		nvidiaSettings = true;
		package = config.boot.kernelPackages.nvidiaPackages.stable;
	};

	# ── Programs ──────────────────────────────────────────────────────────
	programs.steam.enable = true;
	programs.fish.enable = true;
	programs.hyprland.enable = true;
	environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];

	# ── Services ──────────────────────────────────────────────────────────
	services.greetd = {
		enable = true;
		settings.default_session = {
			command = "start-hyprland";
			user = "will";
		};
	};
	services.openssh = {
		enable = true;
		settings = {
			PasswordAuthentication = false;
			PermitRootLogin = "no";
		};
	};
	services.tailscale.enable = true;

	system.stateVersion = "25.11";
}
