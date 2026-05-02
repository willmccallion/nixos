{ username, ... }:

{
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
}
