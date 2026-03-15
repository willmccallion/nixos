{ pkgs, ... }:

{
	home.packages = with pkgs; [
		rust-bin.stable.latest.default
		cargo-watch
		cargo-edit
		cargo-expand
	];
}
