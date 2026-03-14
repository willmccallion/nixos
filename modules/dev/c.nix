{ pkgs, ... }:

{
	home.packages = with pkgs; [
		gcc
		clang-tools
		cmake
		valgrind
		pkg-config
	];
}
