## ── Shell ─────────────────────────────────────────────────────────────────────
## Comment out any import below to disable that component.
{ ... }:

{
	imports = [
		./fish.nix           # Fish shell core config
		./fish-functions.nix # Custom fish functions (fzf-powered utilities)
		./tmux.nix           # Terminal multiplexer
	];
}
