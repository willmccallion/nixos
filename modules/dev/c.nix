{ pkgs, lib, ... }:

{
	home.packages = with pkgs; [
		(lib.hiPrio gcc)
		cmake
		valgrind
		pkg-config
	];
}
