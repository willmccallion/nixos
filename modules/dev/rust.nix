## ── Rust ──────────────────────────────────────────────────────────────────────
## Toolchain is managed by rustup (not Nix), so `rust-toolchain.toml` files in
## kernel trees and other projects work as expected. nix-ld (see modules/dev/
## compat.nix) is what makes rustup's prebuilt binaries executable here.
##
## First-time setup after rebuild:
##   rustup default stable
## Then let each project's rust-toolchain.toml take over on `cd`.
{ pkgs, ... }:

{
	home.packages = with pkgs; [
		rustup

		# Cargo plugins that are version-agnostic and fine to pin via Nix.
		# Remove any of these if you'd rather `cargo install` them yourself.
		cargo-watch
		cargo-edit
		cargo-expand
	];
}
