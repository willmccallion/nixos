# Edit this configuration file to define what should be installed on your system.  Help is available in the configuration.nix(5) man page and in the NixOS manual 
# (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{ imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix 
      ./core.nix
	];


  # Bootloader.
  boot.loader.systemd-boot.enable = true; boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary networking.proxy.default = "http://user:password@proxy:port/"; networking.proxy.noProxy = 
  # "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Edmonton";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = { layout = "us"; variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.will = { isNormalUser = true; description = "Will McCallion"; extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" ]; packages = with pkgs; []; shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [
  	git
	neovim
	wget
	curl
  ];

  # Nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  programs.steam.enable = true;

  programs.fish.enable = true;
  programs.hyprland.enable = true;

  environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];

  # Some programs need SUID wrappers, can be configured further or are started in user sessions. programs.mtr.enable = true; programs.gnupg.agent = {
  #   enable = true; enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.greetd = {
  	enable = true;
	settings = {
		default_session = {
			command = "start-hyprland";
			user = "will";
		};
	};
  };
	

  # Enable the OpenSSH daemon. services.openssh.enable = true;

  # Open ports in the firewall. networking.firewall.allowedTCPPorts = [ ... ]; networking.firewall.allowedUDPPorts = [ ... ]; Or disable the firewall altogether. 
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default settings for stateful data, like file locations and database versions on your system were 
  # taken. It‘s perfectly fine and recommended to leave this value at the release version of the first install of this system. Before changing this value read the 
  # documentation for this option (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
