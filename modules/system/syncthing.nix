{ username, ... }:

{
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
}
