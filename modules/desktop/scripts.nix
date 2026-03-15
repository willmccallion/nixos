## ── Desktop Scripts ───────────────────────────────────────────────────────────
## Dynamic theming system: wallpaper picker extracts accent colors and applies
## them to waybar CSS, hyprland borders, btop theme, and fish shell colors.
## Also includes waybar helper scripts (GPU, CPU temp, network speed).
## Remove this import from desktop/default.nix to disable all dynamic theming.
{ pkgs, ... }:

let
	# Helper to create a script from a file with nix store path substitution
	mkScript = name: file: subs:
		pkgs.writeShellScriptBin name (builtins.readFile (pkgs.replaceVars file subs));

in
{
	home.packages = [
		# ── Waybar helper scripts ────────────────────────────────────────
		(pkgs.writeShellScriptBin "waybar-gpu" (builtins.readFile ./scripts/waybar-gpu.sh))

		(mkScript "waybar-cputemp" ./scripts/waybar-cputemp.sh {
			sensors = "${pkgs.lm_sensors}/bin/sensors";
			awk = "${pkgs.gawk}/bin/awk";
		})

		(mkScript "waybar-netspeed" ./scripts/waybar-netspeed.sh {
			ip = "${pkgs.iproute2}/bin/ip";
			awk = "${pkgs.gawk}/bin/awk";
			bc = "${pkgs.bc}/bin/bc";
		})

		# ── Theming scripts ──────────────────────────────────────────────
		(mkScript "apply-accent" ./scripts/apply-accent.sh {
			python = "${pkgs.python3}/bin/python3";
			hueShiftPy = ./scripts/hue-shift.py;
			fish = "${pkgs.fish}/bin/fish";
		})

		(pkgs.writeShellScriptBin "toggle-theme" (builtins.readFile ./scripts/toggle-theme.sh))

		(mkScript "wallpaper-picker" ./scripts/wallpaper-picker.sh {
			python = "${pkgs.python3}/bin/python3";
			extractAccentPy = ./scripts/extract-accent.py;
			convert = "${pkgs.imagemagick}/bin/convert";
			wofi = "${pkgs.wofi}/bin/wofi";
		})

		# ── Runtime dependencies ─────────────────────────────────────────
		pkgs.python3
		pkgs.imagemagick
		pkgs.lm_sensors
		pkgs.bc
		pkgs.iproute2
		pkgs.gawk
	];
}
