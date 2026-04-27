## ── Desktop Scripts ───────────────────────────────────────────────────────────
## Dynamic theming system: wallpaper picker extracts accent colors and applies
## them to waybar CSS, hyprland borders, btop theme, fish shell colors,
## and kitty background tint.
##
## State (persistent): ~/.local/state/desktop-theme/{mode,accent}
## Entry point: apply-accent  (reads state, regenerates everything)
##
## Also includes waybar polling helpers (GPU, CPU temp, network speed).
## Remove this import from desktop/default.nix to disable all dynamic theming.
{ pkgs, ... }:

let
	mkShell = name: file: subs:
		pkgs.writeShellScriptBin name (builtins.readFile (pkgs.replaceVars file subs));

	# Python script with @placeholder@ substitution + python3 shebang.
	mkPython = name: file: subs:
		pkgs.writeScriptBin name (builtins.readFile (pkgs.replaceVars file (subs // {
			python = "${pkgs.python3}/bin/python3";
		})));

in
{
	home.packages = [
		# ── Waybar polling helpers ───────────────────────────────────────
		(pkgs.writeShellScriptBin "waybar-gpu" (builtins.readFile ./scripts/waybar-gpu.sh))

		(mkShell "waybar-cpu" ./scripts/waybar-cpu.sh {
			awk = "${pkgs.gawk}/bin/awk";
		})

		(mkShell "waybar-cputemp" ./scripts/waybar-cputemp.sh {
			sensors = "${pkgs.lm_sensors}/bin/sensors";
			awk = "${pkgs.gawk}/bin/awk";
		})

		(mkShell "waybar-netspeed" ./scripts/waybar-netspeed.sh {
			ip = "${pkgs.iproute2}/bin/ip";
			awk = "${pkgs.gawk}/bin/awk";
			bc = "${pkgs.bc}/bin/bc";
		})

		# ── Theming entry point ──────────────────────────────────────────
		(mkPython "apply-accent" ./scripts/apply-accent.py {
			fish = "${pkgs.fish}/bin/fish";
			kitty = "${pkgs.kitty}/bin/kitty";
			hyprctl = "${pkgs.hyprland}/bin/hyprctl";
			systemctl = "${pkgs.systemd}/bin/systemctl";
		})

		# ── User actions ────────────────────────────────────────────────
		(pkgs.writeShellScriptBin "toggle-theme" (builtins.readFile ./scripts/toggle-theme.sh))

		(mkPython "wallpaper-picker" ./scripts/wallpaper-picker.py {
			extractAccentPy = ./scripts/extract-accent.py;
			convert = "${pkgs.imagemagick}/bin/convert";
			wofi = "${pkgs.wofi}/bin/wofi";
			hyprpaper = "${pkgs.hyprpaper}/bin/hyprpaper";
			pkill = "${pkgs.procps}/bin/pkill";
		})

		# ── Startup hook (called from hyprland exec-once) ────────────────
		(mkShell "restore-theme" ./scripts/restore-theme.sh {
			python = "${pkgs.python3}/bin/python3";
			extractAccentPy = ./scripts/extract-accent.py;
			convert = "${pkgs.imagemagick}/bin/convert";
		})

		# ── Runtime dependencies pulled in for general use ───────────────
		pkgs.python3
		pkgs.imagemagick
		pkgs.lm_sensors
		pkgs.iproute2
		pkgs.gawk
	];
}
