{ pkgs, ... }:

{
	home.packages = with pkgs; [
		neovim
		gh
		gnumake
		gdb
		lldb
		claude-code
		tokei
		qemu
		docker-compose
	];

	programs.git = {
		enable = true;
		settings = {
			user.name = "Will McCallion";
			user.email = "will.mccallion@icloud.com";
			init.defaultBranch = "main";
			push.autoSetupRemote = true;
		};
	};

	programs.direnv = {
		enable = true;
		nix-direnv.enable = true;
	};
}
