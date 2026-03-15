## ── Fastfetch ─────────────────────────────────────────────────────────────────
## System information display with NixOS logo.
## One Dark color palette to match terminal theme.
## Remove this import from cli/default.nix to disable.
{ pkgs, ... }:

{
	home.packages = with pkgs; [
		fastfetch
	];

	xdg.configFile."fastfetch/config.jsonc".text = builtins.toJSON {
		"$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
		logo = {
			source = "nixos";
			color = {
				"1" = "blue";
				"2" = "cyan";
			};
		};
		display = {
			separator = "  ";
			key = {
				width = 8;
			};
			color = {
				keys = "blue";
				title = "cyan";
			};
		};
		modules = [
			{
				type = "title";
				format = "{user-name}@{host-name}";
			}
			{
				type = "separator";
				string = "─";
			}
			{
				type = "os";
				key = "os";
			}
			{
				type = "kernel";
				key = "kernel";
			}
			{
				type = "packages";
				key = "pkgs";
			}
			{
				type = "shell";
				key = "shell";
			}
			{
				type = "wm";
				key = "wm";
			}
			{
				type = "terminal";
				key = "term";
			}
			{
				type = "cpu";
				key = "cpu";
			}
			{
				type = "gpu";
				key = "gpu";
			}
			{
				type = "memory";
				key = "memory";
			}
			{
				type = "disk";
				key = "nvme";
				folders = "/";
			}
			{
				type = "disk";
				key = "sda";
				folders = "/data";
			}
			{
				type = "uptime";
				key = "uptime";
			}
			"break"
			{
				type = "colors";
				paddingLeft = 2;
				symbol = "circle";
			}
		];
	};
}
