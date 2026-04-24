{ pkgs, lib, ... }:

{
	home.packages = with pkgs; [
		(lib.hiPrio gcc)
		clang
		clang-tools
		cmake
		valgrind
		pkg-config
	];
}
