{ pkgs, ... }:

{
	home.packages = with pkgs; [
		rust-bindgen
		flex
		bison
		elfutils
		openssl
		bc
	];
}
