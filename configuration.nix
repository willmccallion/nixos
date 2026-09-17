{ pkgs, username, ... }:

{
	imports = [
		./hardware-configuration.nix
		./modules/system
	];

	# Boot
	boot.loader.systemd-boot.enable = true;
	boot.loader.systemd-boot.configurationLimit = 3;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.initrd.systemd.enable = true;
	boot.tmp.useTmpfs = true;

	# Userland TPM2 access (udev rules, tpm2-tss) for systemd-cryptenroll
	security.tpm2.enable = true;

	nixpkgs.config.allowUnfree = true;

	# Locale
	time.timeZone = "America/Edmonton";
	i18n.defaultLocale = "en_CA.UTF-8";
	services.xserver.xkb.layout = "us";

	# User
	users.users.${username} = {
		isNormalUser = true;
		description = "Will McCallion";
		extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" ];
		shell = pkgs.fish;
		initialPassword = "changeme";
		openssh.authorizedKeys.keys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL8l13MYCP0NBgj4OdV/Yxc1YCCQI9j81rknKYGUjsvn will.mccallion@icloud.com"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAdh4ujrVDPyEW393tSW0AbM29Yn5H96SjLG+2FSuj76 will.mccallion@icloud.com"
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBgCLuQVODwMFmmX6y5/HcBle4xwgwVSjFiYB7YqrEiJ will.mccallion@icloud.com"
		];
	};

	# Programs
	programs.fish.enable = true;
	programs.hyprland.enable = true;
	environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];

	# Misc services
	services.fwupd.enable = true;
	services.earlyoom.enable = true;
	services.fstrim.enable = true;
	services.smartd.enable = true;
	services.journald.settings.Journal.SystemMaxUse = "500M";

	system.stateVersion = "25.11";
}
