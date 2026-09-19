## ── Nix ───────────────────────────────────────────────────────────────────────
## Nix language server and formatter.
## Remove this import from dev/default.nix to disable.
{ pkgs, ... }:

{
	home.packages = with pkgs; [
		nixd
		nixfmt
	];
}
