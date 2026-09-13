## ── CMPUT 415 ─────────────────────────────────────────────────────────────────
## Provides everything the generator-base CMake project expects:
##   • jre_headless  — ANTLR generator is a Java jar
##   • ANTLR_INS     — pointed at a store path assembled to match the layout
##                     that cmake/get_antlr.cmake requires:
##                       bin/antlr-4.13.0-complete.jar
##                       include/antlr4-runtime/…
##                       lib/libantlr4-runtime.a
##
## cmake, gcc, and git already come from modules/dev — don't duplicate.
{ pkgs, ... }:

let
	antlrRuntime = pkgs.antlr4_13.runtime.cpp;

	antlrJar = pkgs.fetchurl {
		url = "https://www.antlr.org/download/antlr-4.13.0-complete.jar";
		sha256 = "19p4f3jl0a34wxq7nj53xn6hl04zaq119i9605bjfni21ny4lvxw";
	};

	antlrInstall = pkgs.runCommand "antlr-install-4.13.0" { } ''
		mkdir -p $out/bin $out/lib $out/include
		ln -s ${antlrRuntime.dev}/include/antlr4-runtime $out/include/antlr4-runtime
		ln -s ${antlrRuntime}/lib/libantlr4-runtime.a    $out/lib/libantlr4-runtime.a
		ln -s ${antlrJar}                                $out/bin/antlr-4.13.0-complete.jar
	'';
in
{
	home.packages = [ pkgs.jre_headless ];

	home.sessionVariables.ANTLR_INS = "${antlrInstall}";
}
