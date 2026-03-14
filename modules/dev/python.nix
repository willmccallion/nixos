## ── Python ────────────────────────────────────────────────────────────────────
## Python development toolchain.
## Remove this import from dev/default.nix to disable.
{ pkgs, ... }:

{
	home.packages = with pkgs; [
		python3
		python3Packages.pip
	];
}
