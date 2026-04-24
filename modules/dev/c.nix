{ pkgs, ... }:

{
	home.packages = with pkgs; [
		gcc
		clang
		clang-tools
		cmake
		valgrind
		pkg-config
	];
}
