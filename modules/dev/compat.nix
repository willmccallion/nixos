## ── FHS compatibility ─────────────────────────────────────────────────────────
## envfs   → resolves /bin/* and /usr/bin/* against $PATH at runtime, so shebangs
##           like `#!/bin/bash` or `#!/usr/bin/env python3` work in arbitrary
##           scripts.
## nix-ld  → provides a dynamic linker at the standard glibc path so prebuilt
##           dynamically-linked binaries (vendor tarballs, language toolchain
##           downloads, etc.) can actually execute.
{ pkgs, ... }:

{
	services.envfs.enable = true;

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
