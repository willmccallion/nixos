{ pkgs, ... }:

{
	home.packages = with pkgs; [
		gh
		gnumake
		gdb
		lldb
		claude-code
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
}
