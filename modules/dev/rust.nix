{ pkgs, ... }:

{
	home.packages = with pkgs; [
		rustc
		cargo
		rustfmt
		clippy
		rust-analyzer
		cargo-watch
		cargo-edit
		cargo-expand
	];
}
