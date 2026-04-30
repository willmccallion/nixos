{ pkgs, ... }:

{
	programs.nix-ld.enable = true;
	programs.nix-ld.libraries = with pkgs; [
		stdenv.cc.cc.lib
		zlib
		openssl
		curl
		glib
		libxml2
		libxslt
		icu
	];
}
